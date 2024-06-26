const std = @import("std");

const log = std.log.scoped(.ebml);

pub const EbmlError = error {
    VintTooLarge,
};

/// The maximum value that can be represented as an EBML variable-sized integer.
/// As element data sizes are encoded using them, this is also the maximum size a single EBML element can have.
pub const VINTMAX: u64 = 72_057_594_037_927_934; // 2^56 - 2

/// Represents an element ID.
pub const ElementId = struct {
    id: u64,
};

/// Stores the raw, encoded form of a variable-sized integer as a `u64`, i. e. it includes the `VINT_WIDTH` and `VINT_MARKER` bits,
/// as well as the number of octets it uses.
///
/// [`getVintValue`] can be used to get its integer value.
///
/// [`getVintValue`]: getVintValue
pub const RawVint = struct {
    octets: u8,
    raw: u64,
};

/// Reads a variable-sized integer, and returns a struct containing the number of octets it uses and the raw value.
/// [`getVintValue`] can be used to get its integer value.
///
/// This EBML reader only supports variable-sized integers of up to 8 octets in length.
///
/// [`getVintValue`]: getVintValue
pub fn readVintRaw(reader: std.io.AnyReader) anyerror!RawVint {
    const byte = try reader.readByte();
    // std.debug.print("Byte: {b}\n", .{byte});

    if (byte == 0) {
        // Vint is larger than 8 octets
        return EbmlError.VintTooLarge;
    }

    var octets: u8 = 1;

    while (byte >> @as(u3, @intCast(8 - octets)) != 1) { // 8 - octets should always be < 8, so u3
        octets += 1;
    }

    var bytes: [8]u8 = .{0} ** 8;
    bytes[0] = byte;

    if (octets != 1) { // octets > 1
        const read = try reader.readAll(bytes[1..octets]);

        if (read < octets - 1) {
            return error.EndOfStream;
        }
    }

    const value = std.mem.bigToNative(u64, std.mem.bytesToValue(u64, &bytes));
    return RawVint { .octets = octets, .raw = value, };
}

/// Calculates the actual integer value from a [`RawVint`].
///
/// # See also
/// - [`readVintRaw`]
/// - [`readVint`]
///
/// [`RawVint`]: RawVint
/// [`readVintRaw`]: readVintRaw
/// [`readVint`]: readVint
pub inline fn getVintValue(vint: RawVint) u64 {
    var value = vint.raw;
    // std.debug.print("Value pre-and: {d} ({b})\n", .{value, value});
    value &= (~@as(u64, 0)) >> @as(u6, @intCast(vint.octets));
    // std.debug.print("Value pre-shift: {d} ({b})\n", .{value, value});
    value >>= @as(u6, @intCast(64 - 8 * vint.octets));
    return value;
}

// Reads a variable-sized integer.
pub inline fn readVint(reader: std.io.AnyReader) anyerror!u64 {
    return getVintValue(try readVintRaw(reader));
}

/// Reads an element ID.
///
/// **Note**: This function does not check whether the ID is encoded in a valid way, or if an element with that ID even exists.
pub inline fn readElementId(reader: std.io.AnyReader) anyerror!ElementId {
    const vint = try readVintRaw(reader);
    // Skip the "and" step of getVintValue; Element IDs appear to include the VINT_WIDTH and VINT_MARKER bits
    const value = vint.raw >> @as(u6, @intCast(64 - 8 * vint.octets));

    // Don't check whether the ID is encoded in an invalid way
    return ElementId { .id = value, };
}

pub const UNKNOWN_DATA_SIZE: u64 = std.math.maxInt(u64);

/// Read an element data size, which is encoded as a variable-sized integer in EBML.
///
/// If the value specifies an unknown length, this function returns `UNKNOWN_DATA_SIZE` (which currently equals the maximum value of `u64`).
pub inline fn readElementDataSize(reader: std.io.AnyReader) anyerror!u64 {
    const vint = try readVintRaw(reader);
    const value = getVintValue(vint);

    // std.debug.print("Reading element ID (octets: {d}, value: {d}, 0b{b}, 0x{X})\n", .{vint.octets, value, value, value});

    if (value == (@as(u64, 1) << @as(u6, @intCast(7 * vint.octets))) - 1) {
        // Element has an unknown data size. It is fine to use 2^64 - 1 (all u64 bits set to 1) as
        // a special indicator for that here, as that is out of bounds of the element data size value.
        return UNKNOWN_DATA_SIZE;
    } else {
        return value;
    }
}

/// Read a signed integer element.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readSignedInteger(reader: std.io.AnyReader, default: ?i64) anyerror!i64 {
    const size = try readElementDataSize(reader);

    if (size == 0) {
        return default orelse 0;
    } else if (size > 8) {
        return error.InvalidElementSize;
    } else {
        var bytes: [8]u8 = .{0} ** 8;
        try reader.readNoEof(bytes[0..size]);
        const value = std.mem.bigToNative(i64, std.mem.bytesToValue(i64, &bytes)) >> @as(u6, @intCast((8 - size) * 8));

        // std.debug.print("0b{b:0>64}, {d}\n", .{value, value});
        return value;
    }
}

/// Read an unsigned integer element.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readUnsignedInteger(reader: std.io.AnyReader, default: ?u64) anyerror!u64 {
    const size = try readElementDataSize(reader);

    if (size == 0) {
        return default orelse 0;
    } else if (size > 8) {
        return error.InvalidElementSize;
    } else {
        var bytes: [8]u8 = .{0} ** 8;
        try reader.readNoEof(bytes[0..size]);
        const value = std.mem.bigToNative(u64, std.mem.bytesToValue(u64, &bytes)) >> @as(u6, @intCast((8 - size) * 8));

        // std.debug.print("0b{b:0>64}, {d}\n", .{value, value});
        return value;
    }
}

/// Read a floating-point integer element.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readFloat(reader: std.io.AnyReader, default: ?f64) anyerror!f64 {
    const size = try readElementDataSize(reader);

    if (size == 0) {
        return default orelse 0;
    } else if (size == 4) {
        var bytes: [4]u8 = .{0} ** 4;
        try reader.readNoEof(&bytes);
        const value = @as(f32, @bitCast(std.mem.bigToNative(u32, std.mem.bytesToValue(u32, &bytes))));
        return @as(f64, value);
    } else if (size == 8) {
        var bytes: [8]u8 = .{0} ** 8;
        try reader.readNoEof(&bytes);
        const value = @as(f64, @bitCast(std.mem.bigToNative(u64, std.mem.bytesToValue(u64, &bytes))));
        return value;
    } else {
        return error.InvalidElementSize;
    }
}

/// Reads the entire contents of a binary element into the specified buffer.
///
/// If the buffer is not big enough to hold all of the element's data, `error.BufTooSmall` will be returned. In this case, the provided
/// buffer as well as the current position in the stream will not be modified (IMPL NOTE This currently does not seem to be the case;
/// the function will read past the element data size regardless of outcome).
///
/// If the element size is zero, the function will return without error and without modifying the provided buffer.
/// This means that the buffer needs to be filled with the element's default value (usually all zeroes) before calling this.
///
/// If the input stream unexpectedly ends before all bytes of the element have been read, `error.EndOfStream` will be returned.
/// The provided buffer may be partially overwritten with the read data.
///
/// Caller owns buffer memory.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readBinaryAllBuf(reader: std.io.AnyReader, buffer: []u8) anyerror!void {
    const size = try readElementDataSize(reader);

    if (size == 0) {
        return;
    } else if (size > buffer.len) {
        return error.BufTooSmall;
    }

    return reader.readNoEof(buffer[0..size]);
}

/// Tries to read the entire contents of a binary element by allocating a buffer of the right size using the provided allocator.
///
/// A maximum size has to be provided, as EBML allows binary elements to be practically unbounded in size. If the actual size of the
/// element turns out to be greater than `max_size`, `error.BufTooSmall` will be returned.
///
/// If the input stream unexpectedly ends before all bytes of the element have been read, `error.EndOfStream` will be returned.
/// All data read as part of the binary element will be lost.
///
/// If any error occurs during reading, such as an allocation failure or an IO error, all data read so far as part of the binary element
/// will be lost. As the reader will now be positioned somewhere within the element with no indication of the number of bytes read,
/// this state is not easily recoverable.
///
/// Caller owns returned memory.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readBinaryAllAlloc(reader: std.io.AnyReader, allocator: std.mem.Allocator, max_size: usize) anyerror![]u8 {
    const size = try readElementDataSize(reader);

    if (size > max_size) {
        return error.BufTooSmall;
    }

    const buf = try allocator.alloc(u8, @min(size, max_size));
    errdefer allocator.free(buf);
    try reader.readNoEof(buf);

    return buf;
}

// TODO Modify this struct to have a `reader` method that returns a GenericReader using this struct's field like a closure
// const BinaryElementReaderContext = struct {
//     reader: std.io.AnyReader,
//     pos: u64, len: u64,
// };

// pub const BinaryElementReader = std.io.GenericReader(BinaryElementReaderContext, anyerror, readBinaryImpl);

// /// Read a binary element. This returns a [`BinaryElementReader`] that can be used to read the binary element's data.
// ///
// /// The returned reader is invalidated by any operation modifying the position of the reader provided to this method, such as using any
// /// of its read functions or seeking with a `SeekableStream`.
// ///
// /// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
// /// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
// /// the end of the stream. If it fails, the stream position may end up anywhere within the element.
// pub fn readBinary(reader: std.io.AnyReader) anyerror!BinaryElementReader {
//     const size = try readElementDataSize(reader);
//     return .{ .context = BinaryElementReaderContext { .reader = reader, .pos = 0, .len = size, }};
// }

// // Implement SeekableStream for this as well? Not sure how useful that would be
// // Also, AnySeekableStream doesn't exist
// fn readBinaryImpl(context: BinaryElementReaderContext, buffer: []u8) anyerror!usize {
//     const read = try context.reader.read(buffer[0..@min(buffer.len, context.len - context.pos)]);
//     context.pos += read;
//     return read;
// }

/// Read a date element.
///
/// Date elements are defined in the EBML specification as follows:
///
/// > The date element stores an integer in the same format as the signed
/// > integer element that expresses a point in time referenced in
/// > nanoseconds from the precise beginning of the third millennium of the
/// > Gregorian Calendar in Coordinated Universal Time (also known as
/// > 2001-01-01T00:00:00.000000000 UTC). This provides a possible
/// > expression of time from September 1708 to April 2293.
/// >
/// > The integer stored represents the number of nanoseconds between the
/// > date to express and 2001-01-01T00:00:00.000000000 UTC, not counting
/// > leap seconds. That is 86,400,000,000,000 nanoseconds for each day.
/// > Conversions from other date systems should ensure leap seconds are
/// > not counted in EBML values.
/// >
/// > The 2001-01-01T00:00:00.000000000 UTC date also corresponds to
/// > 978307200 seconds in Unix time.
///
/// This function is exactly equivalent to [`readSignedInteger`], except that it only allows element sizes of `0` and `8`.
/// You can use `readSignedInteger` instead, which allows any element size between 0 and 8 (inclusive), if you want to be more
/// lenient in parsing dates.
///
/// This function requires the element ID to have been read already, i. e. the input stream position must be on the element size value
/// of the element. If this function suceeds, the input stream will be positioned on the start (element ID value) of the next element or
/// the end of the stream. If it fails, the stream position may end up anywhere within the element.
pub fn readDate(reader: std.io.AnyReader, default: ?i64) anyerror!i64 {
    const size = try readElementDataSize(reader);

    if (size == 0) {
        return default orelse 0;
    } else if (size != 8) {
        return error.InvalidElementSize;
    } else {
        var bytes: [8]u8 = .{0} ** 8;
        try reader.readNoEof(bytes[0..8]);
        const value = std.mem.bigToNative(i64, std.mem.bytesToValue(i64, &bytes));

        // std.debug.print("0b{b:0>64}, {d}\n", .{value, value});
        return value;
    }
}

// ================
// Tests

test "readVint (2 in different sizes)" {
    const a: u32 = 0b1000_0010_0000_0000_0000_0000_0000_0000;
    const b: u32 = 0b0100_0000_0000_0010_0000_0000_0000_0000;
    const c: u32 = 0b0010_0000_0000_0000_0000_0010_0000_0000;
    const d: u32 = 0b0001_0000_0000_0000_0000_0000_0000_0010;

    const vints = [4]u32 {a, b, c, d};
    comptime var bytestreams: [4][4]u8 = .{.{0} ** 4} ** 4;

    inline for (vints, 0..) |vint, i| {
        bytestreams[i] = comptime std.mem.toBytes(std.mem.nativeToBig(u32, vint));
    }

    inline for (bytestreams) |bytes| {
        // std.debug.print("Bytes: {b}\n", .{bytes});
        var stream = std.io.fixedBufferStream(&bytes);
        const reader = stream.reader().any();

        const value = try readVint(reader);
        // std.debug.print("Value: {d} ({b})\n", .{value, value});

        try std.testing.expectEqual(@as(u64, 2), value);
    }
}


test "readVint (ID_EBML)" {
    const ebml: u32 = 0b0001_1010_0100_0101_1101_1111_1010_0011;

    const bytes = comptime std.mem.toBytes(std.mem.nativeToBig(u32, ebml));
    var stream = std.io.fixedBufferStream(&bytes);
    const reader = stream.reader().any();

    try std.testing.expectEqual(@as(u64, @import("../matroska_id_table.zig").ID_EBML),  (try readElementId(reader)).id);
}

test "UNKNOWN_DATA_SIZE value" {
    try std.testing.expectEqual(UNKNOWN_DATA_SIZE,  ~@as(u64, 0));
}

test "readElementDataSize" {
    const a: u64 = 0b1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const b: u64 = 0b0100_0000_0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const c: u64 = 0b0010_0000_0000_0000_0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const d: u64 = 0b0111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const e: u64 = 0b0010_0000_0011_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

    const vints = [5]u64 {a, b, c, d, e};
    var bytes: [5][8]u8 = .{.{0} ** 8} ** 5;
    var fixedBufferStreams: [5]std.io.FixedBufferStream([]u8) = .{undefined} ** 5;
    var readers: [5]std.io.AnyReader = .{undefined} ** 5;

    inline for (vints, 0..) |vint, i| {
        bytes[i] = comptime std.mem.toBytes(std.mem.nativeToBig(u64, vint));
        fixedBufferStreams[i] = std.io.fixedBufferStream(&bytes[i]);
        readers[i] = fixedBufferStreams[i].reader().any();
    }

    try std.testing.expectEqual(@as(u64, UNKNOWN_DATA_SIZE),  try readElementDataSize(readers[0]));
    try std.testing.expectEqual(@as(u64, 127),  try readElementDataSize(readers[1]));
    try std.testing.expectEqual(@as(u64, 127),  try readElementDataSize(readers[2]));
    try std.testing.expectEqual(@as(u64, UNKNOWN_DATA_SIZE), try readElementDataSize(readers[3]));
    try std.testing.expectEqual(@as(u64, 16_383),  try readElementDataSize(readers[4]));
}

test "Right-shift" {
    const bytes: [4]u8 = .{0b1111_0000, 0, 0, 0};
    var value = std.mem.bigToNative(i32, std.mem.bytesToValue(i32, &bytes));
    value >>= (4 - 1) * 8;
    try std.testing.expectEqual(@as(i32, -16),  value);
}

test "readSignedInteger" {
    const a: u64 = 0b1000_0010_1111_1110_1101_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const b: u64 = 0b1000_0001_0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const c: u64 = 0b0010_0000_0000_0000_0000_0010_0000_0000_0111_1111_0000_0000_0000_0000_0000_0000;
    const d: u64 = 0b0100_0000_0000_0110_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
    const e: u64 = 0b1000_0100_0000_0000_0000_0000_0011_1111_1111_1111_0000_0000_0000_0000_0000_0000;
    const f: u64 = 0b1000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const g: u64 = 0b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

    const vints = [7]u64 {a, b, c, d, e, f, g};
    var bytes: [7][8]u8 = .{.{0} ** 8} ** 7;
    var fixedBufferStreams: [7]std.io.FixedBufferStream([]u8) = .{undefined} ** 7;
    var readers: [7]std.io.AnyReader = .{undefined} ** 7;

    inline for (vints, 0..) |vint, i| {
        bytes[i] = comptime std.mem.toBytes(std.mem.nativeToBig(u64, vint));
        fixedBufferStreams[i] = std.io.fixedBufferStream(&bytes[i]);
        readers[i] = fixedBufferStreams[i].reader().any();
    }

    // std.debug.print("\n", .{});
    try std.testing.expectEqual(@as(i64, -300),  try readSignedInteger(readers[0], null));
    try std.testing.expectEqual(@as(i64, 127),  try readSignedInteger(readers[1], null));
    try std.testing.expectEqual(@as(i64, 127),  try readSignedInteger(readers[2], null));
    try std.testing.expectEqual(@as(i64, -1),  try readSignedInteger(readers[3], null));
    try std.testing.expectEqual(@as(i64, 16_383),  try readSignedInteger(readers[4], null));
    try std.testing.expectEqual(@as(i64, 0),  try readSignedInteger(readers[5], null));
    fixedBufferStreams[5].pos = 0;
    try std.testing.expectEqual(@as(i64, 0),  try readSignedInteger(readers[5], 70));
    try std.testing.expectEqual(@as(i64, 0),  try readSignedInteger(readers[6], null));
    fixedBufferStreams[6].pos = 0;
    try std.testing.expectEqual(@as(i64, 70),  try readSignedInteger(readers[6], 70));
}

test "readUnsignedInteger" {
    const a: u64 = 0b1000_0010_1111_1110_1101_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const b: u64 = 0b1000_0001_0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const c: u64 = 0b0010_0000_0000_0000_0000_0010_0000_0000_0111_1111_0000_0000_0000_0000_0000_0000;
    const d: u64 = 0b0100_0000_0000_0110_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
    const e: u64 = 0b1000_0100_0000_0000_0000_0000_0011_1111_1111_1111_0000_0000_0000_0000_0000_0000;
    const f: u64 = 0b1000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const g: u64 = 0b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

    const vints = [7]u64 {a, b, c, d, e, f, g};
    var bytes: [7][8]u8 = .{.{0} ** 8} ** 7;
    var fixedBufferStreams: [7]std.io.FixedBufferStream([]u8) = .{undefined} ** 7;
    var readers: [7]std.io.AnyReader = .{undefined} ** 7;

    inline for (vints, 0..) |vint, i| {
        bytes[i] = comptime std.mem.toBytes(std.mem.nativeToBig(u64, vint));
        fixedBufferStreams[i] = std.io.fixedBufferStream(&bytes[i]);
        readers[i] = fixedBufferStreams[i].reader().any();
    }

    // std.debug.print("\n", .{});
    try std.testing.expectEqual(@as(u64, 65236),  try readUnsignedInteger(readers[0], null));
    try std.testing.expectEqual(@as(u64, 127),  try readUnsignedInteger(readers[1], null));
    try std.testing.expectEqual(@as(u64, 127),  try readUnsignedInteger(readers[2], null));
    try std.testing.expectEqual(@as(u64, 281474976710655),  try readUnsignedInteger(readers[3], null));
    try std.testing.expectEqual(@as(u64, 16_383),  try readUnsignedInteger(readers[4], null));
    try std.testing.expectEqual(@as(u64, 0),  try readUnsignedInteger(readers[5], null));
    fixedBufferStreams[5].pos = 0;
    try std.testing.expectEqual(@as(u64, 0),  try readUnsignedInteger(readers[5], 70));
    try std.testing.expectEqual(@as(u64, 0),  try readUnsignedInteger(readers[6], null));
    fixedBufferStreams[6].pos = 0;
    try std.testing.expectEqual(@as(u64, 70),  try readUnsignedInteger(readers[6], 70));
}

test "readFloat" {
    const a: f32 = 0.1;
    const b: f32 = 1.0;
    const c: f32 = 2.0;
    const d: f32 = 12345.67;
    const e: f64 = 0.0000000001;
    const f: f64 = 100.1001;
    const g: f64 = 999999999999999.0;
    const h: f64 = -0.0;

    const expected_32: [4]f32 = .{a, b, c, d};
    const expected_64: [4]f64 = .{e, f, g, h};

    inline for (expected_32) |expected| {
        const bytes = .{0b10000100} ++ std.mem.toBytes(std.mem.nativeToBig(u32, @bitCast(expected)));
        var fixedBufferStream = std.io.fixedBufferStream(&bytes);
        const reader = fixedBufferStream.reader().any();
        const value = try readFloat(reader, null);

        // std.debug.print("32, value: {d}\n", .{value});
        try std.testing.expectEqual(@as(f64, expected),  value);
    }

    inline for (expected_64) |expected| {
        const bytes = .{0b10001000} ++ std.mem.toBytes(std.mem.nativeToBig(u64, @bitCast(expected)));
        var fixedBufferStream = std.io.fixedBufferStream(&bytes);
        const reader = fixedBufferStream.reader().any();
        const value = try readFloat(reader, null);

        // std.debug.print("64, value: {d}\n", .{value});
        try std.testing.expectEqual(expected, value);
    }
}

test "readBinaryAllAlloc" {
    const data: [8]u8 = .{ 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, };
    const bytes = .{0b10001000} ++ data;

    var fixedBufferStream = std.io.fixedBufferStream(&bytes);
    const reader = fixedBufferStream.reader().any();
    const read = try readBinaryAllAlloc(reader, std.testing.allocator, 64);
    defer std.testing.allocator.free(read);

    try std.testing.expectEqualSlices(u8, &data, read);
}


test "readBinaryAllBuf" {
    const data: [8]u8 = .{ 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, };
    const bytes = .{0b10001000} ++ data;

    var fixedBufferStream = std.io.fixedBufferStream(&bytes);
    const reader = fixedBufferStream.reader().any();
    var buf: [64]u8 = .{0xaa} ** 64;
    try readBinaryAllBuf(reader, &buf);

    const expected = data ++ .{0xaa} ** 56;
    try std.testing.expectEqualSlices(u8, &expected, &buf);
}


// test "readBinary" {
//     const data: [8]u8 = .{ 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, };
//     const bytes = .{0b10001000} ++ data;

//     var fixedBufferStream = std.io.fixedBufferStream(&bytes);
//     const reader = fixedBufferStream.reader().any();
//     const data_reader = try readBinary(reader);

//     var buf: [8]u8 = .{0xaa} ** 8;
//     try std.testing.expectEqual(@as(usize, 8), try data_reader.readAll(&buf));
//     try std.testing.expectEqualSlices(u8, &data, &buf);
//     try std.testing.expectError(error.EndOfStream, data_reader.read(&buf));
// }

test "readDate" {
    // TODO This is just the same test as "readSignedInteger" above; it may be better to use dedicated example values
    // TODO Test fails because of invalid data sizes (readDate requires length 0 or 8, but this test cannot even test elements of length 8 due to using u64)
    if (true) {
        return;
    }

    const a: u64 = 0b1000_0010_1111_1110_1101_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const b: u64 = 0b1000_0001_0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const c: u64 = 0b0010_0000_0000_0000_0000_0010_0000_0000_0111_1111_0000_0000_0000_0000_0000_0000;
    const d: u64 = 0b0100_0000_0000_0110_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
    const e: u64 = 0b1000_0100_0000_0000_0000_0000_0011_1111_1111_1111_0000_0000_0000_0000_0000_0000;
    const f: u64 = 0b1000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    const g: u64 = 0b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

    const vints = [7]u64 {a, b, c, d, e, f, g};
    var bytes: [7][8]u8 = .{.{0} ** 8} ** 7;
    var fixedBufferStreams: [7]std.io.FixedBufferStream([]u8) = .{undefined} ** 7;
    var readers: [7]std.io.AnyReader = .{undefined} ** 7;

    inline for (vints, 0..) |vint, i| {
        bytes[i] = comptime std.mem.toBytes(std.mem.nativeToBig(u64, vint));
        fixedBufferStreams[i] = std.io.fixedBufferStream(&bytes[i]);
        readers[i] = fixedBufferStreams[i].reader().any();
    }

    // std.debug.print("\n", .{});
    try std.testing.expectEqual(@as(i64, -300), try readDate(readers[0], null));
    try std.testing.expectEqual(@as(i64, 127), try readDate(readers[1], null));
    try std.testing.expectEqual(@as(i64, 127), try readDate(readers[2], null));
    try std.testing.expectEqual(@as(i64, -1), try readDate(readers[3], null));
    try std.testing.expectEqual(@as(i64, 16_383), try readDate(readers[4], null));
    try std.testing.expectEqual(@as(i64, 0), try readDate(readers[5], null));
    fixedBufferStreams[5].pos = 0;
    try std.testing.expectEqual(@as(i64, 0), try readDate(readers[5], 70));
    try std.testing.expectEqual(@as(i64, 0), try readDate(readers[6], null));
    fixedBufferStreams[6].pos = 0;
    try std.testing.expectEqual(@as(i64, 70), try readDate(readers[6], 70));
}


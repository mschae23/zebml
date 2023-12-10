// This file is auto-generated.

pub const IdInfo = struct {
    id: u32,
    name: []const u8,
};

pub const elements = [_]IdInfo {
    IdInfo { .id = 0x1A45DFA3, .name = "EBML", },
    IdInfo { .id = 0x4286, .name = "EBMLVersion", },
    IdInfo { .id = 0x42F7, .name = "EBMLReadVersion", },
    IdInfo { .id = 0x42F2, .name = "EBMLMaxIDLength", },
    IdInfo { .id = 0x42F3, .name = "EBMLMaxSizeLength", },
    IdInfo { .id = 0x4282, .name = "DocType", },
    IdInfo { .id = 0x4287, .name = "DocTypeVersion", },
    IdInfo { .id = 0x4285, .name = "DocTypeReadVersion", },
    IdInfo { .id = 0x4281, .name = "DocTypeExtension", },
    IdInfo { .id = 0x4283, .name = "DocTypeExtensionName", },
    IdInfo { .id = 0x4284, .name = "DocTypeExtensionVersion", },
    IdInfo { .id = 0xEC, .name = "Void", },
    IdInfo { .id = 0xBF, .name = "CRC32", },
    IdInfo { .id = 0x18538067, .name = "Segment", },
    IdInfo { .id = 0x114D9B74, .name = "SeekHead", },
    IdInfo { .id = 0x4DBB, .name = "Seek", },
    IdInfo { .id = 0x53AB, .name = "SeekID", },
    IdInfo { .id = 0x53AC, .name = "SeekPosition", },
    IdInfo { .id = 0x1549A966, .name = "Info", },
    IdInfo { .id = 0x73A4, .name = "SegmentUUID", },
    IdInfo { .id = 0x7384, .name = "SegmentFilename", },
    IdInfo { .id = 0x3CB923, .name = "PrevUUID", },
    IdInfo { .id = 0x3C83AB, .name = "PrevFilename", },
    IdInfo { .id = 0x3EB923, .name = "NextUUID", },
    IdInfo { .id = 0x3E83BB, .name = "NextFilename", },
    IdInfo { .id = 0x4444, .name = "SegmentFamily", },
    IdInfo { .id = 0x6924, .name = "ChapterTranslate", },
    IdInfo { .id = 0x69A5, .name = "ChapterTranslateID", },
    IdInfo { .id = 0x69BF, .name = "ChapterTranslateCodec", },
    IdInfo { .id = 0x69FC, .name = "ChapterTranslateEditionUID", },
    IdInfo { .id = 0x2AD7B1, .name = "TimestampScale", },
    IdInfo { .id = 0x4489, .name = "Duration", },
    IdInfo { .id = 0x4461, .name = "DateUTC", },
    IdInfo { .id = 0x7BA9, .name = "Title", },
    IdInfo { .id = 0x4D80, .name = "MuxingApp", },
    IdInfo { .id = 0x5741, .name = "WritingApp", },
    IdInfo { .id = 0x1F43B675, .name = "Cluster", },
    IdInfo { .id = 0xE7, .name = "Timestamp", },
    IdInfo { .id = 0x5854, .name = "SilentTracks", },
    IdInfo { .id = 0x58D7, .name = "SilentTrackNumber", },
    IdInfo { .id = 0xA7, .name = "Position", },
    IdInfo { .id = 0xAB, .name = "PrevSize", },
    IdInfo { .id = 0xA3, .name = "SimpleBlock", },
    IdInfo { .id = 0xA0, .name = "BlockGroup", },
    IdInfo { .id = 0xA1, .name = "Block", },
    IdInfo { .id = 0xA2, .name = "BlockVirtual", },
    IdInfo { .id = 0x75A1, .name = "BlockAdditions", },
    IdInfo { .id = 0xA6, .name = "BlockMore", },
    IdInfo { .id = 0xA5, .name = "BlockAdditional", },
    IdInfo { .id = 0xEE, .name = "BlockAddID", },
    IdInfo { .id = 0x9B, .name = "BlockDuration", },
    IdInfo { .id = 0xFA, .name = "ReferencePriority", },
    IdInfo { .id = 0xFB, .name = "ReferenceBlock", },
    IdInfo { .id = 0xFD, .name = "ReferenceVirtual", },
    IdInfo { .id = 0xA4, .name = "CodecState", },
    IdInfo { .id = 0x75A2, .name = "DiscardPadding", },
    IdInfo { .id = 0x8E, .name = "Slices", },
    IdInfo { .id = 0xE8, .name = "TimeSlice", },
    IdInfo { .id = 0xCC, .name = "LaceNumber", },
    IdInfo { .id = 0xCD, .name = "FrameNumber", },
    IdInfo { .id = 0xCB, .name = "BlockAdditionID", },
    IdInfo { .id = 0xCE, .name = "Delay", },
    IdInfo { .id = 0xCF, .name = "SliceDuration", },
    IdInfo { .id = 0xC8, .name = "ReferenceFrame", },
    IdInfo { .id = 0xC9, .name = "ReferenceOffset", },
    IdInfo { .id = 0xCA, .name = "ReferenceTimestamp", },
    IdInfo { .id = 0xAF, .name = "EncryptedBlock", },
    IdInfo { .id = 0x1654AE6B, .name = "Tracks", },
    IdInfo { .id = 0xAE, .name = "TrackEntry", },
    IdInfo { .id = 0xD7, .name = "TrackNumber", },
    IdInfo { .id = 0x73C5, .name = "TrackUID", },
    IdInfo { .id = 0x83, .name = "TrackType", },
    IdInfo { .id = 0xB9, .name = "FlagEnabled", },
    IdInfo { .id = 0x88, .name = "FlagDefault", },
    IdInfo { .id = 0x55AA, .name = "FlagForced", },
    IdInfo { .id = 0x55AB, .name = "FlagHearingImpaired", },
    IdInfo { .id = 0x55AC, .name = "FlagVisualImpaired", },
    IdInfo { .id = 0x55AD, .name = "FlagTextDescriptions", },
    IdInfo { .id = 0x55AE, .name = "FlagOriginal", },
    IdInfo { .id = 0x55AF, .name = "FlagCommentary", },
    IdInfo { .id = 0x9C, .name = "FlagLacing", },
    IdInfo { .id = 0x6DE7, .name = "MinCache", },
    IdInfo { .id = 0x6DF8, .name = "MaxCache", },
    IdInfo { .id = 0x23E383, .name = "DefaultDuration", },
    IdInfo { .id = 0x234E7A, .name = "DefaultDecodedFieldDuration", },
    IdInfo { .id = 0x23314F, .name = "TrackTimestampScale", },
    IdInfo { .id = 0x537F, .name = "TrackOffset", },
    IdInfo { .id = 0x55EE, .name = "MaxBlockAdditionID", },
    IdInfo { .id = 0x41E4, .name = "BlockAdditionMapping", },
    IdInfo { .id = 0x41F0, .name = "BlockAddIDValue", },
    IdInfo { .id = 0x41A4, .name = "BlockAddIDName", },
    IdInfo { .id = 0x41E7, .name = "BlockAddIDType", },
    IdInfo { .id = 0x41ED, .name = "BlockAddIDExtraData", },
    IdInfo { .id = 0x536E, .name = "Name", },
    IdInfo { .id = 0x22B59C, .name = "Language", },
    IdInfo { .id = 0x22B59D, .name = "LanguageBCP47", },
    IdInfo { .id = 0x86, .name = "CodecID", },
    IdInfo { .id = 0x63A2, .name = "CodecPrivate", },
    IdInfo { .id = 0x258688, .name = "CodecName", },
    IdInfo { .id = 0x7446, .name = "AttachmentLink", },
    IdInfo { .id = 0x3A9697, .name = "CodecSettings", },
    IdInfo { .id = 0x3B4040, .name = "CodecInfoURL", },
    IdInfo { .id = 0x26B240, .name = "CodecDownloadURL", },
    IdInfo { .id = 0xAA, .name = "CodecDecodeAll", },
    IdInfo { .id = 0x6FAB, .name = "TrackOverlay", },
    IdInfo { .id = 0x56AA, .name = "CodecDelay", },
    IdInfo { .id = 0x56BB, .name = "SeekPreRoll", },
    IdInfo { .id = 0x6624, .name = "TrackTranslate", },
    IdInfo { .id = 0x66A5, .name = "TrackTranslateTrackID", },
    IdInfo { .id = 0x66BF, .name = "TrackTranslateCodec", },
    IdInfo { .id = 0x66FC, .name = "TrackTranslateEditionUID", },
    IdInfo { .id = 0xE0, .name = "Video", },
    IdInfo { .id = 0x9A, .name = "FlagInterlaced", },
    IdInfo { .id = 0x9D, .name = "FieldOrder", },
    IdInfo { .id = 0x53B8, .name = "StereoMode", },
    IdInfo { .id = 0x53C0, .name = "AlphaMode", },
    IdInfo { .id = 0x53B9, .name = "OldStereoMode", },
    IdInfo { .id = 0xB0, .name = "PixelWidth", },
    IdInfo { .id = 0xBA, .name = "PixelHeight", },
    IdInfo { .id = 0x54AA, .name = "PixelCropBottom", },
    IdInfo { .id = 0x54BB, .name = "PixelCropTop", },
    IdInfo { .id = 0x54CC, .name = "PixelCropLeft", },
    IdInfo { .id = 0x54DD, .name = "PixelCropRight", },
    IdInfo { .id = 0x54B0, .name = "DisplayWidth", },
    IdInfo { .id = 0x54BA, .name = "DisplayHeight", },
    IdInfo { .id = 0x54B2, .name = "DisplayUnit", },
    IdInfo { .id = 0x54B3, .name = "AspectRatioType", },
    IdInfo { .id = 0x2EB524, .name = "UncompressedFourCC", },
    IdInfo { .id = 0x2FB523, .name = "GammaValue", },
    IdInfo { .id = 0x2383E3, .name = "FrameRate", },
    IdInfo { .id = 0x55B0, .name = "Colour", },
    IdInfo { .id = 0x55B1, .name = "MatrixCoefficients", },
    IdInfo { .id = 0x55B2, .name = "BitsPerChannel", },
    IdInfo { .id = 0x55B3, .name = "ChromaSubsamplingHorz", },
    IdInfo { .id = 0x55B4, .name = "ChromaSubsamplingVert", },
    IdInfo { .id = 0x55B5, .name = "CbSubsamplingHorz", },
    IdInfo { .id = 0x55B6, .name = "CbSubsamplingVert", },
    IdInfo { .id = 0x55B7, .name = "ChromaSitingHorz", },
    IdInfo { .id = 0x55B8, .name = "ChromaSitingVert", },
    IdInfo { .id = 0x55B9, .name = "Range", },
    IdInfo { .id = 0x55BA, .name = "TransferCharacteristics", },
    IdInfo { .id = 0x55BB, .name = "Primaries", },
    IdInfo { .id = 0x55BC, .name = "MaxCLL", },
    IdInfo { .id = 0x55BD, .name = "MaxFALL", },
    IdInfo { .id = 0x55D0, .name = "MasteringMetadata", },
    IdInfo { .id = 0x55D1, .name = "PrimaryRChromaticityX", },
    IdInfo { .id = 0x55D2, .name = "PrimaryRChromaticityY", },
    IdInfo { .id = 0x55D3, .name = "PrimaryGChromaticityX", },
    IdInfo { .id = 0x55D4, .name = "PrimaryGChromaticityY", },
    IdInfo { .id = 0x55D5, .name = "PrimaryBChromaticityX", },
    IdInfo { .id = 0x55D6, .name = "PrimaryBChromaticityY", },
    IdInfo { .id = 0x55D7, .name = "WhitePointChromaticityX", },
    IdInfo { .id = 0x55D8, .name = "WhitePointChromaticityY", },
    IdInfo { .id = 0x55D9, .name = "LuminanceMax", },
    IdInfo { .id = 0x55DA, .name = "LuminanceMin", },
    IdInfo { .id = 0x7670, .name = "Projection", },
    IdInfo { .id = 0x7671, .name = "ProjectionType", },
    IdInfo { .id = 0x7672, .name = "ProjectionPrivate", },
    IdInfo { .id = 0x7673, .name = "ProjectionPoseYaw", },
    IdInfo { .id = 0x7674, .name = "ProjectionPosePitch", },
    IdInfo { .id = 0x7675, .name = "ProjectionPoseRoll", },
    IdInfo { .id = 0xE1, .name = "Audio", },
    IdInfo { .id = 0xB5, .name = "SamplingFrequency", },
    IdInfo { .id = 0x78B5, .name = "OutputSamplingFrequency", },
    IdInfo { .id = 0x9F, .name = "Channels", },
    IdInfo { .id = 0x7D7B, .name = "ChannelPositions", },
    IdInfo { .id = 0x6264, .name = "BitDepth", },
    IdInfo { .id = 0x52F1, .name = "Emphasis", },
    IdInfo { .id = 0xE2, .name = "TrackOperation", },
    IdInfo { .id = 0xE3, .name = "TrackCombinePlanes", },
    IdInfo { .id = 0xE4, .name = "TrackPlane", },
    IdInfo { .id = 0xE5, .name = "TrackPlaneUID", },
    IdInfo { .id = 0xE6, .name = "TrackPlaneType", },
    IdInfo { .id = 0xE9, .name = "TrackJoinBlocks", },
    IdInfo { .id = 0xED, .name = "TrackJoinUID", },
    IdInfo { .id = 0xC0, .name = "TrickTrackUID", },
    IdInfo { .id = 0xC1, .name = "TrickTrackSegmentUID", },
    IdInfo { .id = 0xC6, .name = "TrickTrackFlag", },
    IdInfo { .id = 0xC7, .name = "TrickMasterTrackUID", },
    IdInfo { .id = 0xC4, .name = "TrickMasterTrackSegmentUID", },
    IdInfo { .id = 0x6D80, .name = "ContentEncodings", },
    IdInfo { .id = 0x6240, .name = "ContentEncoding", },
    IdInfo { .id = 0x5031, .name = "ContentEncodingOrder", },
    IdInfo { .id = 0x5032, .name = "ContentEncodingScope", },
    IdInfo { .id = 0x5033, .name = "ContentEncodingType", },
    IdInfo { .id = 0x5034, .name = "ContentCompression", },
    IdInfo { .id = 0x4254, .name = "ContentCompAlgo", },
    IdInfo { .id = 0x4255, .name = "ContentCompSettings", },
    IdInfo { .id = 0x5035, .name = "ContentEncryption", },
    IdInfo { .id = 0x47E1, .name = "ContentEncAlgo", },
    IdInfo { .id = 0x47E2, .name = "ContentEncKeyID", },
    IdInfo { .id = 0x47E7, .name = "ContentEncAESSettings", },
    IdInfo { .id = 0x47E8, .name = "AESSettingsCipherMode", },
    IdInfo { .id = 0x47E3, .name = "ContentSignature", },
    IdInfo { .id = 0x47E4, .name = "ContentSigKeyID", },
    IdInfo { .id = 0x47E5, .name = "ContentSigAlgo", },
    IdInfo { .id = 0x47E6, .name = "ContentSigHashAlgo", },
    IdInfo { .id = 0x1C53BB6B, .name = "Cues", },
    IdInfo { .id = 0xBB, .name = "CuePoint", },
    IdInfo { .id = 0xB3, .name = "CueTime", },
    IdInfo { .id = 0xB7, .name = "CueTrackPositions", },
    IdInfo { .id = 0xF7, .name = "CueTrack", },
    IdInfo { .id = 0xF1, .name = "CueClusterPosition", },
    IdInfo { .id = 0xF0, .name = "CueRelativePosition", },
    IdInfo { .id = 0xB2, .name = "CueDuration", },
    IdInfo { .id = 0x5378, .name = "CueBlockNumber", },
    IdInfo { .id = 0xEA, .name = "CueCodecState", },
    IdInfo { .id = 0xDB, .name = "CueReference", },
    IdInfo { .id = 0x96, .name = "CueRefTime", },
    IdInfo { .id = 0x97, .name = "CueRefCluster", },
    IdInfo { .id = 0x535F, .name = "CueRefNumber", },
    IdInfo { .id = 0xEB, .name = "CueRefCodecState", },
    IdInfo { .id = 0x1941A469, .name = "Attachments", },
    IdInfo { .id = 0x61A7, .name = "AttachedFile", },
    IdInfo { .id = 0x467E, .name = "FileDescription", },
    IdInfo { .id = 0x466E, .name = "FileName", },
    IdInfo { .id = 0x4660, .name = "FileMediaType", },
    IdInfo { .id = 0x465C, .name = "FileData", },
    IdInfo { .id = 0x46AE, .name = "FileUID", },
    IdInfo { .id = 0x4675, .name = "FileReferral", },
    IdInfo { .id = 0x4661, .name = "FileUsedStartTime", },
    IdInfo { .id = 0x4662, .name = "FileUsedEndTime", },
    IdInfo { .id = 0x1043A770, .name = "Chapters", },
    IdInfo { .id = 0x45B9, .name = "EditionEntry", },
    IdInfo { .id = 0x45BC, .name = "EditionUID", },
    IdInfo { .id = 0x45BD, .name = "EditionFlagHidden", },
    IdInfo { .id = 0x45DB, .name = "EditionFlagDefault", },
    IdInfo { .id = 0x45DD, .name = "EditionFlagOrdered", },
    IdInfo { .id = 0x4520, .name = "EditionDisplay", },
    IdInfo { .id = 0x4521, .name = "EditionString", },
    IdInfo { .id = 0x45E4, .name = "EditionLanguageIETF", },
    IdInfo { .id = 0xB6, .name = "ChapterAtom", },
    IdInfo { .id = 0x73C4, .name = "ChapterUID", },
    IdInfo { .id = 0x5654, .name = "ChapterStringUID", },
    IdInfo { .id = 0x91, .name = "ChapterTimeStart", },
    IdInfo { .id = 0x92, .name = "ChapterTimeEnd", },
    IdInfo { .id = 0x98, .name = "ChapterFlagHidden", },
    IdInfo { .id = 0x4598, .name = "ChapterFlagEnabled", },
    IdInfo { .id = 0x6E67, .name = "ChapterSegmentUUID", },
    IdInfo { .id = 0x4588, .name = "ChapterSkipType", },
    IdInfo { .id = 0x6EBC, .name = "ChapterSegmentEditionUID", },
    IdInfo { .id = 0x63C3, .name = "ChapterPhysicalEquiv", },
    IdInfo { .id = 0x8F, .name = "ChapterTrack", },
    IdInfo { .id = 0x89, .name = "ChapterTrackUID", },
    IdInfo { .id = 0x80, .name = "ChapterDisplay", },
    IdInfo { .id = 0x85, .name = "ChapString", },
    IdInfo { .id = 0x437C, .name = "ChapLanguage", },
    IdInfo { .id = 0x437D, .name = "ChapLanguageBCP47", },
    IdInfo { .id = 0x437E, .name = "ChapCountry", },
    IdInfo { .id = 0x6944, .name = "ChapProcess", },
    IdInfo { .id = 0x6955, .name = "ChapProcessCodecID", },
    IdInfo { .id = 0x450D, .name = "ChapProcessPrivate", },
    IdInfo { .id = 0x6911, .name = "ChapProcessCommand", },
    IdInfo { .id = 0x6922, .name = "ChapProcessTime", },
    IdInfo { .id = 0x6933, .name = "ChapProcessData", },
    IdInfo { .id = 0x1254C367, .name = "Tags", },
    IdInfo { .id = 0x7373, .name = "Tag", },
    IdInfo { .id = 0x63C0, .name = "Targets", },
    IdInfo { .id = 0x68CA, .name = "TargetTypeValue", },
    IdInfo { .id = 0x63CA, .name = "TargetType", },
    IdInfo { .id = 0x63C5, .name = "TagTrackUID", },
    IdInfo { .id = 0x63C9, .name = "TagEditionUID", },
    IdInfo { .id = 0x63C4, .name = "TagChapterUID", },
    IdInfo { .id = 0x63C6, .name = "TagAttachmentUID", },
    IdInfo { .id = 0x67C8, .name = "SimpleTag", },
    IdInfo { .id = 0x45A3, .name = "TagName", },
    IdInfo { .id = 0x447A, .name = "TagLanguage", },
    IdInfo { .id = 0x447B, .name = "TagLanguageBCP47", },
    IdInfo { .id = 0x4484, .name = "TagDefault", },
    IdInfo { .id = 0x44B4, .name = "TagDefaultBogus", },
    IdInfo { .id = 0x4487, .name = "TagString", },
    IdInfo { .id = 0x4485, .name = "TagBinary", },
};

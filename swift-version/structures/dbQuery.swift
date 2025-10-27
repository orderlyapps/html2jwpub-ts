//
//  query.swift
//  html2jwpub
//
//  Created by Dario Ragusa on 11/05/25.
//

struct dbQuery {
    let InitStructure: String = """
BEGIN TRANSACTION;
DROP TABLE IF EXISTS "Publication";
CREATE TABLE IF NOT EXISTS "Publication" (
    "PublicationId"    INTEGER,
    "VersionNumber"    INTEGER,
    "Type"    INTEGER,
    "Title"    TEXT,
    "TitleRich"    TEXT,
    "RootSymbol"    TEXT,
    "RootYear"    INTEGER,
    "RootMepsLanguageIndex"    INTEGER,
    "ShortTitle"    TEXT,
    "ShortTitleRich"    TEXT,
    "DisplayTitle"    TEXT,
    "DisplayTitleRich"    TEXT,
    "ReferenceTitle"    TEXT,
    "ReferenceTitleRich"    TEXT,
    "UndatedReferenceTitle"    TEXT,
    "UndatedReferenceTitleRich"    TEXT,
    "Symbol"    TEXT NOT NULL,
    "UndatedSymbol"    TEXT,
    "UniqueSymbol"    TEXT,
    "EnglishSymbol"    TEXT,
    "UniqueEnglishSymbol"    TEXT NOT NULL,
    "IssueTagNumber"    TEXT,
    "IssueNumber"    INTEGER,
    "Variation"    TEXT,
    "Year"    INTEGER NOT NULL,
    "VolumeNumber"    INTEGER,
    "MepsLanguageIndex"    INTEGER NOT NULL,
    "PublicationType"    TEXT,
    "PublicationCategorySymbol"    TEXT,
    "BibleVersionForCitations"    TEXT,
    "HasPublicationChapterNumbers"    BOOLEAN,
    "HasPublicationSectionNumbers"    BOOLEAN,
    "FirstDatedTextDateOffset"    DATE,
    "LastDatedTextDateOffset"    DATE,
    "MepsBuildNumber"    INTEGER,
    PRIMARY KEY("PublicationId")
);
DROP TABLE IF EXISTS "PublicationCategory";
CREATE TABLE IF NOT EXISTS "PublicationCategory" (
    "PublicationCategoryId"    INTEGER,
    "PublicationId"    ,
    "Category"    TEXT,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("PublicationCategoryId")
);
DROP TABLE IF EXISTS "PublicationYear";
CREATE TABLE IF NOT EXISTS "PublicationYear" (
    "PublicationYearId"    INTEGER,
    "PublicationId"    ,
    "Year"    INTEGER,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("PublicationYearId")
);
DROP TABLE IF EXISTS "PublicationIssueProperty";
CREATE TABLE IF NOT EXISTS "PublicationIssueProperty" (
    "PublicationIssuePropertyId"    INTEGER,
    "PublicationId"    INTEGER,
    "Title"    TEXT,
    "TitleRich"    TEXT,
    "UndatedTitle"    TEXT,
    "UndatedTitleRich"    TEXT,
    "CoverTitle"    TEXT,
    "CoverTitleRich"    TEXT,
    "Symbol"    TEXT,
    "UndatedSymbol"    TEXT,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("PublicationIssuePropertyId")
);
DROP TABLE IF EXISTS "PublicationIssueAttribute";
CREATE TABLE IF NOT EXISTS "PublicationIssueAttribute" (
    "PublicationIssueAttributeId"    INTEGER,
    "PublicationId"    INTEGER,
    "Attribute"    TEXT,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("PublicationIssueAttributeId")
);
DROP TABLE IF EXISTS "PublicationAttribute";
CREATE TABLE IF NOT EXISTS "PublicationAttribute" (
    "PublicationAttributeId"    INTEGER,
    "PublicationId"    INTEGER,
    "Attribute"    TEXT,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("PublicationAttributeId")
);
DROP TABLE IF EXISTS "RefPublication";
CREATE TABLE IF NOT EXISTS "RefPublication" (
    "RefPublicationId"    INTEGER,
    "VersionNumber"    INTEGER,
    "Type"    INTEGER,
    "Title"    TEXT,
    "TitleRich"    TEXT,
    "RootSymbol"    TEXT,
    "RootYear"    INTEGER,
    "RootMepsLanguageIndex"    INTEGER,
    "ShortTitle"    TEXT,
    "ShortTitleRich"    TEXT,
    "DisplayTitle"    TEXT,
    "DisplayTitleRich"    TEXT,
    "ReferenceTitle"    TEXT,
    "ReferenceTitleRich"    TEXT,
    "UndatedReferenceTitle"    TEXT,
    "UndatedReferenceTitleRich"    TEXT,
    "Symbol"    TEXT NOT NULL,
    "UndatedSymbol"    TEXT,
    "UniqueSymbol"    TEXT,
    "EnglishSymbol"    TEXT,
    "UniqueEnglishSymbol"    TEXT NOT NULL,
    "IssueTagNumber"    TEXT,
    "IssueNumber"    INTEGER,
    "Variation"    TEXT,
    "Year"    INTEGER NOT NULL,
    "VolumeNumber"    INTEGER,
    "MepsLanguageIndex"    INTEGER NOT NULL,
    "PublicationType"    TEXT,
    "PublicationCategorySymbol"    TEXT,
    "BibleVersionForCitations"    TEXT,
    "HasPublicationChapterNumbers"    BOOLEAN,
    "HasPublicationSectionNumbers"    BOOLEAN,
    "FirstDatedTextDateOffset"    DATE,
    "LastDatedTextDateOffset"    DATE,
    "MepsBuildNumber"    INTEGER,
    PRIMARY KEY("RefPublicationId")
);
DROP TABLE IF EXISTS "Document";
CREATE TABLE IF NOT EXISTS "Document" (
    "DocumentId"    INTEGER,
    "PublicationId"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "MepsLanguageIndex"    INTEGER,
    "Class"    TEXT,
    "Type"    INTEGER,
    "SectionNumber"    INTEGER,
    "ChapterNumber"    INTEGER,
    "Title"    TEXT,
    "TitleRich"    TEXT,
    "TocTitle"    TEXT,
    "TocTitleRich"    TEXT,
    "ContextTitle"    TEXT,
    "ContextTitleRich"    TEXT,
    "FeatureTitle"    TEXT,
    "FeatureTitleRich"    TEXT,
    "Subtitle"    TEXT,
    "SubtitleRich"    TEXT,
    "FeatureSubtitle"    TEXT,
    "FeatureSubtitleRich"    TEXT,
    "Content"    BLOB,
    "FirstFootnoteId"    INTEGER,
    "LastFootnoteId"    INTEGER,
    "FirstBibleCitationId"    INTEGER,
    "LastBibleCitationId"    INTEGER,
    "ParagraphCount"    INTEGER,
    "HasMediaLinks"    BOOLEAN,
    "HasLinks"    BOOLEAN,
    "FirstPageNumber"    INTEGER,
    "LastPageNumber"    INTEGER,
    "ContentLength"    INTEGER,
    "PreferredPresentation"    TEXT,
    "ContentReworkedDate"    TEXT,
    "HasPronunciationGuide"    BOOLEAN,
    FOREIGN KEY("PublicationId") REFERENCES "Publication"("PublicationId"),
    PRIMARY KEY("DocumentId")
);
DROP TABLE IF EXISTS "RelatedDocument";
CREATE TABLE IF NOT EXISTS "RelatedDocument" (
    "RelatedDocumentId"    INTEGER,
    "DocumentId"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "RelationshipType"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    PRIMARY KEY("RelatedDocumentId")
);
DROP TABLE IF EXISTS "Footnote";
CREATE TABLE IF NOT EXISTS "Footnote" (
    "FootnoteId"    INTEGER,
    "DocumentId"    INTEGER,
    "FootnoteIndex"    INTEGER,
    "Type"    INTEGER,
    "Content"    BLOB,
    "BibleVerseId"    INTEGER,
    "ParagraphOrdinal"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("BibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    PRIMARY KEY("FootnoteId")
);
DROP TABLE IF EXISTS "Endnote";
CREATE TABLE IF NOT EXISTS "Endnote" (
    "EndnoteId"    INTEGER,
    "DocumentId"    INTEGER,
    "TextId"    INTEGER,
    "Label"    TEXT,
    "LabelRich"    TEXT,
    "Content"    BLOB,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    PRIMARY KEY("EndnoteId")
);
DROP TABLE IF EXISTS "DocumentEndnote";
CREATE TABLE IF NOT EXISTS "DocumentEndnote" (
    "DocumentEndnoteId"    INTEGER,
    "DocumentId"    INTEGER,
    "EndnoteIndex"    INTEGER,
    "ParagraphOrdinal"    INTEGER,
    "EndnoteId"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("EndnoteId") REFERENCES "Endnote"("EndnoteId"),
    PRIMARY KEY("DocumentEndnoteId")
);
DROP TABLE IF EXISTS "Question";
CREATE TABLE IF NOT EXISTS "Question" (
    "QuestionId"    INTEGER,
    "DocumentId"    INTEGER,
    "QuestionIndex"    INTEGER,
    "Content"    BLOB,
    "ParagraphOrdinal"    INTEGER,
    "TargetParagraphOrdinal"    INTEGER,
    "TargetParagraphNumberLabel"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    PRIMARY KEY("QuestionId")
);
DROP TABLE IF EXISTS "Extract";
CREATE TABLE IF NOT EXISTS "Extract" (
    "ExtractId"    INTEGER,
    "Link"    TEXT,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "Content"    BLOB,
    "RefPublicationId"    INTEGER,
    "RefMepsDocumentId"    INTEGER,
    "RefMepsDocumentClass"    INTEGER,
    "RefBeginParagraphOrdinal"    INTEGER,
    "RefEndParagraphOrdinal"    INTEGER,
    FOREIGN KEY("RefPublicationId") REFERENCES "RefPublication"("RefPublicationId"),
    PRIMARY KEY("ExtractId")
);
DROP TABLE IF EXISTS "InternalLink";
CREATE TABLE IF NOT EXISTS "InternalLink" (
    "InternalLinkId"    INTEGER,
    "Link"    TEXT,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "MepsDocumentId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    PRIMARY KEY("InternalLinkId")
);
DROP TABLE IF EXISTS "Hyperlink";
CREATE TABLE IF NOT EXISTS "Hyperlink" (
    "HyperlinkId"    INTEGER,
    "Link"    TEXT,
    "MajorType"    INTEGER,
    "KeySymbol"    STRING,
    "Track"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "MepsLanguageIndex"    INTEGER,
    "IssueTagNumber"    INTEGER,
    PRIMARY KEY("HyperlinkId")
);
DROP TABLE IF EXISTS "DocumentHyperlink";
CREATE TABLE IF NOT EXISTS "DocumentHyperlink" (
    "DocumentHyperlinkId"    INTEGER,
    "DocumentId"    INTEGER,
    "HyperlinkId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    "SortPosition"    INTEGER,
    FOREIGN KEY("HyperlinkId") REFERENCES "Hyperlink"("HyperlinkId"),
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    PRIMARY KEY("DocumentHyperlinkId")
);
DROP TABLE IF EXISTS "BibleCitation";
CREATE TABLE IF NOT EXISTS "BibleCitation" (
    "BibleCitationId"    INTEGER,
    "DocumentId"    INTEGER,
    "BlockNumber"    INTEGER,
    "ElementNumber"    INTEGER,
    "FirstBibleVerseId"    INTEGER,
    "LastBibleVerseId"    INTEGER,
    "BibleVerseId"    INTEGER,
    "ParagraphOrdinal"    INTEGER,
    "MarginalClassification"    INTEGER,
    "SortPosition"    INTEGER,
    "HyperlinkId"    INTEGER,
    FOREIGN KEY("FirstBibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("LastBibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    FOREIGN KEY("BibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    FOREIGN KEY("HyperlinkId") REFERENCES "Hyperlink"("HyperlinkId"),
    PRIMARY KEY("BibleCitationId")
);
DROP TABLE IF EXISTS "TextUnit";
CREATE TABLE IF NOT EXISTS "TextUnit" (
    "TextUnitId"    INTEGER,
    "Type"    TEXT,
    "Id"    INTEGER,
    PRIMARY KEY("TextUnitId")
);
DROP TABLE IF EXISTS "SearchIndexBibleVerse";
CREATE TABLE IF NOT EXISTS "SearchIndexBibleVerse" (
    "SearchIndexBibleVerseId"    INTEGER,
    "WordId"    INTEGER,
    "TextUnitCount"    INTEGER,
    "WordOccurrenceCount"    INTEGER,
    "TextUnitIndices"    BLOB,
    "PositionalList"    BLOB,
    "PositionalListIndex"    BLOB,
    FOREIGN KEY("WordId") REFERENCES "Word"("WordId"),
    PRIMARY KEY("SearchIndexBibleVerseId")
);
DROP TABLE IF EXISTS "SearchIndexDocument";
CREATE TABLE IF NOT EXISTS "SearchIndexDocument" (
    "SearchIndexDocumentId"    INTEGER,
    "WordId"    INTEGER,
    "TextUnitCount"    INTEGER,
    "WordOccurrenceCount"    INTEGER,
    "TextUnitIndices"    BLOB,
    "PositionalList"    BLOB,
    "PositionalListIndex"    BLOB,
    FOREIGN KEY("WordId") REFERENCES "word"("WordId"),
    PRIMARY KEY("SearchIndexDocumentId")
);
DROP TABLE IF EXISTS "SearchTextRangeBibleVerse";
CREATE TABLE IF NOT EXISTS "SearchTextRangeBibleVerse" (
    "TextUnitId"    INTEGER,
    "TextPositions"    BLOB,
    "TextLengths"    BLOB,
    PRIMARY KEY("TextUnitId")
);
DROP TABLE IF EXISTS "SearchTextRangeDocument";
CREATE TABLE IF NOT EXISTS "SearchTextRangeDocument" (
    "TextUnitId"    INTEGER,
    "TextPositions"    BLOB,
    "TextLengths"    BLOB,
    "ScopeParagraphData"    BLOB,
    PRIMARY KEY("TextUnitId")
);
DROP TABLE IF EXISTS "Asset";
CREATE TABLE IF NOT EXISTS "Asset" (
    "AssetId"    INTEGER,
    "FilePath"    TEXT,
    "Type"    TEXT,
    "VersionNumber"    INTEGER,
    PRIMARY KEY("AssetId")
);
DROP TABLE IF EXISTS "Multimedia";
CREATE TABLE IF NOT EXISTS "Multimedia" (
    "MultimediaId"    INTEGER,
    "LinkMultimediaId"    INTEGER,
    "DataType"    INTEGER,
    "MajorType"    INTEGER,
    "MinorType"    INTEGER,
    "Width"    INTEGER,
    "Height"    INTEGER,
    "MimeType"    TEXT,
    "Label"    TEXT,
    "LabelRich"    TEXT,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "CaptionContent"    BLOB,
    "CreditLine"    TEXT,
    "CreditLineRich"    TEXT,
    "CreditLineContent"    BLOB,
    "CategoryType"    INTEGER,
    "FilePath"    TEXT,
    "KeySymbol"    STRING,
    "Track"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "MepsLanguageIndex"    INTEGER,
    "IssueTagNumber"    INTEGER,
    "SuppressZoom"    BOOLEAN,
    "SizeConstraint"    TEXT,
    PRIMARY KEY("MultimediaId")
);
DROP TABLE IF EXISTS "ExtractMultimedia";
CREATE TABLE IF NOT EXISTS "ExtractMultimedia" (
    "ExtractMultimediaId"    INTEGER,
    "ExtractId"    INTEGER,
    "RefMepsDocumentId"    INTEGER NOT NULL,
    "RefMepsDocumentClass"    INTEGER NOT NULL,
    "DataType"    INTEGER,
    "MajorType"    INTEGER,
    "MinorType"    INTEGER,
    "Width"    INTEGER,
    "Height"    INTEGER,
    "MimeType"    TEXT NOT NULL,
    "Label"    TEXT NOT NULL,
    "LabelRich"    TEXT,
    "Caption"    TEXT NOT NULL,
    "CaptionRich"    TEXT,
    "CaptionContent"    BLOB,
    "CreditLine"    TEXT,
    "CreditLineRich"    TEXT,
    "CreditLineContent"    BLOB,
    "CategoryType"    INTEGER NOT NULL,
    "FilePath"    TEXT NOT NULL,
    "KeySymbol"    STRING,
    "Track"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "MepsLanguageIndex"    INTEGER,
    "IssueTagNumber"    INTEGER,
    "SuppressZoom"    BOOLEAN,
    "SizeConstraint"    TEXT,
    FOREIGN KEY("ExtractId") REFERENCES "Extract"("ExtractId"),
    PRIMARY KEY("ExtractMultimediaId")
);
DROP TABLE IF EXISTS "PublicationView";
CREATE TABLE IF NOT EXISTS "PublicationView" (
    "PublicationViewId"    INTEGER,
    "Name"    TEXT,
    "Symbol"    TEXT NOT NULL UNIQUE,
    PRIMARY KEY("PublicationViewId")
);
DROP TABLE IF EXISTS "PublicationViewItemDocument";
CREATE TABLE IF NOT EXISTS "PublicationViewItemDocument" (
    "PublicationViewItemDocumentId"    INTEGER,
    "PublicationViewItemId"    INTEGER,
    "DocumentId"    INTEGER,
    FOREIGN KEY("PublicationViewItemId") REFERENCES "PublicationViewItem"("PublicationViewItemId"),
    PRIMARY KEY("PublicationViewItemDocumentId")
);
DROP TABLE IF EXISTS "PublicationViewItem";
CREATE TABLE IF NOT EXISTS "PublicationViewItem" (
    "PublicationViewItemId"    INTEGER,
    "PublicationViewId"    INTEGER,
    "ParentPublicationViewItemId"    INTEGER,
    "Title"    TEXT,
    "TitleRich"    TEXT,
    "SchemaType"    INTEGER,
    "ChildTemplateSchemaType"    INTEGER,
    "DefaultDocumentId"    INTEGER,
    FOREIGN KEY("PublicationViewId") REFERENCES "PublicationView"("PublicationViewId"),
    PRIMARY KEY("PublicationViewItemId")
);
DROP TABLE IF EXISTS "PublicationViewItemField";
CREATE TABLE IF NOT EXISTS "PublicationViewItemField" (
    "PublicationViewItemFieldId"    INTEGER,
    "PublicationViewItemId"    INTEGER,
    "Value"    TEXT,
    "ValueRich"    TEXT,
    "Type"    TEXT,
    FOREIGN KEY("PublicationViewItemId") REFERENCES "PublicationViewItem"("PublicationViewItemId"),
    PRIMARY KEY("PublicationViewItemFieldId")
);
DROP TABLE IF EXISTS "PublicationViewSchema";
CREATE TABLE IF NOT EXISTS "PublicationViewSchema" (
    "PublicationViewSchemaId"    INTEGER,
    "SchemaType"    INTEGER,
    "DataType"    TEXT,
    PRIMARY KEY("PublicationViewSchemaId")
);
DROP TABLE IF EXISTS "Word";
CREATE TABLE IF NOT EXISTS "Word" (
    "WordId"    INTEGER,
    "Word"    TEXT,
    "Reading"    TEXT,
    PRIMARY KEY("WordId")
);
DROP TABLE IF EXISTS "Topic";
CREATE TABLE IF NOT EXISTS "Topic" (
    "TopicId"    INTEGER,
    "Topic"    TEXT,
    "DisplayTopic"    TEXT,
    "DisplayTopicRich"    TEXT,
    PRIMARY KEY("TopicId")
);
DROP TABLE IF EXISTS "TopicDocument";
CREATE TABLE IF NOT EXISTS "TopicDocument" (
    "TopicDocumentId"    INTEGER,
    "DocumentId"    INTEGER,
    "TopicId"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("TopicId") REFERENCES "Topic"("TopicId"),
    PRIMARY KEY("TopicDocumentId")
);
DROP TABLE IF EXISTS "DatedText";
CREATE TABLE IF NOT EXISTS "DatedText" (
    "DatedTextId"    INTEGER,
    "DocumentId"    INTEGER,
    "Link"    TEXT,
    "FirstDateOffset"    DATE,
    "LastDateOffset"    DATE,
    "FirstFootnoteId"    INTEGER,
    "LastFootnoteId"    INTEGER,
    "FirstBibleCitationId"    INTEGER,
    "LastBibleCitationId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "Content"    BLOB,
    PRIMARY KEY("DatedTextId")
);
DROP TABLE IF EXISTS "DocumentParagraph";
CREATE TABLE IF NOT EXISTS "DocumentParagraph" (
    "DocumentParagraphId"    INTEGER,
    "DocumentId"    INTEGER,
    "ParagraphIndex"    INTEGER,
    "ParagraphNumberLabel"    INTEGER,
    "BeginPosition"    INTEGER,
    "EndPosition"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    PRIMARY KEY("DocumentParagraphId")
);
DROP TABLE IF EXISTS "DocumentInternalLink";
CREATE TABLE IF NOT EXISTS "DocumentInternalLink" (
    "DocumentInternalLinkId"    INTEGER,
    "DocumentId"    INTEGER,
    "InternalLinkId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    "SortPosition"    INTEGER,
    "HyperlinkId"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("HyperlinkId") REFERENCES "Hyperlink"("HyperlinkId"),
    FOREIGN KEY("InternalLinkId") REFERENCES "InternalLink"("InternalLinkId"),
    PRIMARY KEY("DocumentInternalLinkId")
);
DROP TABLE IF EXISTS "DocumentExtract";
CREATE TABLE IF NOT EXISTS "DocumentExtract" (
    "DocumentExtractId"    INTEGER,
    "DocumentId"    INTEGER,
    "ExtractId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    "SortPosition"    INTEGER,
    "HyperlinkId"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("ExtractId") REFERENCES "Extract"("ExtractId"),
    FOREIGN KEY("HyperlinkId") REFERENCES "Hyperlink"("HyperlinkId"),
    PRIMARY KEY("DocumentExtractId")
);
DROP TABLE IF EXISTS "DocumentMultimedia";
CREATE TABLE IF NOT EXISTS "DocumentMultimedia" (
    "DocumentMultimediaId"    INTEGER,
    "DocumentId"    INTEGER,
    "MultimediaId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    FOREIGN KEY("DocumentId") REFERENCES "Document"("DocumentId"),
    FOREIGN KEY("MultimediaId") REFERENCES "Multimedia"("MultimediaId"),
    PRIMARY KEY("DocumentMultimediaId")
);
DROP TABLE IF EXISTS "ParagraphCommentary";
CREATE TABLE IF NOT EXISTS "ParagraphCommentary" (
    "ParagraphCommentaryId"    INTEGER,
    "CommentaryType"    INTEGER,
    "Label"    TEXT,
    "Content"    BLOB,
    PRIMARY KEY("ParagraphCommentaryId")
);
DROP TABLE IF EXISTS "ParagraphCommentaryMap";
CREATE TABLE IF NOT EXISTS "ParagraphCommentaryMap" (
    "ParagraphCommentaryMapId"    INTEGER,
    "MepsDocumentId"    INTEGER,
    "BeginParagraphOrdinal"    INTEGER,
    "EndParagraphOrdinal"    INTEGER,
    "ParagraphCommentaryId"    INTEGER,
    FOREIGN KEY("ParagraphCommentaryId") REFERENCES "ParagraphCommentary"("ParagraphCommentaryId"),
    PRIMARY KEY("ParagraphCommentaryMapId")
);
DROP TABLE IF EXISTS "VideoMarker";
CREATE TABLE IF NOT EXISTS "VideoMarker" (
    "VideoMarkerId"    INTEGER,
    "MultimediaId"    INTEGER,
    "Label"    TEXT,
    "LabelRich"    TEXT,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "Style"    TEXT,
    "SegmentFormat"    INTEGER,
    "StartTimeTicks"    INTEGER,
    "DurationTicks"    INTEGER,
    "StartFrame"    INTEGER,
    "FrameCount"    INTEGER,
    "BeginTransitionDurationTicks"    INTEGER,
    "EndTransitionDurationTicks"    INTEGER,
    "BeginTransitionFrameCount"    INTEGER,
    "EndTransitionFrameCount"    INTEGER,
    FOREIGN KEY("MultimediaId") REFERENCES "Multimedia"("MultimediaId"),
    PRIMARY KEY("VideoMarkerId")
);
DROP TABLE IF EXISTS "ExtractVideoMarker";
CREATE TABLE IF NOT EXISTS "ExtractVideoMarker" (
    "ExtractVideoMarkerId"    INTEGER,
    "ExtractMultimediaId"    INTEGER,
    "Label"    TEXT NOT NULL,
    "LabelRich"    TEXT,
    "Caption"    TEXT,
    "CaptionRich"    TEXT,
    "Style"    TEXT,
    "SegmentFormat"    INTEGER,
    "StartTimeTicks"    INTEGER NOT NULL,
    "DurationTicks"    INTEGER NOT NULL,
    "StartFrame"    INTEGER,
    "FrameCount"    INTEGER,
    "BeginTransitionDurationTicks"    INTEGER,
    "EndTransitionDurationTicks"    INTEGER NOT NULL,
    "BeginTransitionFrameCount"    INTEGER,
    "EndTransitionFrameCount"    INTEGER,
    FOREIGN KEY("ExtractMultimediaId") REFERENCES "ExtractMultimedia"("ExtractMultimediaId"),
    PRIMARY KEY("ExtractVideoMarkerId")
);
DROP TABLE IF EXISTS "ExtractVideoMarkerRange";
CREATE TABLE IF NOT EXISTS "ExtractVideoMarkerRange" (
    "ExtractVideoMarkerRangeId"    INTEGER,
    "ExtractId"    INTEGER,
    "FirstExtractVideoMarkerId"    INTEGER,
    "LastExtractVideoMarkerId"    INTEGER,
    FOREIGN KEY("FirstExtractVideoMarkerId") REFERENCES "ExtractVideoMarker"("ExtractVideoMarkerId"),
    FOREIGN KEY("ExtractId") REFERENCES "Extract"("ExtractId"),
    FOREIGN KEY("LastExtractVideoMarkerId") REFERENCES "ExtractVideoMarker"("ExtractVideoMarkerId"),
    PRIMARY KEY("ExtractVideoMarkerRangeId")
);
DROP TABLE IF EXISTS "VideoMarkerParagraphLocation";
CREATE TABLE IF NOT EXISTS "VideoMarkerParagraphLocation" (
    "VideoMarkerParagraphLocationId"    INTEGER,
    "DocumentParagraphId"    INTEGER,
    "VideoMarkerId"    INTEGER,
    FOREIGN KEY("DocumentParagraphId") REFERENCES "DocumentParagraph"("DocumentParagraphId"),
    FOREIGN KEY("VideoMarkerId") REFERENCES "VideoMarker"("VideoMarkerId"),
    PRIMARY KEY("VideoMarkerParagraphLocationId")
);
DROP TABLE IF EXISTS "VerseCommentary";
CREATE TABLE IF NOT EXISTS "VerseCommentary" (
    "VerseCommentaryId"    INTEGER,
    "CommentaryType"    INTEGER,
    "Label"    TEXT,
    "Content"    BLOB,
    PRIMARY KEY("VerseCommentaryId")
);
DROP TABLE IF EXISTS "VerseCommentaryMap";
CREATE TABLE IF NOT EXISTS "VerseCommentaryMap" (
    "VerseCommentaryMapId"    INTEGER,
    "BibleVerseId"    INTEGER,
    "VerseCommentaryId"    INTEGER,
    FOREIGN KEY("BibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    FOREIGN KEY("VerseCommentaryId") REFERENCES "VerseCommentary"("VerseCommentaryId"),
    PRIMARY KEY("VerseCommentaryMapId")
);
DROP TABLE IF EXISTS "VerseMultimediaMap";
CREATE TABLE IF NOT EXISTS "VerseMultimediaMap" (
    "VerseMultimediaMapId"    INTEGER,
    "BibleVerseId"    INTEGER,
    "MultimediaId"    INTEGER,
    FOREIGN KEY("MultimediaId") REFERENCES "Multimedia"("MultimediaId"),
    FOREIGN KEY("BibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    PRIMARY KEY("VerseMultimediaMapId")
);
DROP TABLE IF EXISTS "VideoMarkerBibleVerseLocation";
CREATE TABLE IF NOT EXISTS "VideoMarkerBibleVerseLocation" (
    "VideoMarkerBibleVerseLocationId"    INTEGER,
    "BibleVerseId"    INTEGER,
    "VideoMarkerId"    INTEGER,
    FOREIGN KEY("BibleVerseId") REFERENCES "BibleVerse"("BibleVerseId"),
    FOREIGN KEY("VideoMarkerId") REFERENCES "VideoMarker"("VideoMarkerId"),
    PRIMARY KEY("VideoMarkerBibleVerseLocationId")
);
DROP TABLE IF EXISTS "android_metadata";
CREATE TABLE IF NOT EXISTS "android_metadata" (
    "locale"    TEXT DEFAULT 'en_US'
);
DROP INDEX IF EXISTS "idx_SearchIndexBibleVerse";
CREATE INDEX IF NOT EXISTS "idx_SearchIndexBibleVerse" ON "SearchIndexBibleVerse" (
    "WordId"
);
DROP INDEX IF EXISTS "idx_SearchIndexDocument";
CREATE INDEX IF NOT EXISTS "idx_SearchIndexDocument" ON "SearchIndexDocument" (
    "WordId"
);
DROP INDEX IF EXISTS "idx_Word";
CREATE INDEX IF NOT EXISTS "idx_Word" ON "Word" (
    "Word",
    "Reading"
);
DROP INDEX IF EXISTS "idx_Topic";
CREATE INDEX IF NOT EXISTS "idx_Topic" ON "Topic" (
    "Topic"
);
DROP INDEX IF EXISTS "idx_ParagraphCommentary";
CREATE INDEX IF NOT EXISTS "idx_ParagraphCommentary" ON "ParagraphCommentary" (
    "CommentaryType"
);
DROP INDEX IF EXISTS "idx_ParagraphCommentaryMap";
CREATE INDEX IF NOT EXISTS "idx_ParagraphCommentaryMap" ON "ParagraphCommentaryMap" (
    "MEPSDocumentId",
    "ParagraphCommentaryId",
    "BeginParagraphOrdinal",
    "EndParagraphOrdinal"
);
DROP INDEX IF EXISTS "idx_VideoMarkerParagraphLocation";
CREATE INDEX IF NOT EXISTS "idx_VideoMarkerParagraphLocation" ON "VideoMarkerParagraphLocation" (
    "DocumentParagraphId",
    "VideoMarkerId"
);
DROP INDEX IF EXISTS "idx_DocumentMultimedia";
CREATE INDEX IF NOT EXISTS "idx_DocumentMultimedia" ON "DocumentMultimedia" (
    "DocumentId",
    "MultimediaId"
);
DROP INDEX IF EXISTS "idx_DocumentExtract";
CREATE INDEX IF NOT EXISTS "idx_DocumentExtract" ON "DocumentExtract" (
    "DocumentId",
    "ExtractId"
);
DROP INDEX IF EXISTS "idx_PublicationViewItem";
CREATE INDEX IF NOT EXISTS "idx_PublicationViewItem" ON "PublicationViewItem" (
    "DefaultDocumentId"
);
DROP INDEX IF EXISTS "idx_VerseCommentary";
CREATE INDEX IF NOT EXISTS "idx_VerseCommentary" ON "VerseCommentary" (
    "CommentaryType"
);
DROP INDEX IF EXISTS "idx_VerseCommentaryMap";
CREATE INDEX IF NOT EXISTS "idx_VerseCommentaryMap" ON "VerseCommentaryMap" (
    "BibleVerseId",
    "VerseCommentaryId"
);
DROP INDEX IF EXISTS "idx_Extract_Link_RefPublicationId";
CREATE INDEX IF NOT EXISTS "idx_Extract_Link_RefPublicationId" ON "Extract" (
    "Link",
    "RefPublicationId"
);
DROP INDEX IF EXISTS "idx_ExtractVideoMarker_ExtractMultimediaId";
CREATE INDEX IF NOT EXISTS "idx_ExtractVideoMarker_ExtractMultimediaId" ON "ExtractVideoMarker" (
    "ExtractMultimediaId"
);
DROP INDEX IF EXISTS "idx_ExtractMultimedia_RefMepsDocumentId";
CREATE INDEX IF NOT EXISTS "idx_ExtractMultimedia_RefMepsDocumentId" ON "ExtractMultimedia" (
    "RefMepsDocumentId"
);
DROP INDEX IF EXISTS "idx_ExtractMultimedia_ExtractMultimediaId_MajorType_MinorType";
CREATE INDEX IF NOT EXISTS "idx_ExtractMultimedia_ExtractMultimediaId_MajorType_MinorType" ON "ExtractMultimedia" (
    "RefMepsDocumentId",
    "MajorType",
    "MinorType"
);
DROP INDEX IF EXISTS "idx_ExtractVideoMarkerRange_ExtractId";
CREATE INDEX IF NOT EXISTS "idx_ExtractVideoMarkerRange_ExtractId" ON "ExtractVideoMarkerRange" (
    "ExtractId"
);
DROP INDEX IF EXISTS "idx_ExtractVideoMarkerRange_FirstExtractVideoMarkerId";
CREATE INDEX IF NOT EXISTS "idx_ExtractVideoMarkerRange_FirstExtractVideoMarkerId" ON "ExtractVideoMarkerRange" (
    "FirstExtractVideoMarkerId"
);
DROP INDEX IF EXISTS "idx_ExtractVideoMarkerRange_LastExtractVideoMarkerId";
CREATE INDEX IF NOT EXISTS "idx_ExtractVideoMarkerRange_LastExtractVideoMarkerId" ON "ExtractVideoMarkerRange" (
    "LastExtractVideoMarkerId"
);
COMMIT;
"""
    let AndroidMetadata = "INSERT INTO android_metadata VALUES ('en_US');"
    let Publication = "INSERT INTO Publication (PublicationId, VersionNumber, Type, Title, TitleRich, RootSymbol, RootYear, RootMepsLanguageIndex, ShortTitle, ShortTitleRich, DisplayTitle, DisplayTitleRich, ReferenceTitle, ReferenceTitleRich, UndatedReferenceTitle, UndatedReferenceTitleRich, Symbol, UndatedSymbol, UniqueSymbol, EnglishSymbol, UniqueEnglishSymbol, IssueTagNumber, IssueNumber, Variation, Year, VolumeNumber, MepsLanguageIndex, PublicationType, PublicationCategorySymbol, BibleVersionForCitations, HasPublicationChapterNumbers, HasPublicationSectionNumbers, FirstDatedTextDateOffset, LastDatedTextDateOffset, MepsBuildNumber) VALUES (1,8,1,?,NULL,?,?,0,?,NULL,?,NULL,?,NULL,?,NULL,?,?,?,?,?,'0',0,'',?,0,?,'Manual/Guidelines','manual','NWTR',1,1,19691231,19691231,?);"
    let RefPublication = "INSERT INTO RefPublication (RefPublicationId, VersionNumber, Type, Title, TitleRich, RootSymbol, RootYear, RootMepsLanguageIndex, ShortTitle, ShortTitleRich, DisplayTitle, DisplayTitleRich, ReferenceTitle, ReferenceTitleRich, UndatedReferenceTitle, UndatedReferenceTitleRich, Symbol, UndatedSymbol, UniqueSymbol, EnglishSymbol, UniqueEnglishSymbol, IssueTagNumber, IssueNumber, Variation, Year, VolumeNumber, MepsLanguageIndex, PublicationType, PublicationCategorySymbol, BibleVersionForCitations, HasPublicationChapterNumbers, HasPublicationSectionNumbers, FirstDatedTextDateOffset, LastDatedTextDateOffset, MepsBuildNumber) VALUES (1,8,1,?,NULL,?,?,0,?,NULL,?,NULL,?,NULL,?,NULL,?,?,?,?,?,'0',0,'',?,0,?,'Manual/Guidelines','manual','NWTR',1,1,19691231,19691231,?);"
    let PublicationAttribute = "INSERT INTO PublicationAttribute (PublicationAttributeId, PublicationId, Attribute) VALUES (1,1,'PERSONAL');"
    let PublicationCategory = "INSERT INTO PublicationCategory (PublicationCategoryId, PublicationId, Category) VALUES (1,1,'manual');"
    let PublicationView = "INSERT INTO PublicationView (PublicationViewId, Name, Symbol) VALUES (1,'JW App Publication','jwpub');"
    let PublicationViewSchema = "INSERT INTO PublicationViewSchema (PublicationViewSchemaId, SchemaType, DataType) VALUES (1,0,'name');"
    func PublicationYear(year: Int) -> String {
        return "INSERT INTO PublicationYear (PublicationYearId, PublicationId, Year) VALUES (1,1,\(year));"
    }
    let Document = "INSERT INTO Document (DocumentId, PublicationId, MepsDocumentId, MepsLanguageIndex, Class, Type, SectionNumber, ChapterNumber, Title, TitleRich, TocTitle, TocTitleRich, ContextTitle, ContextTitleRich, FeatureTitle, FeatureTitleRich, Subtitle, SubtitleRich, FeatureSubtitle, FeatureSubtitleRich, Content, FirstFootnoteId, LastFootnoteId, FirstBibleCitationId, LastBibleCitationId, ParagraphCount, HasMediaLinks, HasLinks, FirstPageNumber, LastPageNumber, ContentLength, PreferredPresentation, ContentReworkedDate) VALUES (?,1,?,?,'13',0,1,NULL,?,NULL,?,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,?,NULL,NULL,NULL,NULL,254,0,0,1,1,?,NULL,NULL);"
    let TextUnit = "INSERT INTO TextUnit (TextUnitId, Type, Id) VALUES (?,'Document',?);"
    let PublicationViewItem = "INSERT INTO PublicationViewItem (PublicationViewItemId, PublicationViewId, ParentPublicationViewItemId, Title, TitleRich, SchemaType, ChildTemplateSchemaType, DefaultDocumentId) VALUES (?,1,?,?,NULL,0,?,?);"
    let PublicationViewItemDocument = "INSERT INTO PublicationViewItemDocument (PublicationViewItemDocumentId, PublicationViewItemId, DocumentId) VALUES (?,?,?);"
    let PublicationViewItemField = "INSERT INTO PublicationViewItemField (PublicationViewItemFieldId, PublicationViewItemId, Value, ValueRich, Type) VALUES (?,?,?,NULL,'name');"
    let Multimedia = "INSERT INTO Multimedia(MultimediaId, DataType, MajorType, MinorType, MimeType, Caption, FilePath, CategoryType) VALUES(?,?,?,?,?,?,?,?)"
    let DocumentMultimedia = "INSERT INTO DocumentMultimedia(DocumentId, MultimediaId) VALUES(?,?)"
}

export const dbQuery = {
  InitStructure: `
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
DROP TABLE IF EXISTS "TextUnit";
CREATE TABLE IF NOT EXISTS "TextUnit" (
    "TextUnitId"    INTEGER,
    "Type"    TEXT,
    "Id"    INTEGER,
    PRIMARY KEY("TextUnitId")
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
DROP TABLE IF EXISTS "android_metadata";
CREATE TABLE IF NOT EXISTS "android_metadata" (
    "locale"    TEXT DEFAULT 'en_US'
);
COMMIT;
  `,

  AndroidMetadata: "INSERT INTO android_metadata VALUES ('en_US');",

  Publication: `INSERT INTO Publication (PublicationId, VersionNumber, Type, Title, TitleRich, RootSymbol, RootYear, RootMepsLanguageIndex, ShortTitle, ShortTitleRich, DisplayTitle, DisplayTitleRich, ReferenceTitle, ReferenceTitleRich, UndatedReferenceTitle, UndatedReferenceTitleRich, Symbol, UndatedSymbol, UniqueSymbol, EnglishSymbol, UniqueEnglishSymbol, IssueTagNumber, IssueNumber, Variation, Year, VolumeNumber, MepsLanguageIndex, PublicationType, PublicationCategorySymbol, BibleVersionForCitations, HasPublicationChapterNumbers, HasPublicationSectionNumbers, FirstDatedTextDateOffset, LastDatedTextDateOffset, MepsBuildNumber) VALUES (1,8,1,?,NULL,?,?,0,?,NULL,?,NULL,?,NULL,?,NULL,?,?,?,?,?,'0',0,'',?,0,?,'Manual/Guidelines','manual','NWTR',1,1,19691231,19691231,?);`,

  RefPublication: `INSERT INTO RefPublication (RefPublicationId, VersionNumber, Type, Title, TitleRich, RootSymbol, RootYear, RootMepsLanguageIndex, ShortTitle, ShortTitleRich, DisplayTitle, DisplayTitleRich, ReferenceTitle, ReferenceTitleRich, UndatedReferenceTitle, UndatedReferenceTitleRich, Symbol, UndatedSymbol, UniqueSymbol, EnglishSymbol, UniqueEnglishSymbol, IssueTagNumber, IssueNumber, Variation, Year, VolumeNumber, MepsLanguageIndex, PublicationType, PublicationCategorySymbol, BibleVersionForCitations, HasPublicationChapterNumbers, HasPublicationSectionNumbers, FirstDatedTextDateOffset, LastDatedTextDateOffset, MepsBuildNumber) VALUES (1,8,1,?,NULL,?,?,0,?,NULL,?,NULL,?,NULL,?,NULL,?,?,?,?,?,'0',0,'',?,0,?,'Manual/Guidelines','manual','NWTR',1,1,19691231,19691231,?);`,

  PublicationAttribute: "INSERT INTO PublicationAttribute (PublicationAttributeId, PublicationId, Attribute) VALUES (1,1,'PERSONAL');",

  PublicationCategory: "INSERT INTO PublicationCategory (PublicationCategoryId, PublicationId, Category) VALUES (1,1,'manual');",

  PublicationView: "INSERT INTO PublicationView (PublicationViewId, Name, Symbol) VALUES (1,'JW App Publication','jwpub');",

  PublicationViewSchema: "INSERT INTO PublicationViewSchema (PublicationViewSchemaId, SchemaType, DataType) VALUES (1,0,'name');",

  PublicationYear: (year: number) => `INSERT INTO PublicationYear (PublicationYearId, PublicationId, Year) VALUES (1,1,${year});`,

  Document: `INSERT INTO Document (DocumentId, PublicationId, MepsDocumentId, MepsLanguageIndex, Class, Type, SectionNumber, ChapterNumber, Title, TitleRich, TocTitle, TocTitleRich, ContextTitle, ContextTitleRich, FeatureTitle, FeatureTitleRich, Subtitle, SubtitleRich, FeatureSubtitle, FeatureSubtitleRich, Content, FirstFootnoteId, LastFootnoteId, FirstBibleCitationId, LastBibleCitationId, ParagraphCount, HasMediaLinks, HasLinks, FirstPageNumber, LastPageNumber, ContentLength, PreferredPresentation, ContentReworkedDate) VALUES (?,1,?,?,'13',0,1,NULL,?,NULL,?,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,?,NULL,NULL,NULL,NULL,254,0,0,1,1,?,NULL,NULL);`,

  TextUnit: "INSERT INTO TextUnit (TextUnitId, Type, Id) VALUES (?,'Document',?);",

  PublicationViewItem: "INSERT INTO PublicationViewItem (PublicationViewItemId, PublicationViewId, ParentPublicationViewItemId, Title, TitleRich, SchemaType, ChildTemplateSchemaType, DefaultDocumentId) VALUES (?,1,?,?,NULL,0,?,?);",

  PublicationViewItemDocument: "INSERT INTO PublicationViewItemDocument (PublicationViewItemDocumentId, PublicationViewItemId, DocumentId) VALUES (?,?,?);",

  PublicationViewItemField: "INSERT INTO PublicationViewItemField (PublicationViewItemFieldId, PublicationViewItemId, Value, ValueRich, Type) VALUES (?,?,?,NULL,'name');",

  Multimedia: "INSERT INTO Multimedia(MultimediaId, DataType, MajorType, MinorType, MimeType, Caption, FilePath, CategoryType) VALUES(?,?,?,?,?,?,?,?)",

  DocumentMultimedia: "INSERT INTO DocumentMultimedia(DocumentId, MultimediaId) VALUES(?,?)"
};

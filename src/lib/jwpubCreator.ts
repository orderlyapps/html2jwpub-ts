import type { Database, SqlJsStatic } from 'sql.js';
import JSZip from 'jszip';
import { JwpubAlgorithm } from './jwpubAlgorithm';
import { dbQuery } from '../structures/dbQuery';
import { createDefaultManifest } from '../structures/manifest';
import CryptoJS from 'crypto-js';

export interface MediaFile {
  name: string;
  mimeType: string;
  data: Uint8Array;
}

export interface HTMLFile {
  name: string;
  content: string;
  media: MediaFile[];
}

/**
 * JwpubCreator handles the creation of .jwpub files
 * Manages SQLite database creation, encryption, and packaging
 */
export class JwpubCreator {
  private db: Database | null = null;
  private dbName: string = '';
  private pubTitle: string = '';
  private documentId: number = -1;
  private multimediaId: number = -1;
  private symbol: string = '';
  private year: number = 0;
  private mepsLanguageIndex: number = 0;
  private mediaFiles: MediaFile[] = [];

  private async loadSqlJs(): Promise<any> {
    // Check if already loaded
    if ((window as any).initSqlJs) {
      return (window as any).initSqlJs;
    }

    // Load sql.js script dynamically
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = '/sql-wasm.js';
      script.async = true;
      script.onload = () => {
        if ((window as any).initSqlJs) {
          resolve((window as any).initSqlJs);
        } else {
          reject(new Error('sql.js failed to load'));
        }
      };
      script.onerror = () => reject(new Error('Failed to load sql.js script'));
      document.head.appendChild(script);
    });
  }

  async initialize(dbName: string): Promise<void> {
    // Load sql.js dynamically to avoid ESM issues
    const initSqlJs = await this.loadSqlJs();
    
    // Initialize sql.js with WASM file from public directory
    const SQL: SqlJsStatic = await initSqlJs({
      locateFile: (file: string) => `/${file}`
    });
    this.db = new SQL.Database();
    this.dbName = dbName;

    // Initialize database structure
    this.db.run(dbQuery.InitStructure);
    this.simpleInsert(dbQuery.AndroidMetadata);
  }

  private simpleInsert(query: string): void {
    if (!this.db) throw new Error('Database not initialized');
    try {
      this.db.run(query);
      console.log('Successfully inserted row.');
    } catch (error) {
      console.error('Could not insert row:', error);
    }
  }

  insertPublication(
    title: string,
    symbol: string,
    year: number,
    mepsLanguageIndex: number
  ): void {
    if (!this.db) throw new Error('Database not initialized');

    this.pubTitle = title;
    this.symbol = symbol;
    this.year = year;
    this.mepsLanguageIndex = mepsLanguageIndex;

    // Insert into Publication and RefPublication
    for (const query of [dbQuery.Publication, dbQuery.RefPublication]) {
      try {
        this.db.run(query, [
          title,        // 1
          symbol,       // 2
          year,         // 3
          title,        // 4
          title,        // 5
          title,        // 6
          title,        // 7
          symbol,       // 8
          symbol,       // 9
          symbol,       // 10
          symbol,       // 11
          symbol,       // 12
          year,         // 13
          mepsLanguageIndex, // 14
          12345         // 15 (MepsBuildNumber)
        ]);
        console.log('Successfully inserted publication row.');
      } catch (error) {
        console.error('Could not insert publication:', error);
      }
    }

    // Insert related publication data
    this.simpleInsert(dbQuery.PublicationAttribute);
    this.simpleInsert(dbQuery.PublicationCategory);
    this.simpleInsert(dbQuery.PublicationView);
    this.simpleInsert(dbQuery.PublicationViewSchema);
    this.simpleInsert(dbQuery.PublicationYear(year));

    // Insert PublicationViewItem
    try {
      this.db.run(dbQuery.PublicationViewItem, [
        1,     // PublicationViewItemId
        -1,    // ParentPublicationViewItemId
        title, // Title
        0,     // ChildTemplateSchemaType
        -1     // DefaultDocumentId
      ]);
      console.log('Successfully inserted PublicationViewItem.');
    } catch (error) {
      console.error('Could not insert PublicationViewItem:', error);
    }

    // Insert PublicationViewItemField
    try {
      this.db.run(dbQuery.PublicationViewItemField, [
        1,     // PublicationViewItemFieldId
        1,     // PublicationViewItemId
        title  // Value
      ]);
      console.log('Successfully inserted PublicationViewItemField.');
    } catch (error) {
      console.error('Could not insert PublicationViewItemField:', error);
    }
  }

  insertDocument(docTitle: string, content: string): void {
    if (!this.db) throw new Error('Database not initialized');

    const jwpubAlgo = new JwpubAlgorithm(
      this.mepsLanguageIndex,
      this.symbol,
      this.year
    );
    const contentData = jwpubAlgo.encrypt(content);
    this.documentId += 1;

    // Insert Document
    try {
      this.db.run(dbQuery.Document, [
        this.documentId,                     // 1: DocumentId
        12000000 + this.documentId + 1,      // 2: MepsDocumentId
        this.mepsLanguageIndex,              // 3: MepsLanguageIndex
        docTitle,                            // 4: Title
        docTitle,                            // 5: TocTitle
        contentData,                         // 6: Content (BLOB)
        content.length                       // 7: ContentLength
      ]);
      console.log(`Successfully inserted document: ${docTitle}`);
    } catch (error) {
      console.error('Could not insert document:', error);
    }

    // Insert TextUnit
    try {
      this.db.run(dbQuery.TextUnit, [
        this.documentId + 1,  // TextUnitId
        this.documentId       // Id
      ]);
      console.log('Successfully inserted TextUnit.');
    } catch (error) {
      console.error('Could not insert TextUnit:', error);
    }

    // Insert PublicationViewItem for document
    try {
      this.db.run(dbQuery.PublicationViewItem, [
        this.documentId + 2,  // PublicationViewItemId
        1,                    // ParentPublicationViewItemId
        docTitle,             // Title
        null,                 // ChildTemplateSchemaType
        this.documentId       // DefaultDocumentId
      ]);
      console.log('Successfully inserted document PublicationViewItem.');
    } catch (error) {
      console.error('Could not insert document PublicationViewItem:', error);
    }

    // Insert PublicationViewItemDocument
    try {
      this.db.run(dbQuery.PublicationViewItemDocument, [
        this.documentId + 1,  // PublicationViewItemDocumentId
        this.documentId + 2,  // PublicationViewItemId
        this.documentId       // DocumentId
      ]);
      console.log('Successfully inserted PublicationViewItemDocument.');
    } catch (error) {
      console.error('Could not insert PublicationViewItemDocument:', error);
    }

    // Insert PublicationViewItemField
    try {
      this.db.run(dbQuery.PublicationViewItemField, [
        this.documentId + 2,  // PublicationViewItemFieldId
        this.documentId + 2,  // PublicationViewItemId
        docTitle              // Value
      ]);
      console.log('Successfully inserted document PublicationViewItemField.');
    } catch (error) {
      console.error('Could not insert document PublicationViewItemField:', error);
    }
  }

  insertMedia(mediaName: string, mimeType: string, mediaData: Uint8Array): void {
    if (!this.db) throw new Error('Database not initialized');

    this.multimediaId += 1;
    this.mediaFiles.push({ name: mediaName, mimeType, data: mediaData });

    // Insert Multimedia
    try {
      this.db.run(dbQuery.Multimedia, [
        this.multimediaId,  // MultimediaId
        0,                  // DataType
        1,                  // MajorType
        1,                  // MinorType
        mimeType,           // MimeType
        mediaName,          // Caption
        mediaName,          // FilePath
        -1                  // CategoryType
      ]);
      console.log(`Successfully inserted media: ${mediaName}`);
    } catch (error) {
      console.error('Could not insert media:', error);
    }

    // Insert DocumentMultimedia
    try {
      this.db.run(dbQuery.DocumentMultimedia, [
        this.documentId,    // DocumentId
        this.multimediaId   // MultimediaId
      ]);
      console.log('Successfully inserted DocumentMultimedia.');
    } catch (error) {
      console.error('Could not insert DocumentMultimedia:', error);
    }
  }

  async finalizeJwpub(): Promise<Blob> {
    if (!this.db) throw new Error('Database not initialized');

    // Export database
    const dbData = this.db.export();
    const dbBlob = new Blob([dbData as any], { type: 'application/octet-stream' });

    // Create contents file (zip of database + media)
    const contentsZip = new JSZip();
    contentsZip.file(`${this.dbName}.db`, dbBlob);

    // Add media files to contents
    for (const media of this.mediaFiles) {
      contentsZip.file(media.name, media.data);
    }

    const contentsData = await contentsZip.generateAsync({ 
      type: 'uint8array',
      compression: 'DEFLATE'
    });

    // Calculate hashes
    const dbHash = CryptoJS.SHA1(CryptoJS.lib.WordArray.create(Array.from(dbData))).toString();
    const contentsHash = CryptoJS.SHA256(CryptoJS.lib.WordArray.create(Array.from(contentsData))).toString();

    // Create manifest
    const timestamp = new Date().toISOString();
    const manifest = createDefaultManifest();
    manifest.name = `${this.dbName}.jwpub`;
    manifest.hash = contentsHash;
    manifest.timestamp = timestamp;
    manifest.expandedSize = contentsData.length;
    manifest.publication.fileName = `${this.dbName}.db`;
    manifest.publication.title = this.pubTitle;
    manifest.publication.shortTitle = this.pubTitle;
    manifest.publication.displayTitle = this.pubTitle;
    manifest.publication.symbol = this.symbol;
    manifest.publication.language = this.mepsLanguageIndex;
    manifest.publication.hash = dbHash;
    manifest.publication.timestamp = timestamp;
    manifest.publication.year = this.year;
    manifest.publication.rootSymbol = this.symbol;
    manifest.publication.rootYear = this.year;

    console.log(JSON.stringify(manifest, null, 2));

    // Create final jwpub file
    const jwpubZip = new JSZip();
    jwpubZip.file('contents', contentsData);
    jwpubZip.file('manifest.json', JSON.stringify(manifest, null, 2));

    const jwpubData = await jwpubZip.generateAsync({ 
      type: 'blob',
      compression: 'DEFLATE'
    });

    console.log('JWPUB file created successfully!');
    return jwpubData;
  }

  close(): void {
    if (this.db) {
      this.db.close();
      this.db = null;
    }
  }
}

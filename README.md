# HTML to JWPUB Converter (TypeScript)

A modern web-based tool to convert HTML files to .jwpub publication format, built with React, TypeScript, and Vite.

## Features

- **Modern UI**: Clean, responsive interface built with React and TailwindCSS
- **Browser-based**: No server required - everything runs in your browser
- **Drag & Drop**: Easy file selection with folder support
- **Real-time Progress**: See conversion progress as it happens
- **Automatic Download**: Generated .jwpub files download automatically

## Technology Stack

- **React 18** - UI framework
- **TypeScript** - Type safety
- **Vite** - Fast build tool
- **TailwindCSS** - Styling
- **sql.js** - SQLite in the browser
- **JSZip** - ZIP file creation
- **pako** - Compression
- **crypto-js** - Encryption

## Installation

```bash
npm install
```

## Development

```bash
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) in your browser.

## Building

```bash
npm run build
```

The built files will be in the `dist` folder.

## Usage

1. Click "Select a folder" or drag and drop a folder containing HTML files
2. Media files should be in subfolders named `[filename]_files` or `[filename].html_files`
3. Fill in publication details:
   - **Title**: The publication title
   - **Symbol**: Publication symbol (e.g., "w22")
   - **Year**: Publication year
   - **MEPS Language Index**: Language identifier (default: 1)
4. Click "Create JWPUB" to generate and download your .jwpub file

## File Structure

```
html2jwpub-ts/
├── src/
│   ├── lib/
│   │   ├── jwpubAlgorithm.ts    # Encryption and compression
│   │   └── jwpubCreator.ts      # Database creation and packaging
│   ├── structures/
│   │   ├── manifest.ts          # Manifest structure
│   │   └── dbQuery.ts           # SQL queries
│   ├── App.tsx                  # Main application
│   ├── main.tsx                 # Entry point
│   └── index.css                # Styles
├── package.json
├── tsconfig.json
├── vite.config.ts
└── tailwind.config.js
```

## How It Works

1. **File Processing**: Reads HTML files and associated media from the selected folder
2. **Database Creation**: Creates an SQLite database with publication structure
3. **Content Encryption**: Encrypts HTML content using AES-128-CBC and zlib compression
4. **Packaging**: Packages database and media files into a .jwpub archive
5. **Manifest Generation**: Creates manifest with hashes and metadata
6. **Download**: Generates and downloads the final .jwpub file

## Algorithm Details

The encryption follows the JWPUB specification:
- Publication card hash: SHA-256 of `{MepsLanguageIndex}_{Symbol}_{Year}` XOR with constant key
- Content encryption: AES-128-CBC using first 16 bytes of hash as key, last 16 bytes as IV
- Compression: zlib DEFLATE

## Browser Compatibility

Works in all modern browsers that support:
- Web Workers (for sql.js)
- File API
- Blob API
- ES2020+

## License

See LICENSE file for details.

## Credits

Based on the Swift implementation by Dario Ragusa.

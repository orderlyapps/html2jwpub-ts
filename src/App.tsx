import { useState, useCallback } from 'react';
import { FileText, Upload, Download, Loader2 } from 'lucide-react';
import { JwpubCreator } from './lib/jwpubCreator';

interface ProcessedFile {
  name: string;
  content: string;
  media: Array<{ name: string; data: Uint8Array; mimeType: string }>;
}

function App() {
  const [files, setFiles] = useState<File[]>([]);
  const [mepsLanguageIndex, setMepsLanguageIndex] = useState<string>('1');
  const [symbol, setSymbol] = useState<string>('');
  const [year, setYear] = useState<string>(new Date().getFullYear().toString());
  const [title, setTitle] = useState<string>('');
  const [processing, setProcessing] = useState(false);
  const [progress, setProgress] = useState<string>('');

  const getMimeType = (filename: string): string => {
    const ext = filename.split('.').pop()?.toLowerCase();
    const mimeTypes: { [key: string]: string } = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'svg': 'image/svg+xml',
      'mp4': 'video/mp4',
      'webm': 'video/webm',
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'pdf': 'application/pdf'
    };
    return mimeTypes[ext || ''] || 'application/octet-stream';
  };

  const handleFileSelect = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      setFiles(Array.from(e.target.files));
    }
  }, []);

  const processFiles = async (): Promise<ProcessedFile[]> => {
    const htmlFiles: ProcessedFile[] = [];
    const mediaMap = new Map<string, Array<{ name: string; data: Uint8Array; mimeType: string }>>();

    // First pass: collect all files
    for (const file of files) {
      if (file.name.endsWith('.html')) {
        const content = await file.text();
        const baseName = file.name.replace('.html', '');
        htmlFiles.push({
          name: baseName,
          content,
          media: []
        });
      } else {
        // Check if this is a media file in a folder structure
        // Format: filename.html_files/image.jpg or just image.jpg
        const pathParts = file.webkitRelativePath?.split('/') || [file.name];
        const folderName = pathParts.length > 1 ? pathParts[pathParts.length - 2] : '';
        const mediaFileName = pathParts[pathParts.length - 1];
        
        // If folder name ends with _files, associate with HTML file
        if (folderName.endsWith('_files') || folderName.endsWith('.html')) {
          const baseName = folderName.replace(/_files$/, '').replace(/\.html$/, '');
          const data = new Uint8Array(await file.arrayBuffer());
          const mediaItem = {
            name: mediaFileName,
            data,
            mimeType: getMimeType(mediaFileName)
          };
          
          if (!mediaMap.has(baseName)) {
            mediaMap.set(baseName, []);
          }
          mediaMap.get(baseName)!.push(mediaItem);
        } else {
          // Standalone media file
          const data = new Uint8Array(await file.arrayBuffer());
          const mediaItem = {
            name: mediaFileName,
            data,
            mimeType: getMimeType(mediaFileName)
          };
          
          if (!mediaMap.has('')) {
            mediaMap.set('', []);
          }
          mediaMap.get('')!.push(mediaItem);
        }
      }
    }

    // Second pass: associate media with HTML files
    for (const htmlFile of htmlFiles) {
      const media = mediaMap.get(htmlFile.name) || [];
      htmlFile.media = media;
    }

    return htmlFiles;
  };

  const handleCreate = async () => {
    if (!symbol || !title || files.length === 0) {
      alert('Please fill in all fields and select files');
      return;
    }

    setProcessing(true);
    setProgress('Initializing...');

    try {
      const creator = new JwpubCreator();
      await creator.initialize(symbol);
      
      setProgress('Creating publication...');
      creator.insertPublication(
        title,
        symbol,
        parseInt(year),
        parseInt(mepsLanguageIndex)
      );

      setProgress('Processing files...');
      const processedFiles = await processFiles();

      for (let i = 0; i < processedFiles.length; i++) {
        const file = processedFiles[i];
        setProgress(`Processing document ${i + 1}/${processedFiles.length}: ${file.name}`);
        
        // Insert media BEFORE document (matches Swift implementation)
        for (const media of file.media) {
          setProgress(`Processing media: ${media.name}`);
          creator.insertMedia(media.name, media.mimeType, media.data);
        }

        creator.insertDocument(file.name, file.content);
      }

      setProgress('Finalizing JWPUB file...');
      const jwpubBlob = await creator.finalizeJwpub();
      
      // Download the file
      const url = URL.createObjectURL(jwpubBlob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${symbol}.jwpub`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      creator.close();
      setProgress('Done! Your .jwpub file has been downloaded.');
      
      setTimeout(() => {
        setProcessing(false);
        setProgress('');
      }, 2000);
    } catch (error) {
      console.error('Error creating JWPUB:', error);
      alert(`Error creating JWPUB: ${error}`);
      setProcessing(false);
      setProgress('');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12 px-4">
      <div className="max-w-3xl mx-auto">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          <div className="flex items-center gap-3 mb-8">
            <FileText className="w-10 h-10 text-indigo-600" />
            <h1 className="text-3xl font-bold text-gray-800">HTML to JWPUB Converter</h1>
          </div>

          <p className="text-gray-600 mb-8">
            Convert HTML files to .jwpub publication format. Select a folder containing HTML files
            and their associated media resources.
          </p>

          <div className="space-y-6">
            {/* File Upload */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                HTML Files and Resources
              </label>
              <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center hover:border-indigo-400 transition-colors">
                <input
                  type="file"
                  multiple
                  // webkitdirectory=""
                  // directory=""
                  onChange={handleFileSelect}
                  className="hidden"
                  id="file-upload"

                />
                <label
                  htmlFor="file-upload"
                  className="cursor-pointer flex flex-col items-center"
                >
                  <Upload className="w-12 h-12 text-gray-400 mb-4" />
                  <span className="text-sm text-gray-600">
                    Click to select a folder or drag and drop
                  </span>
                  <span className="text-xs text-gray-500 mt-2">
                    {files.length > 0 ? `${files.length} files selected` : 'No files selected'}
                  </span>
                </label>
              </div>
            </div>

            {/* Publication Details */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Title
                </label>
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent text-gray-900"
                  placeholder="Publication Title"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Symbol
                </label>
                <input
                  type="text"
                  value={symbol}
                  onChange={(e) => setSymbol(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent text-gray-900"
                  placeholder="e.g., w22"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Year
                </label>
                <input
                  type="number"
                  value={year}
                  onChange={(e) => setYear(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent text-gray-900"
                  placeholder="2024"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  MEPS Language Index
                </label>
                <input
                  type="number"
                  value={mepsLanguageIndex}
                  onChange={(e) => setMepsLanguageIndex(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent text-gray-900"
                  placeholder="1"
                />
              </div>
            </div>

            {/* Progress */}
            {processing && (
              <div className="bg-indigo-50 border border-indigo-200 rounded-lg p-4">
                <div className="flex items-center gap-3">
                  <Loader2 className="w-5 h-5 text-indigo-600 animate-spin" />
                  <span className="text-sm text-indigo-800">{progress}</span>
                </div>
              </div>
            )}

            {/* Create Button */}
            <button
              onClick={handleCreate}
              disabled={processing || !symbol || !title || files.length === 0}
              className="w-full bg-indigo-600 text-white py-3 px-6 rounded-lg font-medium hover:bg-indigo-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
            >
              {processing ? (
                <>
                  <Loader2 className="w-5 h-5 animate-spin" />
                  Processing...
                </>
              ) : (
                <>
                  <Download className="w-5 h-5" />
                  Create JWPUB
                </>
              )}
            </button>
          </div>

          <div className="mt-8 pt-6 border-t border-gray-200">
            <h2 className="text-sm font-semibold text-gray-700 mb-2">Usage Instructions</h2>
            <ul className="text-sm text-gray-600 space-y-1 list-disc list-inside">
              <li>Select a folder containing your HTML files</li>
              <li>Media files should be in subfolders named: <code className="bg-gray-100 px-1 rounded">[filename]_files</code></li>
              <li>Fill in the publication details (Title, Symbol, Year, Language Index)</li>
              <li>Click "Create JWPUB" to generate and download your publication</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;

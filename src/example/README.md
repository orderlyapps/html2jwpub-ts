# Example HTML Files for JWPUB Converter

This directory contains example HTML files that demonstrate various features of the HTML to JWPUB converter.

## Examples Overview

### 1. `simple-article.html`
A basic HTML article with minimal formatting. Perfect for:
- Understanding the basic conversion process
- Testing simple text content
- Learning the fundamental structure

**Features demonstrated:**
- Headings (h1, h2)
- Paragraphs
- Basic text formatting (bold, italic)

---

### 2. `rich-formatting.html`
A comprehensive example showing advanced HTML formatting. Ideal for:
- Publications with complex content structure
- Documents requiring various formatting styles
- Testing the converter's HTML element support

**Features demonstrated:**
- Multiple heading levels
- Ordered and unordered lists (including nested)
- Tables with headers
- Blockquotes
- Text formatting (bold, italic, underline, code, strikethrough)
- Horizontal rules
- Preformatted text
- Links

---

### 3. `article-with-images.html`
Demonstrates how to include images and media files. Use this for:
- Publications with illustrations
- Understanding media file organization
- Learning the `_files` folder convention

**Features demonstrated:**
- Image references
- Figure and figcaption elements
- Media file organization

**Important:** When using this example, create a folder named `article-with-images_files` in the same directory and place your image files there. The converter will automatically detect and include these media files.

---

### 4. `multi-section-article.html`
A complete, production-ready example with multiple sections and navigation. Best for:
- Large publications or documentation
- Articles with table of contents
- Understanding complex document structure

**Features demonstrated:**
- Navigation menu
- Multiple sections with IDs
- Internal links
- Tables
- Styled notes and highlights
- Comprehensive content organization
- Header and footer elements

---

## How to Use These Examples

### For Testing
1. Copy one of the example files (or all of them) to a test folder
2. If using `article-with-images.html`, create the corresponding `_files` folder with sample images
3. Use the converter's folder selection to choose your test folder
4. Fill in the publication metadata (Title, Symbol, Year, Language Index)
5. Click "Create JWPUB" to generate the publication

### For Your Own Content
1. Choose the example that best matches your content type
2. Copy the HTML structure as a template
3. Replace the content with your own
4. Add any media files to an appropriately named `_files` folder
5. Convert using the app

---

## Media File Organization

When including images or other media files in your HTML:

### Folder Naming Convention
Create a folder with one of these names:
- `[filename]_files` (e.g., `article-with-images_files`)
- `[filename].html_files` (e.g., `article-with-images.html_files`)

### Folder Structure Example
```
example/
├── article-with-images.html
├── article-with-images_files/
│   ├── sample-image-1.jpg
│   ├── sample-image-2.png
│   └── diagram.svg
├── simple-article.html
└── README.md
```

### Supported Media Formats
- Images: JPEG, PNG, GIF, SVG
- The converter will detect all files referenced in your HTML

---

## Tips for Best Results

1. **Validate Your HTML**: Ensure your HTML is well-formed before conversion
2. **Use Semantic Elements**: Use appropriate HTML5 elements (header, nav, section, article, etc.)
3. **Optimize Images**: Compress images before adding them to reduce file size
4. **Test Incrementally**: Start with simple content and add complexity gradually
5. **Check References**: Ensure all image paths match actual file locations
6. **Include Alt Text**: Always add alt attributes to images for accessibility

---

## Publication Metadata Examples

When converting, you'll need to provide metadata. Here are some examples:

### Example 1: Magazine
- **Title**: The Watchtower, January 2022
- **Symbol**: w22
- **Year**: 2022
- **Language Index**: 1 (English)

### Example 2: Book
- **Title**: My Bible Lessons
- **Symbol**: blt
- **Year**: 2022
- **Language Index**: 1 (English)

### Example 3: Generic Publication
- **Title**: Test Publication
- **Symbol**: tp
- **Year**: 2024
- **Language Index**: 1

---

## Troubleshooting

**Problem**: Images don't appear in the converted publication  
**Solution**: Check that the `_files` folder name matches the HTML filename and that image paths in the HTML are correct

**Problem**: Conversion fails  
**Solution**: Validate your HTML syntax and ensure all metadata fields are filled

**Problem**: Special characters appear incorrectly  
**Solution**: Ensure your HTML file uses UTF-8 encoding

---

## Next Steps

After successfully converting these examples, you can:
1. Create your own HTML content
2. Combine multiple HTML files in one folder for multi-document publications
3. Customize the styling using inline CSS or style tags
4. Add more complex multimedia content

For more information, see the main project README.md

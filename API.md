# API Documentation

This document describes the HTTP API endpoints available in the PDF to PPTX Converter.

## Base URL
```
http://localhost:5000
```

## Endpoints

### 1. Home Page
**GET** `/`

Returns the main web interface.

**Response**: HTML page

---

### 2. Upload and Convert PDF
**POST** `/api/upload`

Upload a PDF file and convert it to PPTX format.

**Request**:
- Method: `POST`
- Content-Type: `multipart/form-data`
- Body parameter: `file` (PDF file)

**Example using cURL**:
```bash
curl -X POST \
  -F "file=@/path/to/your/document.pdf" \
  http://localhost:5000/api/upload
```

**Example using Python**:
```python
import requests

url = "http://localhost:5000/api/upload"
files = {"file": open("document.pdf", "rb")}
response = requests.post(url, files=files)
print(response.json())
```

**Success Response**:
```json
{
  "success": true,
  "message": "Conversion successful",
  "output_file": "document.pptx"
}
```

**Error Responses**:

*No file provided*:
```json
{
  "error": "No file part"
}
```
Status: 400

*Invalid file type*:
```json
{
  "error": "Invalid file type. Only PDF files are allowed."
}
```
Status: 400

*Conversion error*:
```json
{
  "error": "Error message details"
}
```
Status: 500

---

### 3. Download Converted File
**GET** `/api/download/<filename>`

Download the converted PPTX file.

**Parameters**:
- `filename`: Name of the converted file (from upload response)

**Example**:
```bash
curl -O http://localhost:5000/api/download/document.pptx
```

**Success Response**: 
- Binary file download (application/vnd.openxmlformats-officedocument.presentationml.presentation)

**Error Response**:
```json
{
  "error": "File not found"
}
```
Status: 404

---

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 400 | Bad Request - Invalid input |
| 404 | Not Found - File doesn't exist |
| 500 | Internal Server Error - Conversion failed |

## Rate Limiting

Currently, there is no rate limiting implemented. For production use, consider implementing rate limiting using Flask extensions like `Flask-Limiter`.

## File Size Limits

- Maximum file size: 50MB
- This can be configured in `app.py`:
```python
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB
```

## Conversion Process

1. **Upload**: Client uploads PDF file via POST request
2. **Storage**: File temporarily stored in `uploads/` directory
3. **Conversion**:
   - PDF converted to images (300 DPI)
   - OCR performed on each page
   - PPTX generated with text and images
4. **Output**: PPTX saved in `outputs/` directory
5. **Cleanup**: Original PDF removed after conversion
6. **Download**: Client can download the PPTX file

## CORS

CORS is enabled for all origins. For production, restrict to specific origins:

```python
from flask_cors import CORS

CORS(app, resources={
    r"/api/*": {
        "origins": ["https://yourdomain.com"]
    }
})
```

## Example Workflow

Complete workflow example in JavaScript:

```javascript
async function convertPDF(file) {
  // 1. Upload and convert
  const formData = new FormData();
  formData.append('file', file);
  
  try {
    const uploadResponse = await fetch('/api/upload', {
      method: 'POST',
      body: formData
    });
    
    const result = await uploadResponse.json();
    
    if (result.success) {
      // 2. Download converted file
      window.location.href = `/api/download/${result.output_file}`;
      console.log('Conversion successful!');
    } else {
      console.error('Conversion failed:', result.error);
    }
  } catch (error) {
    console.error('Error:', error);
  }
}
```

## Notes

- Files in `uploads/` and `outputs/` directories should be periodically cleaned
- For production, implement authentication and authorization
- Consider adding webhook notifications for long-running conversions
- Implement proper logging for debugging and monitoring

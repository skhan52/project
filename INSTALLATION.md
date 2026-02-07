# Installation Guide

This guide will help you set up the PDF to PPTX Converter with OCR on your system.

## Prerequisites

### System Requirements
- **Operating System**: Linux, macOS, or Windows
- **Python**: Version 3.8 or higher
- **RAM**: Minimum 4GB (8GB recommended for better OCR performance)
- **Disk Space**: At least 2GB free space for dependencies

### Required System Libraries

#### For Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y poppler-utils
sudo apt-get install -y libgl1-mesa-glx libglib2.0-0  # For OpenCV
```

#### For macOS:
```bash
brew install poppler
```

#### For Windows:
1. Download Poppler from: http://blog.alivate.com.au/poppler-windows/
2. Extract to a folder (e.g., `C:\Program Files\poppler`)
3. Add the `bin` folder to your system PATH environment variable

## Step-by-Step Installation

### 1. Clone or Download the Repository
```bash
git clone https://github.com/skhan52/project.git
cd project
```

### 2. Create Virtual Environment
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On Linux/macOS:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### 3. Install Python Dependencies
```bash
# Upgrade pip
pip install --upgrade pip

# Install all required packages
pip install -r requirements.txt
```

**Note**: This may take 5-10 minutes as PaddlePaddle and PaddleOCR are large packages.

### 4. Verify Installation
```bash
python -c "from paddleocr import PaddleOCR; print('PaddleOCR installed successfully')"
```

## Running the Application

### Using the Start Script (Linux/macOS)
```bash
chmod +x start.sh
./start.sh
```

### Manual Start
```bash
# Make sure virtual environment is activated
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Run the application
python app.py
```

The application will start on `http://localhost:5000`

## Troubleshooting

### Issue: "pdf2image.exceptions.PDFInfoNotInstalledError"
**Solution**: Poppler is not installed or not in PATH. Install Poppler as described above.

### Issue: "ImportError: libGL.so.1"
**Solution** (Ubuntu/Debian):
```bash
sudo apt-get install libgl1-mesa-glx
```

### Issue: PaddleOCR installation fails
**Solution**: Try installing with specific mirror:
```bash
pip install paddlepaddle==2.6.0 -i https://mirror.baidu.com/pypi/simple
pip install paddleocr==2.7.3
```

### Issue: Out of memory errors
**Solution**: 
1. Reduce DPI in `app.py` from 300 to 150
2. Process smaller PDF files
3. Increase system RAM or swap space

### Issue: Port 5000 already in use
**Solution**: Change the port in `app.py`:
```python
app.run(debug=True, host='0.0.0.0', port=8080)  # Use different port
```

## Performance Optimization

### For Better OCR Performance:
1. Use GPU if available (requires CUDA):
```bash
pip install paddlepaddle-gpu
```

2. Modify `app.py` to enable GPU:
```python
ocr = PaddleOCR(use_angle_cls=True, lang='korean', use_gpu=True)
```

### For Faster Processing:
- Process lower-resolution PDFs (150 DPI instead of 300)
- Use multi-core processing for multiple pages
- Close unnecessary applications to free up RAM

## Security Considerations

1. The application accepts file uploads - use in trusted environments
2. Set appropriate file size limits (default: 50MB)
3. Consider adding authentication for production deployments
4. Regularly update dependencies for security patches

## Next Steps

- Read the [README.md](README.md) for usage instructions
- Check out the API documentation (if available)
- Report issues on GitHub

import os
import json
from flask import Flask, request, jsonify, send_file, render_template
from flask_cors import CORS
from werkzeug.utils import secure_filename
from pdf2image import convert_from_path
from paddleocr import PaddleOCR
from pptx import Presentation
from pptx.util import Inches, Pt
from PIL import Image
import tempfile
import shutil

app = Flask(__name__)
CORS(app)

# Configuration
UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'outputs'
ALLOWED_EXTENSIONS = {'pdf'}

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['OUTPUT_FOLDER'] = OUTPUT_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB max file size

# Initialize PaddleOCR with Korean language support
ocr = PaddleOCR(use_angle_cls=True, lang='ko', use_gpu=False)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def cleanup_old_files(directory, max_age_hours=1):
    """
    Remove files older than max_age_hours from the specified directory
    """
    import time
    current_time = time.time()
    max_age_seconds = max_age_hours * 3600
    
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path):
            file_age = current_time - os.path.getmtime(file_path)
            if file_age > max_age_seconds:
                try:
                    os.remove(file_path)
                    print(f"Cleaned up old file: {filename}")
                except Exception as e:
                    print(f"Failed to remove {filename}: {e}")

def pdf_to_pptx(pdf_path, output_path):
    """
    Convert PDF to PPTX using OCR to extract text and maintain layout
    """
    # Create temporary directory for images
    temp_dir = tempfile.mkdtemp()
    
    try:
        # Convert PDF to images
        images = convert_from_path(pdf_path, dpi=300)
        
        # Create new presentation
        prs = Presentation()
        
        # Standard slide dimensions (16:9)
        prs.slide_width = Inches(10)
        prs.slide_height = Inches(7.5)
        
        for idx, image in enumerate(images):
            # Save image temporarily
            img_path = os.path.join(temp_dir, f'page_{idx}.png')
            image.save(img_path, 'PNG')
            
            # Add blank slide
            blank_slide_layout = prs.slide_layouts[6]  # Blank layout
            slide = prs.slides.add_slide(blank_slide_layout)
            
            # Get image dimensions
            img_width, img_height = image.size
            
            # Add background image to slide
            left = Inches(0)
            top = Inches(0)
            height = prs.slide_height
            width = prs.slide_width
            
            # Add the image as background
            pic = slide.shapes.add_picture(img_path, left, top, width=width, height=height)
            
            # Move picture to back
            slide.shapes._spTree.remove(pic._element)
            slide.shapes._spTree.insert(2, pic._element)
            
            # Perform OCR on the image
            result = ocr.ocr(img_path, cls=True)
            
            if result and result[0]:
                for line in result[0]:
                    # Extract text and bounding box
                    bbox = line[0]
                    text = line[1][0]
                    confidence = line[1][1]
                    
                    # Skip low confidence results
                    if confidence < 0.5:
                        continue
                    
                    # Calculate position and size
                    # bbox format: [[x1, y1], [x2, y2], [x3, y3], [x4, y4]]
                    x1, y1 = bbox[0]
                    x2, y2 = bbox[2]
                    
                    # Convert pixel coordinates to inches
                    # Scale from image size to slide size
                    scale_x = float(prs.slide_width) / img_width
                    scale_y = float(prs.slide_height) / img_height
                    
                    left = Inches(x1 * scale_x / 914400)  # Convert to inches
                    top = Inches(y1 * scale_y / 914400)
                    width = Inches((x2 - x1) * scale_x / 914400)
                    height = Inches((y2 - y1) * scale_y / 914400)
                    
                    # Calculate font size based on height
                    font_size = max(8, int((y2 - y1) * 0.7))  # Approximate font size
                    
                    # Add text box
                    try:
                        textbox = slide.shapes.add_textbox(left, top, width, height)
                        text_frame = textbox.text_frame
                        text_frame.word_wrap = False
                        text_frame.clear()
                        
                        p = text_frame.paragraphs[0]
                        p.text = text
                        p.font.size = Pt(font_size)
                        
                        # Make background transparent
                        textbox.fill.background()
                        textbox.line.fill.background()
                    except Exception as e:
                        print(f"Error adding text box: {e}")
                        continue
        
        # Save presentation
        prs.save(output_path)
        return True
        
    except Exception as e:
        print(f"Error converting PDF to PPTX: {e}")
        raise e
    finally:
        # Clean up temporary directory
        shutil.rmtree(temp_dir, ignore_errors=True)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/upload', methods=['POST'])
def upload_file():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'}), 400
        
        file = request.files['file']
        
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400
        
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            pdf_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(pdf_path)
            
            # Generate output filename
            output_filename = filename.rsplit('.', 1)[0] + '.pptx'
            output_path = os.path.join(app.config['OUTPUT_FOLDER'], output_filename)
            
            # Convert PDF to PPTX
            pdf_to_pptx(pdf_path, output_path)
            
            # Clean up uploaded PDF and old output files
            try:
                os.remove(pdf_path)
                # Clean up output files older than 1 hour
                cleanup_old_files(app.config['OUTPUT_FOLDER'], max_age_hours=1)
            except Exception as e:
                print(f"Cleanup warning: {e}")
            
            return jsonify({
                'success': True,
                'message': 'Conversion successful',
                'output_file': output_filename
            })
        else:
            return jsonify({'error': 'Invalid file type. Only PDF files are allowed.'}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/download/<filename>')
def download_file(filename):
    try:
        file_path = os.path.join(app.config['OUTPUT_FOLDER'], filename)
        if os.path.exists(file_path):
            return send_file(file_path, as_attachment=True)
        else:
            return jsonify({'error': 'File not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

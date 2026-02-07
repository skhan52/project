#!/bin/bash

# PDF to PPTX Converter - Quick Start Script

echo "========================================="
echo "PDF to PPTX Converter - Setup & Start"
echo "========================================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"
echo ""

# Check if poppler is installed
if ! command -v pdfinfo &> /dev/null; then
    echo "⚠️  Poppler not found. Installing..."
    
    # Detect OS and install poppler
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y poppler-utils
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install poppler
    else
        echo "❌ Please install Poppler manually for your OS"
        exit 1
    fi
fi

echo "✅ Poppler is installed"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

echo ""

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 Starting the application..."
echo ""
echo "The application will be available at: http://localhost:5000"
echo ""

# Start the application
python app.py

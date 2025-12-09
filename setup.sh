#!/bin/bash
# Setup script for SPCC

set -e

echo "Smart PDF Confidentiality Classifier - Setup Script"
echo "=================================================="
echo ""

# Check Python version
echo "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python version: $python_version"

# Create virtual environment
echo ""
echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Check for Tesseract
echo ""
echo "Checking for Tesseract OCR..."
if command -v tesseract &> /dev/null; then
    tesseract_version=$(tesseract --version 2>&1 | head -n 1)
    echo "✓ Tesseract found: $tesseract_version"
else
    echo "✗ Tesseract not found. Please install it:"
    echo "  Ubuntu/Debian: sudo apt-get install tesseract-ocr"
    echo "  macOS: brew install tesseract"
    echo "  Windows: Download from https://github.com/UB-Mannheim/tesseract/wiki"
fi

# Check for Poppler
echo ""
echo "Checking for Poppler utilities..."
if command -v pdftoppm &> /dev/null; then
    echo "✓ Poppler found"
else
    echo "✗ Poppler not found. Please install it:"
    echo "  Ubuntu/Debian: sudo apt-get install poppler-utils"
    echo "  macOS: brew install poppler"
    echo "  Windows: Download from https://github.com/oschwartz10612/poppler-windows/releases"
fi

# Create necessary directories
echo ""
echo "Creating necessary directories..."
mkdir -p uploads protected logs test_files

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "Creating .env file..."
    cp .env.example .env
    echo "✓ .env file created. Please edit it with your configuration."
else
    echo "✓ .env file already exists"
fi

# Generate test PDFs
echo ""
echo "Generating test PDFs..."
if python3 scripts/generate_test_pdfs.py 2>/dev/null; then
    echo "✓ Test PDFs generated"
else
    echo "⚠ Could not generate test PDFs (this is optional)"
fi

echo ""
echo "=================================================="
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Activate virtual environment: source venv/bin/activate"
echo "2. Edit .env file with your configuration"
echo "3. Start backend: python -m uvicorn backend.main:app --reload"
echo "4. In another terminal, start frontend: cd frontend && npm install && npm start"
echo ""
echo "Or use Docker: docker-compose up --build"
echo ""

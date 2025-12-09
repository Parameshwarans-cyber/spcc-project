# Smart PDF Confidentiality Classifier (SPCC)

A web application that automatically scans uploaded PDF files, detects sensitive information (Aadhaar, PAN, passwords, invoice data, signatures, phone numbers, emails, bank details), classifies document sensitivity (Normal / Moderate / High), and applies protection through watermarking and password encryption when needed.

## Features

- ✅ **Multi-format PDF Support**: Handles both native text PDFs and scanned image PDFs using OCR
- ✅ **Comprehensive Detection**: Detects Aadhaar, PAN, phone numbers, emails, IFSC codes, bank accounts, passwords, invoices, and signatures
- ✅ **Smart Classification**: Automatically classifies documents as Normal, Moderate Sensitive, or Highly Sensitive
- ✅ **PDF Protection**: Watermarking and password encryption for sensitive documents
- ✅ **Bulk Processing**: Upload and process up to 10 PDFs simultaneously
- ✅ **Modern UI**: Responsive React frontend with real-time progress indicators
- ✅ **Production Ready**: Dockerized, scalable, and secure

## Tech Stack

### Backend
- **FastAPI**: Modern, fast Python web framework
- **PyPDF2 / pikepdf**: PDF manipulation
- **Tesseract OCR**: Text extraction from scanned PDFs
- **reportlab**: PDF watermarking
- **Uvicorn**: ASGI server

### Frontend
- **React**: Modern UI framework
- **Axios**: HTTP client
- **CSS3**: Responsive design with gradients and animations

## Prerequisites

- Python 3.11+
- Node.js 18+ (for frontend development)
- Tesseract OCR installed on your system
- Poppler utilities (for PDF to image conversion)
- Docker and Docker Compose (for containerized deployment)

### Installing Tesseract and Poppler

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install tesseract-ocr tesseract-ocr-eng poppler-utils
```

**macOS:**
```bash
brew install tesseract poppler
```

**Windows:**
- Download Tesseract from: https://github.com/UB-Mannheim/tesseract/wiki
- Download Poppler from: https://github.com/oschwartz10612/poppler-windows/releases
- Add both to your system PATH

## Installation & Setup

### Option 1: Docker (Recommended)

1. **Clone the repository:**
```bash
git clone <repository-url>
cd spcc
```

2. **Start services:**
```bash
docker-compose up --build
```

3. **Access the application:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

### Option 2: Local Development

#### Backend Setup

1. **Create virtual environment:**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Create environment file:**
```bash
cp .env.example .env
# Edit .env if needed
```

4. **Run backend:**
```bash
python -m uvicorn backend.main:app --reload --port 8000
```

#### Frontend Setup

1. **Navigate to frontend directory:**
```bash
cd frontend
```

2. **Install dependencies:**
```bash
npm install
```

3. **Start development server:**
```bash
npm start
```

4. **Access frontend:** http://localhost:3000

## Environment Variables

Create a `.env` file in the root directory:

```env
# Server Configuration
PORT=8000

# PDF Protection
PDF_PASSWORD=protected123

# OCR Configuration (optional, defaults to system PATH)
TESSERACT_CMD=/usr/bin/tesseract

# Logging
LOG_LEVEL=INFO
```

## Usage

### Via Web UI

1. Open the application in your browser (http://localhost:3000)
2. Click "Select PDF files" or drag and drop PDF files (max 10 files, 50MB each)
3. Click "Scan PDFs" to start scanning
4. Review the results:
   - **Normal**: No sensitive information detected
   - **Moderate Sensitive**: 1-2 types of sensitive data found
   - **Highly Sensitive**: 3+ types or Aadhaar/PAN detected
5. For Moderate/Highly Sensitive documents, click "Protect PDF" to:
   - Add "CONFIDENTIAL" watermark
   - Encrypt with password
   - Download protected file

### Via API

#### Scan PDFs
```bash
curl -X POST "http://localhost:8000/api/scan" \
  -F "files=@document1.pdf" \
  -F "files=@document2.pdf"
```

#### Protect PDF
```bash
curl -X POST "http://localhost:8000/api/protect" \
  -F "file=@document.pdf" \
  -F "filename=document.pdf"
```

#### Get Logs
```bash
curl "http://localhost:8000/api/logs?limit=100"
```

## Detection Patterns

### Supported Detection Types

1. **Aadhaar**: `\b[0-9]{4}\s?[0-9]{4}\s?[0-9]{4}\b`
2. **PAN**: `\b[A-Z]{5}[0-9]{4}[A-Z]\b`
3. **Indian Phone**: `(\+91[\-\s]?)?[6-9]\d{9}`
4. **Email**: Standard email regex
5. **IFSC**: `[A-Z]{4}0[A-Z0-9]{6}`
6. **Bank Account**: 8-18 digits with context validation
7. **Password Keywords**: password, pwd, passcode, pin, otp
8. **Invoice Keywords**: invoice, bill, amount, tax, due
9. **Signature Keywords**: signature, signed, authorize

### Classification Rules

- **Normal**: 0 sensitive items detected
- **Moderate Sensitive**: 1-2 unique types detected
- **Highly Sensitive**: 
  - 3+ unique types detected, OR
  - Aadhaar number detected, OR
  - PAN number detected

## Testing

### Run Unit Tests

```bash
cd backend
python -m pytest tests/ -v
```

Or using unittest:
```bash
cd backend
python -m unittest discover tests -v
```

### Sample Test Files

The project includes sample test PDFs in the `test_files/` directory:

- `Aadhaar.pdf`: Contains Aadhaar number → Highly Sensitive
- `PAN.pdf`: Contains PAN number → Highly Sensitive
- `Invoice.pdf`: Contains invoice keywords → Moderate Sensitive
- `Normal.pdf`: No sensitive information → Normal

You can generate these using any PDF creation tool or use the provided scripts.

## API Documentation

Interactive API documentation is available at:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure

```
spcc/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── services/
│   │   ├── pdf_extractor.py    # Text extraction & OCR
│   │   ├── sensitive_detector.py  # Detection logic
│   │   └── pdf_protector.py    # Watermarking & encryption
│   ├── utils/
│   │   └── logger.py           # Logging configuration
│   └── tests/
│       └── test_sensitive_detector.py  # Unit tests
├── frontend/
│   ├── src/
│   │   ├── App.js              # Main React component
│   │   └── components/
│   │       ├── FileUpload.js   # Upload component
│   │       └── ResultsDisplay.js  # Results display
│   └── public/
├── uploads/                     # Temporary upload storage
├── protected/                   # Protected PDF storage
├── logs/                        # Application logs
├── Dockerfile                   # Backend Docker image
├── docker-compose.yml           # Multi-container setup
├── requirements.txt             # Python dependencies
└── README.md                    # This file
```

## Troubleshooting

### Backend won't start

1. **Check Tesseract installation:**
```bash
tesseract --version
```

2. **Check Poppler installation:**
```bash
pdftoppm -v
```

3. **Check port availability:**
```bash
# Linux/Mac
lsof -i :8000

# Windows
netstat -ano | findstr :8000
```

### OCR not working

1. Ensure Tesseract is installed and in PATH
2. Check logs in `logs/app.log`
3. For low confidence OCR results, try higher DPI in `pdf_extractor.py`

### Frontend can't connect to backend

1. Check `REACT_APP_API_URL` in frontend environment
2. Verify CORS settings in `backend/main.py`
3. Ensure backend is running on the correct port

### "Connection refused" errors

1. Verify backend is running: `curl http://localhost:8000/health`
2. Check firewall settings
3. Verify Docker networking if using containers

## Security Considerations

- **File Size Limits**: 50MB per file enforced
- **File Type Validation**: Only PDF files accepted
- **Password Protection**: Default password configurable via env var
- **No Long-term Storage**: Uploaded files are deleted after processing (except protected files)
- **CORS**: Configured for development; restrict origins in production

## Performance

- **Target**: Process 5-page document within 6 seconds
- **OCR Performance**: Depends on system resources and image quality
- **Scalability**: Stateless API design allows horizontal scaling
- **Memory**: Monitor memory usage for large batch uploads

## Deployment

### Production Checklist

- [ ] Set `PDF_PASSWORD` to a strong password
- [ ] Configure CORS with specific allowed origins
- [ ] Set up reverse proxy (Nginx/Traefik)
- [ ] Enable HTTPS/SSL
- [ ] Configure log rotation
- [ ] Set up monitoring and alerts
- [ ] Configure backup for protected files (if needed)
- [ ] Review file retention policies

### Deploy to Cloud Platforms

**Heroku:**
```bash
heroku create spcc-app
heroku config:set PDF_PASSWORD=your_secure_password
git push heroku main
```

**Render:**
- Connect GitHub repository
- Set build command: `pip install -r requirements.txt`
- Set start command: `uvicorn backend.main:app --host 0.0.0.0 --port $PORT`

**Railway:**
- Import from GitHub
- Auto-detects Python project
- Set environment variables in dashboard

## Limitations

1. **OCR Accuracy**: Depends on image quality and resolution
2. **Language Support**: Currently optimized for English text
3. **File Size**: Large files (>50MB) are rejected
4. **Concurrent Processing**: Limited by server resources
5. **Password Strength**: Default password should be changed in production

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## Acknowledgments

- Tesseract OCR for text extraction capabilities
- FastAPI for the excellent async framework
- React community for robust UI libraries

---

**Built with ❤️ for secure PDF processing**

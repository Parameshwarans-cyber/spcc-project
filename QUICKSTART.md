# Quick Start Guide

Get SPCC up and running in 5 minutes!

## Prerequisites Check

Before starting, ensure you have:
- ✅ Python 3.11+ installed
- ✅ Node.js 18+ installed (for frontend development)
- ✅ Tesseract OCR installed
- ✅ Poppler utilities installed

## Option 1: Docker (Fastest)

```bash
# 1. Clone or download the project
cd spcc

# 2. Start everything
docker-compose up --build

# 3. Open your browser
# Frontend: http://localhost:3000
# Backend API: http://localhost:8000
# API Docs: http://localhost:8000/docs
```

That's it! 🎉

## Option 2: Local Development

### Backend Setup

```bash
# 1. Create virtual environment
python -m venv venv

# 2. Activate it
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Create .env file
copy .env.example .env  # Windows
# or
cp .env.example .env    # Linux/Mac

# 5. Start backend
python -m uvicorn backend.main:app --reload
```

Backend should be running at: http://localhost:8000

### Frontend Setup

```bash
# 1. Navigate to frontend
cd frontend

# 2. Install dependencies
npm install

# 3. Start frontend
npm start
```

Frontend should open automatically at: http://localhost:3000

## Testing the Installation

### Generate Test PDFs

```bash
# Make sure backend dependencies are installed
python scripts/generate_test_pdfs.py
```

This creates test files in `test_files/` directory.

### Test via Web UI

1. Open http://localhost:3000
2. Click "Select PDF files"
3. Choose test PDFs from `test_files/` directory
4. Click "Scan PDFs"
5. Review results

### Test via API

```bash
# Health check
curl http://localhost:8000/health

# Scan a PDF
curl -X POST "http://localhost:8000/api/scan" \
  -F "files=@test_files/Aadhaar.pdf"

# View API docs
open http://localhost:8000/docs
```

## Expected Results

| File | Classification | Reason |
|------|---------------|--------|
| `Aadhaar.pdf` | Highly Sensitive | Contains Aadhaar number |
| `PAN.pdf` | Highly Sensitive | Contains PAN number |
| `Invoice.pdf` | Moderate Sensitive | Contains invoice keywords |
| `Normal.pdf` | Normal | No sensitive data |

## Troubleshooting

### Backend won't start

**Problem:** `ModuleNotFoundError` or import errors
**Solution:** Make sure virtual environment is activated and dependencies installed:
```bash
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
```

**Problem:** Port 8000 already in use
**Solution:** Change port:
```bash
python -m uvicorn backend.main:app --reload --port 8001
```

### OCR not working

**Problem:** `TesseractNotFoundError`
**Solution:** Install Tesseract:
- Ubuntu/Debian: `sudo apt-get install tesseract-ocr`
- macOS: `brew install tesseract`
- Windows: Download from GitHub and add to PATH

### Frontend can't connect

**Problem:** "Connection refused" or CORS errors
**Solution:** 
1. Check backend is running: `curl http://localhost:8000/health`
2. Check frontend `.env` or `package.json` proxy setting
3. Verify CORS settings in `backend/main.py`

### Docker issues

**Problem:** Build fails
**Solution:** 
```bash
docker-compose down
docker system prune
docker-compose up --build
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [DEPLOYMENT.md](DEPLOYMENT.md) for production deployment
- Review test files in `test_files/` directory
- Customize detection patterns in `backend/services/sensitive_detector.py`
- Adjust classification rules as needed

## Getting Help

1. Check logs: `logs/app.log` or `docker-compose logs`
2. Review API docs: http://localhost:8000/docs
3. Check unit tests: `python -m pytest backend/tests/`
4. Review error messages in browser console (F12)

Happy scanning! 🔍

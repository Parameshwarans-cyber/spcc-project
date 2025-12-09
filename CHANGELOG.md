# Changelog

All notable changes to the Smart PDF Confidentiality Classifier project.

## [1.0.0] - 2024-01-15

### Added
- Initial release of SPCC
- PDF text extraction with native text and OCR support
- Comprehensive sensitive data detection (Aadhaar, PAN, phone, email, IFSC, bank accounts, passwords, invoices, signatures)
- Smart classification system (Normal/Moderate/Highly Sensitive)
- PDF protection with watermarking and password encryption
- React frontend with modern UI
- FastAPI backend with async support
- Docker and Docker Compose configuration
- Unit tests for detection logic
- Test PDF generation script
- Comprehensive documentation (README, DEPLOYMENT)
- Setup scripts for Windows and Unix systems

### Features
- Bulk PDF upload (up to 10 files)
- Real-time progress indicators
- Extraction confidence scores
- Per-page detection results
- Protect button only shown for Moderate/Highly Sensitive documents
- Automatic file cleanup
- Comprehensive logging
- CORS support for frontend-backend communication
- Health check endpoints
- API documentation (Swagger/ReDoc)

### Technical Details
- Backend: FastAPI with Uvicorn
- Frontend: React 18
- OCR: Tesseract
- PDF Libraries: PyPDF2, pikepdf, reportlab
- Deployment: Docker, support for Heroku, Render, Railway

### Known Limitations
- OCR accuracy depends on image quality
- Currently optimized for English text
- File size limit: 50MB per file
- Default password should be changed in production

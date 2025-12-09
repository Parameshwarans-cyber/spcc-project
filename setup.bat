@echo off
REM Setup script for SPCC (Windows)

echo Smart PDF Confidentiality Classifier - Setup Script
echo ==================================================
echo.

REM Check Python
echo Checking Python version...
python --version
if errorlevel 1 (
    echo ERROR: Python not found. Please install Python 3.11+
    pause
    exit /b 1
)

REM Create virtual environment
echo.
echo Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install dependencies
echo.
echo Installing Python dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt

REM Check for Tesseract
echo.
echo Checking for Tesseract OCR...
where tesseract >nul 2>&1
if errorlevel 1 (
    echo WARNING: Tesseract not found in PATH
    echo Please install from: https://github.com/UB-Mannheim/tesseract/wiki
) else (
    echo Tesseract found
)

REM Check for Poppler
echo.
echo Checking for Poppler utilities...
where pdftoppm >nul 2>&1
if errorlevel 1 (
    echo WARNING: Poppler not found in PATH
    echo Please install from: https://github.com/oschwartz10612/poppler-windows/releases
) else (
    echo Poppler found
)

REM Create directories
echo.
echo Creating necessary directories...
if not exist uploads mkdir uploads
if not exist protected mkdir protected
if not exist logs mkdir logs
if not exist test_files mkdir test_files

REM Create .env file
if not exist .env (
    echo.
    echo Creating .env file...
    copy .env.example .env
    echo .env file created. Please edit it with your configuration.
) else (
    echo .env file already exists
)

echo.
echo ==================================================
echo Setup complete!
echo.
echo Next steps:
echo 1. Activate virtual environment: venv\Scripts\activate
echo 2. Edit .env file with your configuration
echo 3. Start backend: python -m uvicorn backend.main:app --reload
echo 4. In another terminal, start frontend: cd frontend ^&^& npm install ^&^& npm start
echo.
echo Or use Docker: docker-compose up --build
echo.
pause

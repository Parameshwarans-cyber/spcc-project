# Start Backend Server Script
Write-Host "Starting SPCC Backend Server..." -ForegroundColor Green
Write-Host ""

# Check Python
Write-Host "Checking Python installation..."
python --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python not found!" -ForegroundColor Red
    exit 1
}

# Install dependencies if needed
Write-Host ""
Write-Host "Installing dependencies (this may take a few minutes)..." -ForegroundColor Yellow
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# Create directories
Write-Host ""
Write-Host "Creating necessary directories..."
New-Item -ItemType Directory -Force -Path uploads,protected,logs | Out-Null

# Check if FastAPI is installed
Write-Host ""
Write-Host "Verifying installation..."
python -c "import fastapi; print('FastAPI installed successfully')" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "WARNING: Some packages may not have installed correctly." -ForegroundColor Yellow
    Write-Host "You may need to install them manually or use Python 3.11 instead of 3.13" -ForegroundColor Yellow
    Write-Host ""
}

# Start server
Write-Host ""
Write-Host "Starting backend server on http://localhost:8000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Write-Host "API Documentation: http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "Health Check: http://localhost:8000/health" -ForegroundColor Cyan
Write-Host ""

python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000 --reload

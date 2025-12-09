# Fix Connection Issues - Step by Step

## Problem: ERR_CONNECTION_REFUSED

This means the backend server is not running. Follow these steps:

## Step 1: Install Dependencies Manually

Open PowerShell in this directory and run these commands **ONE BY ONE**:

```powershell
# Install core dependencies first
python -m pip install --user fastapi
python -m pip install --user "uvicorn[standard]"
python -m pip install --user python-multipart

# Verify installation
python -c "import fastapi; print('FastAPI OK')"
```

If you see "FastAPI OK", continue. If not, there's a Python installation issue.

## Step 2: Install Remaining Dependencies

```powershell
python -m pip install --user PyPDF2 pikepdf reportlab Pillow
python -m pip install --user pytesseract pdf2image
python -m pip install --user python-dotenv aiofiles pydantic pydantic-settings
```

**Note:** Some packages (like `pikepdf`) might fail on Python 3.13. If so, try:
```powershell
python -m pip install --user --pre pikepdf
```

## Step 3: Create Directories

```powershell
mkdir uploads,protected,logs -Force
```

## Step 4: Start the Server

```powershell
python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000
```

You should see output like:
```
INFO:     Started server process [xxxx]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000
```

## Step 5: Test the Connection

Open your browser and go to:
- http://localhost:8000/health
- http://localhost:8000/docs

## Alternative: If Python 3.13 Has Issues

Python 3.13 is very new and some packages may not support it yet. Options:

### Option A: Use Python 3.11 or 3.12

1. Download Python 3.11 or 3.12 from python.org
2. Install it
3. Use it specifically:
   ```powershell
   py -3.11 -m pip install -r requirements.txt
   py -3.11 -m uvicorn backend.main:app --host 127.0.0.1 --port 8000
   ```

### Option B: Use a Virtual Environment

```powershell
# Create venv with specific Python version if you have multiple
python -m venv venv

# Activate (PowerShell)
.\venv\Scripts\Activate.ps1

# If activation is blocked, run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then activate and install
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000
```

## Troubleshooting

### "pip is not recognized"
- Make sure Python is installed properly
- Check: `python --version`
- Reinstall Python from python.org (not Microsoft Store version)

### "Module not found" even after install
- Try: `python -m pip install --user <package>`
- Check: `python -m pip list` to see installed packages
- Verify Python executable: `where.exe python`

### Port 8000 already in use
- Change port: `--port 8001`
- Or kill the process using port 8000:
  ```powershell
  netstat -ano | findstr :8000
  taskkill /PID <PID_NUMBER> /F
  ```

### Still not working?
Run this diagnostic script:
```powershell
python -c "import sys; print('Python:', sys.executable, sys.version); import fastapi; print('FastAPI:', fastapi.__version__)"
```

If this fails, Python or pip has an issue that needs to be resolved first.

## Quick Test Script

Save this as `test_server.py` and run it:

```python
import sys
print("Python:", sys.version)

try:
    import fastapi
    print("✓ FastAPI:", fastapi.__version__)
except ImportError as e:
    print("✗ FastAPI not found:", e)
    sys.exit(1)

try:
    from backend.main import app
    print("✓ Backend imports OK")
except Exception as e:
    print("✗ Backend import failed:", e)
    import traceback
    traceback.print_exc()
    sys.exit(1)

print("\n✓ All checks passed! Server should start.")
print("Run: python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000")
```

Run: `python test_server.py`


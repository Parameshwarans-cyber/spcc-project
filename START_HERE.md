# 🚀 How to Launch SPCC

## Quick Launch Guide

### Option 1: Use the PowerShell Script (Easiest)

1. Open PowerShell in this directory
2. Run:
   ```powershell
   .\start_backend.ps1
   ```

### Option 2: Manual Launch

#### Step 1: Install Dependencies

Open PowerShell and run:
```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

**Note:** If you're using Python 3.13, some packages might not have wheels available yet. Consider using Python 3.11 or 3.12 for better compatibility.

#### Step 2: Create Directories

```powershell
New-Item -ItemType Directory -Force -Path uploads,protected,logs
```

#### Step 3: Start Backend Server

```powershell
python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000 --reload
```

The backend will start at: **http://localhost:8000**

### Step 4: Start Frontend (Optional)

**Note:** Node.js is required for the frontend. If you don't have Node.js installed:

1. Install Node.js from https://nodejs.org/
2. Then run:
   ```powershell
   cd frontend
   npm install
   npm start
   ```

The frontend will start at: **http://localhost:3000**

### Option 3: Use Docker (If Available)

If you have Docker installed:

```powershell
docker-compose up --build
```

## Verify Backend is Running

Once started, test the backend:

```powershell
# Health check
curl http://localhost:8000/health

# Or open in browser:
# http://localhost:8000/health
# http://localhost:8000/docs (API documentation)
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'fastapi'"

**Solution:** Install dependencies:
```powershell
python -m pip install -r requirements.txt
```

### Python 3.13 Compatibility Issues

Some packages may not have wheels for Python 3.13 yet. Options:
- Use Python 3.11 or 3.12
- Install packages individually and check for errors
- Wait for package updates

### "Port 8000 already in use"

**Solution:** Change the port:
```powershell
python -m uvicorn backend.main:app --host 127.0.0.1 --port 8001 --reload
```

### Backend starts but can't connect

1. Check if server is actually running
2. Verify firewall isn't blocking port 8000
3. Try `http://127.0.0.1:8000` instead of `localhost`

## Using the Application

### Via Web UI (Frontend)
1. Start backend (port 8000)
2. Start frontend (port 3000)
3. Open http://localhost:3000 in browser

### Via API Only (Backend)
1. Start backend (port 8000)
2. Use API directly:
   - Documentation: http://localhost:8000/docs
   - Upload and scan PDFs via API endpoints
   - Use tools like Postman or curl

## Quick Test

Generate test PDFs and test:
```powershell
python scripts/generate_test_pdfs.py
```

Then upload them through the web UI or API.

---

**Need help?** Check README.md for detailed documentation.

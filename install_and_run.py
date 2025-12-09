"""Install dependencies and start the server"""
import subprocess
import sys
import os

def install_package(package):
    """Install a package and return True if successful"""
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package, "--user"], 
                            stdout=subprocess.PIPE, 
                            stderr=subprocess.PIPE)
        print(f"✓ Installed {package}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ Failed to install {package}")
        print(f"  Error: {e.stderr.decode() if e.stderr else 'Unknown error'}")
        return False

def main():
    print("Installing dependencies...")
    print("-" * 50)
    
    packages = [
        "fastapi==0.104.1",
        "uvicorn[standard]==0.24.0",
        "python-multipart==0.0.6",
        "PyPDF2==3.0.1",
        "pikepdf==8.10.1",
        "reportlab==4.0.7",
        "Pillow==10.1.0",
        "pytesseract==0.3.10",
        "pdf2image==1.16.3",
        "python-dotenv==1.0.0",
        "aiofiles==23.2.1",
        "pydantic==2.5.0",
        "pydantic-settings==2.1.0"
    ]
    
    for package in packages:
        install_package(package)
    
    print("-" * 50)
    print("\nVerifying installation...")
    
    try:
        import fastapi
        print(f"✓ FastAPI version: {fastapi.__version__}")
    except ImportError:
        print("✗ FastAPI not found")
        return
    
    try:
        import uvicorn
        print(f"✓ Uvicorn installed")
    except ImportError:
        print("✗ Uvicorn not found")
        return
    
    print("\nCreating directories...")
    for dir_name in ["uploads", "protected", "logs"]:
        os.makedirs(dir_name, exist_ok=True)
        print(f"✓ Created {dir_name}/")
    
    print("\n" + "=" * 50)
    print("Starting server...")
    print("=" * 50)
    print("Backend will be available at: http://localhost:8000")
    print("API docs: http://localhost:8000/docs")
    print("Press Ctrl+C to stop\n")
    
    # Start the server
    try:
        from backend.main import app
        import uvicorn
        uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
    except Exception as e:
        print(f"Error starting server: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()

"""Quick test to verify server can start"""
import sys

print("=" * 50)
print("SPCC Server Diagnostic Test")
print("=" * 50)
print(f"\nPython: {sys.executable}")
print(f"Version: {sys.version}\n")

# Test FastAPI
try:
    import fastapi
    print(f"✓ FastAPI installed: {fastapi.__version__}")
except ImportError as e:
    print(f"✗ FastAPI NOT installed: {e}")
    print("\nInstall with: python -m pip install --user fastapi")
    sys.exit(1)

# Test Uvicorn
try:
    import uvicorn
    print(f"✓ Uvicorn installed")
except ImportError as e:
    print(f"✗ Uvicorn NOT installed: {e}")
    print("\nInstall with: python -m pip install --user 'uvicorn[standard]'")
    sys.exit(1)

# Test backend imports
print("\nTesting backend imports...")
try:
    from backend.main import app
    print("✓ Backend imports successful!")
except ImportError as e:
    print(f"✗ Backend import failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
except Exception as e:
    print(f"✗ Backend error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

# Check directories
import os
for dir_name in ["uploads", "protected", "logs"]:
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
        print(f"✓ Created directory: {dir_name}/")

print("\n" + "=" * 50)
print("✓ ALL CHECKS PASSED!")
print("=" * 50)
print("\nTo start the server, run:")
print("  python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000")
print("\nThen open in browser:")
print("  http://localhost:8000/health")
print("  http://localhost:8000/docs")
print()

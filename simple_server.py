"""Simple test server to verify basic functionality"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(title="SPCC Test Server")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"status": "ok", "message": "SPCC Backend is running!"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    print("=" * 50)
    print("Starting SPCC Test Server")
    print("=" * 50)
    print("Server: http://localhost:8000")
    print("Health: http://localhost:8000/health")
    print("=" * 50)
    print()
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")

# Multi-stage Dockerfile for SPCC

# Stage 1: Backend
FROM python:3.11-slim as backend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    poppler-utils \
    libpoppler-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ ./backend/

# Create necessary directories
RUN mkdir -p uploads protected logs

# Expose backend port
EXPOSE 8000

# Set environment variables
ENV PORT=8000
ENV PYTHONUNBUFFERED=1

# Run backend
CMD ["python", "-m", "uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]

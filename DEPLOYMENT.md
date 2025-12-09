# Deployment Guide

## Quick Start with Docker

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Environment Variables

Create a `.env` file in the root directory:

```env
PORT=8000
PDF_PASSWORD=your_secure_password_here
LOG_LEVEL=INFO
```

## Production Deployment

### Option 1: Docker Compose (Recommended)

1. **Update environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with production values
   ```

2. **Update docker-compose.yml:**
   - Set specific CORS origins
   - Configure volume mounts for persistent storage
   - Set resource limits

3. **Deploy:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Option 2: Separate Services

#### Backend Only

```bash
# Build backend image
docker build -t spcc-backend .

# Run backend
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/uploads:/app/uploads \
  -v $(pwd)/protected:/app/protected \
  -v $(pwd)/logs:/app/logs \
  -e PDF_PASSWORD=your_password \
  --name spcc-backend \
  spcc-backend
```

#### Frontend Only

```bash
cd frontend
npm run build

# Serve with nginx or any static file server
# Copy build/ directory to your web server
```

## Cloud Platform Deployment

### Heroku

1. **Install Heroku CLI**

2. **Create Heroku app:**
   ```bash
   heroku create spcc-app
   ```

3. **Set environment variables:**
   ```bash
   heroku config:set PDF_PASSWORD=your_secure_password
   heroku config:set PORT=8000
   ```

4. **Deploy:**
   ```bash
   git push heroku main
   ```

**Note:** Heroku requires `Procfile`:
```
web: uvicorn backend.main:app --host 0.0.0.0 --port $PORT
```

### Render

1. **Connect GitHub repository**

2. **Create Web Service:**
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn backend.main:app --host 0.0.0.0 --port $PORT`
   - Environment: Python 3

3. **Set environment variables:**
   - `PDF_PASSWORD`: Your secure password
   - `PORT`: 8000 (auto-set by Render)

### Railway

1. **Import from GitHub**

2. **Railway auto-detects Python project**

3. **Set environment variables in dashboard:**
   - `PDF_PASSWORD`
   - `PORT` (auto-set)

4. **Deploy automatically**

### AWS / GCP / Azure

Use container services (ECS, Cloud Run, Container Instances) with the provided Dockerfile.

## Security Checklist

- [ ] Change `PDF_PASSWORD` to a strong password
- [ ] Configure CORS with specific allowed origins
- [ ] Enable HTTPS/SSL
- [ ] Set up firewall rules
- [ ] Configure log rotation
- [ ] Set up monitoring and alerts
- [ ] Review file retention policies
- [ ] Enable rate limiting (if needed)
- [ ] Set up backup for protected files
- [ ] Use secrets management for sensitive env vars

## Monitoring

### Health Check Endpoint

```bash
curl http://localhost:8000/health
```

### View Logs

```bash
# Docker
docker-compose logs -f backend

# Local
tail -f logs/app.log
```

### API Logs

```bash
curl http://localhost:8000/api/logs?limit=50
```

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :8000  # Linux/Mac
netstat -ano | findstr :8000  # Windows

# Kill process or change port
```

### Docker Build Issues

```bash
# Clean build
docker-compose down
docker system prune -a
docker-compose up --build
```

### OCR Not Working

Ensure Tesseract is installed in the container or system:
```bash
docker exec -it <container> tesseract --version
```

## Scaling

For horizontal scaling:
- Use load balancer (Nginx, Traefik)
- Store uploads/protected files in cloud storage (S3, GCS)
- Use Redis for session/queue management
- Deploy multiple backend instances

## Backup

Backup protected files regularly:
```bash
# Backup protected directory
tar -czf protected_backup_$(date +%Y%m%d).tar.gz protected/
```

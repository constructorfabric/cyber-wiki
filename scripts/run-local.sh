#!/usr/bin/env bash
set -e

# Run frontend and backend locally for development (multi-repo setup)

# Always resolve paths relative to the repo root, regardless of where the script is called from
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "Starting cyber-wiki locally (multi-repo setup)..."

# Kill any existing processes on ports 8888 and 5173
echo "Checking for existing processes on ports 8888 and 5173..."
lsof -ti:8888 | xargs kill -9 2>/dev/null || true
lsof -ti:5173 | xargs kill -9 2>/dev/null || true
sleep 1

# Define paths to backend and frontend repos
BACKEND_PATH="$REPO_ROOT/.workspace-sources/cyberfabric/cyber-wiki-back"
FRONTEND_PATH="$REPO_ROOT/.workspace-sources/cyberfabric/cyber-wiki-front"

# Check if backend repo exists
if [ ! -d "$BACKEND_PATH" ]; then
  echo "Error: Backend repo not found at $BACKEND_PATH"
  echo "Please clone the backend repo first"
  exit 1
fi

# Load .env.dev if present
if [ -f ".env.dev" ]; then
  set -a
  # shellcheck source=.env.dev
  source .env.dev
  set +a
fi

# Ensure DJANGO_SECRET_KEY is set (use from .env.dev or set a default)
if [ -z "$DJANGO_SECRET_KEY" ]; then
  export DJANGO_SECRET_KEY="dev-local-secret-key-change-in-staging"
  echo "Warning: DJANGO_SECRET_KEY not found in .env.dev, using default"
else
  export DJANGO_SECRET_KEY
fi

# Set environment variables
export REACT_APP_AUTH_API_URL=http://localhost:8888
export REACT_APP_VERSION=$(cat VERSION 2>/dev/null || echo "0.1.0")
export REACT_APP_BUILD_REF=$(git rev-parse --short HEAD 2>/dev/null || echo "dev")

# Start backend in background
echo "Starting backend on :8888..."
(
  cd "$BACKEND_PATH"
  if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
  fi
  python manage.py migrate --noinput
  python manage.py shell -c "
from django.contrib.auth.models import User
try:
    admin = User.objects.get(username='admin')
    admin.set_password('admin')
    admin.save()
    print('Updated admin user password (admin/admin)')
except User.DoesNotExist:
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('Created default admin user (admin/admin)')
"
  python manage.py runserver 0.0.0.0:8888
) &

BACKEND_PID=$!

cleanup() {
  echo "Stopping backend (PID $BACKEND_PID)..."
  kill "$BACKEND_PID" 2>/dev/null || true
}
trap cleanup EXIT

# Wait for backend to be ready
echo "Waiting for backend to be ready..."
sleep 3

# Start frontend if it exists and is configured
if [ -d "$FRONTEND_PATH" ] && [ -f "$FRONTEND_PATH/package.json" ]; then
  echo ""
  echo "=========================================="
  echo "🚀 CyberWiki Local Development"
  echo "=========================================="
  echo ""
  echo "Backend:  http://localhost:8888"
  echo "Frontend: http://localhost:5173 (starting...)"
  echo ""
  echo "Backend endpoints:"
  echo "  - API:        http://localhost:8888/api/"
  echo "  - Admin:      http://localhost:8888/admin/ (admin/admin)"
  echo "  - API Docs:   http://localhost:8888/api/docs/"
  echo "  - ReDoc:      http://localhost:8888/api/redoc/"
  echo ""
  echo "Press Ctrl+C to stop both servers"
  echo "=========================================="
  echo ""
  
  cd "$FRONTEND_PATH"
  npm run dev:all
else
  if [ ! -d "$FRONTEND_PATH" ]; then
    echo "Warning: Frontend repo not found at $FRONTEND_PATH"
  else
    echo "Warning: Frontend not yet configured (no package.json found)"
  fi
  echo ""
  echo "✅ Backend is running on http://localhost:8888"
  echo ""
  echo "Available endpoints:"
  echo "  - API:        http://localhost:8888/api/"
  echo "  - Admin:      http://localhost:8888/admin/ (admin/admin)"
  echo "  - API Docs:   http://localhost:8888/api/docs/"
  echo "  - Health:     http://localhost:8888/api/users/health/"
  echo ""
  echo "Press Ctrl+C to stop"
  wait "$BACKEND_PID"
fi

# CyberWiki

Collaborative documentation platform with Git integration - convert your git code to a docs portal.

## Multi-Repo Workspace Structure

This repository contains documentation and deployment scripts for the CyberWiki project. The actual source code is organized in separate repositories:

- **Backend**: `.workspace-sources/cyberfabric/cyber-wiki-back` - Django REST API
- **Frontend**: `.workspace-sources/cyberfabric/cyber-wiki-front` - React web application
- **Docs**: `docs/` - Technical specifications and design documents

## Quick Start

### Prerequisites

- Python 3.14+
- Node.js 25+ (for frontend)
- Git

### Running Locally

From this repository root:

```bash
./scripts/run-local.sh
```

This will:
1. Start the backend on http://localhost:8888
2. Start the frontend on http://localhost:5173
3. Auto-create admin user (admin/admin)
4. Run migrations automatically

### First Time Setup

1. **Clone the workspace sources** (if not already cloned):
   ```bash
   cd .workspace-sources/cyberfabric
   git clone https://github.com/cyberfabric/cyber-wiki-back
   git clone https://github.com/cyberfabric/cyber-wiki-front
   ```

2. **Setup backend**:
   ```bash
   cd .workspace-sources/cyberfabric/cyber-wiki-back
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python manage.py migrate
   ```

3. **Setup frontend** (when available):
   ```bash
   cd .workspace-sources/cyberfabric/cyber-wiki-front
   npm install
   ```

4. **Run from main repo**:
   ```bash
   cd /path/to/cyber-wiki
   ./scripts/run-local.sh
   ```

## Repository Structure

```
cyber-wiki/                          # Main repo (this one)
├── docs/                            # Technical documentation
│   └── specs/                       # Design specifications
│       ├── backend/DESIGN.md        # Backend architecture
│       ├── frontend/DESIGN.md       # Frontend architecture
│       ├── PRD.md                   # Product requirements
│       └── GAPS.md                  # Implementation gaps
├── scripts/                         # Deployment & utility scripts
│   └── run-local.sh                 # Local development runner
├── .workspace-sources/              # Linked source repositories
│   └── cyberfabric/
│       ├── cyber-wiki-back/         # Backend Django app
│       └── cyber-wiki-front/        # Frontend React app
└── .cypilot-workspace.toml          # Workspace configuration
```

## Development Status

### Backend ✅ COMPLETE

Django REST API with 70+ endpoints, 18 models, and comprehensive test coverage.

**Endpoints**:
- API: http://localhost:8888/api/
- Admin: http://localhost:8888/admin/ (credentials: `admin`/`admin`)
- Swagger Docs: http://localhost:8888/api/docs/
- ReDoc: http://localhost:8888/api/redoc/

**Core Features**:
- ✅ Token-based authentication (Bearer tokens)
- ✅ Git provider abstraction (GitHub, Bitbucket Server)
- ✅ Document management with UUID-based IDs
- ✅ Tree builder & navigation
- ✅ Comments with line anchoring
- ✅ Change management workflow
- ✅ Auto-tagging (TF-IDF)
- ✅ Link extraction & validation
- ✅ Background Git sync

### Frontend ✅ AUTHENTICATION COMPLETE

React application built with hai3 framework and OpenSpec workflow.

**Current Features**:
- ✅ Token-based authentication with login screen
- ✅ Redux state management (FLUX pattern)
- ✅ Event-driven architecture
- ✅ i18n support (English + Spanish)
- ✅ Demo screenset with UI components

**Access**:
- App: http://localhost:5173
- Login: `admin`/`admin`

**Next Steps**:
1. Repository browser
2. Document viewer
3. Comment UI
4. Tag management
5. Change approval workflow

## Tech Stack

- **Backend**: Django 5.2 + Django REST Framework
- **Frontend**: React + hai3 framework + Redux
- **Database**: SQLite (dev) / PostgreSQL (production)
- **Git Integration**: GitPython
- **Authentication**: Bearer tokens (JWT-like)

## Contributing

This is a multi-repo workspace. When making changes:
1. Backend changes go in `.workspace-sources/cyberfabric/cyber-wiki-back`
2. Frontend changes go in `.workspace-sources/cyberfabric/cyber-wiki-front`
3. Documentation and deployment scripts go in this main repo

# Custom Agent Navigation Rules

These rules are loaded alongside the generated rules in `{cypilot_path}/.gen/AGENTS.md`.

## Project Structure

CyberWiki is a multi-repo project managed via `.cypilot-workspace.toml`. Source repos are cloned into `.workspace-sources/cyberfabric/`.

| Component | Repo source name | Local path | Tech stack |
| --- | --- | --- | --- |
| Backend | `cyber-wiki-back` | `.workspace-sources/cyberfabric/cyber-wiki-back/` | Python, Django REST Framework |
| Frontend | `cyber-wiki-front` | `.workspace-sources/cyberfabric/cyber-wiki-front/` | TypeScript, React, Vite, TailwindCSS, FrontX (HAI3) |

- **Docs/specs** are in the root repo under `docs/specs/` (PRD, DESIGN, ADR, FEATURE, DECOMPOSITION).
- **Backend source** is at `.workspace-sources/cyberfabric/cyber-wiki-back/src/` (Django apps, `manage.py` at repo root).
- **Frontend source** is at `.workspace-sources/cyberfabric/cyber-wiki-front/src/` (React app, pages/components/api/events/actions/effects under `src/app/`).

## Navigation Rules

ALWAYS look in `.workspace-sources/cyberfabric/cyber-wiki-back/` WHEN working with backend code, APIs, models, or Django

ALWAYS look in `.workspace-sources/cyberfabric/cyber-wiki-front/` WHEN working with frontend code, UI components, pages, or styling

ALWAYS look in `docs/specs/` WHEN working with product requirements, architecture, or design documents

ALWAYS open `.workspace-sources/cyberfabric/cyber-wiki-front/.windsurf/rules/cyberwiki-front.md` WHEN modifying frontend code to follow FrontX conventions

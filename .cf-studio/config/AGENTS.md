# Custom Agent Navigation Rules

Add your project-specific WHEN rules here.
These rules are loaded alongside the generated rules in `{cf-studio-path}/.gen/AGENTS.md`.

## Project Structure

CyberWiki is a multi-repo project managed via `.cf-workspace.toml`. Source repos are available in `wsrc/constructorfabric/`.

| Component | Repo source name | Local path | Tech stack |
| --- | --- | --- | --- |
| Backend | `studio-back` | `wsrc/constructorfabric/cyber-wiki-back/` | Python, Django REST Framework |
| Frontend | `studio-front` | `wsrc/constructorfabric/cyber-wiki-front/` | TypeScript, React, Vite, TailwindCSS, FrontX (HAI3) |

- **Docs/specs** are in the root repo under `docs/specs/` (PRD, DESIGN, ADR, FEATURE, DECOMPOSITION).
- **Backend source** is at `wsrc/constructorfabric/cyber-wiki-back/src/` (Django apps, `manage.py` at repo root).
- **Frontend source** is at `wsrc/constructorfabric/cyber-wiki-front/src/` (React app, pages/components/api/events/actions/effects under `src/app/`).

## Navigation Rules

ALWAYS look in `wsrc/constructorfabric/cyber-wiki-back/` WHEN working with backend code, APIs, models, or Django

ALWAYS look in `wsrc/constructorfabric/cyber-wiki-front/` WHEN working with frontend code, UI components, pages, or styling

ALWAYS look in `docs/specs/` WHEN working with product requirements, architecture, or design documents

ALWAYS open `wsrc/constructorfabric/cyber-wiki-front/.windsurf/rules/cyberwiki-front.md` WHEN modifying frontend code to follow FrontX conventions
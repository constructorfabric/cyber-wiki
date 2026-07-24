<!-- @cf:root-agents -->
```toml
cf-studio-path = ".cf-studio"
```

ALWAYS resolve and enforce prerequisites of skills/workflows/commands BEFORE applying user intent.
<!-- /@cf:root-agents -->

## Project Structure

CyberWiki is a multi-repo workspace. Source repositories are defined in `.cf-workspace.toml` and are available under `wsrc/constructorfabric/`.

| Component | Local path | Tech stack |
| --- | --- | --- |
| Backend | `wsrc/constructorfabric/cyber-wiki-back/` | Python, Django REST Framework |
| Frontend | `wsrc/constructorfabric/cyber-wiki-front/` | TypeScript, React, Vite, TailwindCSS, FrontX |
| Docs/Specs | `docs/specs/` | Markdown (PRD, DESIGN, ADR, FEATURE) |

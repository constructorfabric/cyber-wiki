<!-- @cf:root-agents -->
```toml
cf-studio-path = ".cf-studio"
```

ALWAYS resolve and enforce prerequisites of skills/workflows/commands BEFORE applying user intent.
<!-- /@cf:root-agents -->

<!-- @cpt:root-agents -->
```toml
cypilot_path = "cypilot"
```
<!-- /@cpt:root-agents -->

## Project Structure

CyberWiki is a multi-repo workspace. Source repositories are defined in `.cypilot-workspace.toml` and cloned to `.workspace-sources/cyberfabric/`.

| Component | Local path | Tech stack |
| --- | --- | --- |
| Backend | `.workspace-sources/cyberfabric/cyber-wiki-back/` | Python, Django REST Framework |
| Frontend | `.workspace-sources/cyberfabric/cyber-wiki-front/` | TypeScript, React, Vite, TailwindCSS, FrontX |
| Docs/Specs | `docs/specs/` | Markdown (PRD, DESIGN, ADR, FEATURE) |

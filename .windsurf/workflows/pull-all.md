---
description: Pull latest changes for root repo and all workspace sources defined in .cypilot-workspace.toml
---

# Pull All Repositories

Pulls the latest changes for the root repository and every source listed in `.cypilot-workspace.toml`.

## Steps

// turbo

1. Pull the root repository:

   ```sh
   git pull
   ```

   (CWD: project root)

// turbo

2. Pull `cyber-wiki-back`:

   ```sh
   git pull
   ```

   (CWD: `.workspace-sources/cyberfabric/cyber-wiki-back`)

// turbo

3. Pull `cyber-wiki-front`:

   ```sh
   git pull
   ```

   (CWD: `.workspace-sources/cyberfabric/cyber-wiki-front`)

// turbo

4. Reinstall frontend dependencies:

   ```sh
   nvm use && npm ci
   ```

   (CWD: `.workspace-sources/cyberfabric/cyber-wiki-front`)

// turbo

5. Reinstall backend dependencies:

   ```sh
   pip install -r requirements.txt
   ```

   (CWD: `.workspace-sources/cyberfabric/cyber-wiki-back`)

6. Print a short summary of each pull result (already up to date / new commits / conflicts) and confirm dependencies are installed.

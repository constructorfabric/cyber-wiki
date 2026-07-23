# ADR-001: VCS Integration Pattern (Dynamic/API vs Build-time)


<!-- toc -->

- [Context and Problem Statement](#context-and-problem-statement)
- [Decision Drivers](#decision-drivers)
- [Considered Options](#considered-options)
  - [Option 1: Build-Time VCS Pattern (Docusaurus Model)](#option-1-build-time-vcs-pattern-docusaurus-model)
  - [Option 2: Dynamic/API Integration Pattern (Fumadocs Model) ✅ **SELECTED**](#option-2-dynamicapi-integration-pattern-fumadocs-model--selected)
- [Decision Outcome](#decision-outcome)
  - [Consequences](#consequences)
  - [Confirmation](#confirmation)
- [Pros and Cons of the Options](#pros-and-cons-of-the-options)
  - [Option 1: Build-Time VCS Pattern (Docusaurus Model)](#option-1-build-time-vcs-pattern-docusaurus-model-1)
  - [Option 2: Dynamic/API Integration Pattern (Fumadocs Model) ✅ **SELECTED**](#option-2-dynamicapi-integration-pattern-fumadocs-model--selected-1)
- [Decision Outcome Rationale](#decision-outcome-rationale)
- [Implementation Notes](#implementation-notes)
- [Related Decisions](#related-decisions)
- [References](#references)

<!-- /toc -->

**Status**: Accepted

**Date**: 2026-03-27

**ID**: `cpt-cyberwiki-adr-vcs-integration-pattern`

**Context**: Cyber Wiki requires integration with VCS providers (GitHub, Bitbucket Server) to fetch repository content, metadata, and pull request information. Modern documentation platforms implement VCS integration using two distinct architectural patterns: **Build-time Extraction** (static) and **Dynamic/API-driven Fetching** (real-time).

---
## Context and Problem Statement

Cyber Wiki requires integration with VCS providers (GitHub, Bitbucket Server) to fetch repository content, metadata, and pull request information. The decision is whether to use a build-time extraction model or a dynamic, API-driven runtime integration model.

## Decision Drivers

- Real-time accuracy for repository content and metadata
- Support for live collaboration features, including comments and PR-aware workflows
- Independence from full site rebuilds for documentation updates
- Extensibility across multiple VCS providers

## Considered Options

### Option 1: Build-Time VCS Pattern (Docusaurus Model)

**Description**: Treat VCS as a metadata provider during static site generation (SSG). Scrape the local `.git` folder during the build process.

**Implementation Characteristics**:
- **Git Metadata Extraction**: Execute Git commands (e.g., `git log -1 --format=%ct <file>`) locally on the build server to extract "Last Updated" timestamps
- **CI/CD Constraint**: Requires `fetch-depth: 0` in CI pipelines to access full Git history; the default shallow clone (`fetch-depth: 1`) breaks metadata extraction
- **Edit URLs**: Simple string interpolation pattern; append relative file paths to a base `editUrl`
- **Versioning**: Manage versions by copying files into `versioned_docs` directory and tracking in `versions.json`; Git tracks snapshots but versioning logic is filesystem-based
- **Update Latency**: Changes require full site rebuild (typically 5-10 minutes in CI/CD)

**Advantages**:
- Low complexity (native Node commands)
- No runtime API dependencies
- Works with any VCS provider (uses local Git)
- Zero-cost static hosting

**Limitations**:
- No real-time updates; documentation lags behind source code by the build duration
- Build-time failures block all documentation updates
- Metadata staleness between builds
- Cannot support live collaboration features (inline comments, PR reviews)
- Requires full CI/CD pipeline for every documentation change

### Option 2: Dynamic/API Integration Pattern (Fumadocs Model) ✅ **SELECTED**

**Description**: Treat VCS as a **remote data source**. Fetch content directly from VCS provider APIs at runtime.

**Implementation Characteristics**:
- **Remote Content Fetching**: Fetch content directly from VCS provider API at runtime using provider-specific tokens (e.g., `GITHUB_TOKEN`)
- **Hybrid Sync Model**:
  - **Production**: Use Incremental Static Regeneration (ISR); fetch latest content from VCS API, render, and cache; changes appear without full site rebuild
  - **Local/Dev**: Use Git submodules or local clones for development
- **Live Metadata**: Fetch author avatars, commit timestamps, and contributor data via VCS API in real-time
- **Code Integration**: Support for pulling type definitions and code context from source repositories
- **Update Latency**: Changes visible within seconds via ISR revalidation

**Advantages**:
- Near-instant documentation updates (no CI rebuild required)
- Live metadata (e.g., "Last edited by" with VCS provider avatars)
- Decoupled from build pipeline; documentation updates independent of site deployment
- Enables live collaboration features (inline comments visible with ongoing PR changes)
- Real-time PR status and file browsing
- Supports "Living Document" model

**Limitations**:
- Medium complexity (requires API handling)
- Requires server or serverless infrastructure (not pure static hosting)
- Depends on VCS provider API availability
- API rate limits must be managed

---

## Decision Outcome

**Cyber Wiki adopts the Dynamic/API Integration pattern** as the primary VCS integration strategy.

The system **MUST** implement VCS integration using the Dynamic/API pattern, fetching content, metadata, and repository information from VCS provider APIs at runtime rather than during build-time extraction.

### Consequences

**Positive**:
- Users see documentation updates within seconds of pushing commits
- Live metadata (author avatars, commit timestamps) enhances collaboration
- Inline comments can be displayed alongside ongoing PR changes
- PR status and file browsing are always up-to-date
- No CI/CD pipeline required for documentation updates
- Supports multi-VCS providers through abstract API interface

**Negative**:
- Requires server or serverless infrastructure (cannot use pure static hosting)
- Must implement API rate limit handling and caching strategies
- Depends on VCS provider API availability (requires fallback mechanisms)
- Medium implementation complexity (API client libraries, error handling, retry logic)

**Neutral**:
- Infrastructure cost is higher than static hosting but justified by feature requirements
- API token management required (OAuth, ZTA tokens)

### Confirmation

This ADR records the accepted choice of the Dynamic/API integration pattern and confirms that the rejected build-time alternative remains documented for comparison.

## Pros and Cons of the Options

### Option 1: Build-Time VCS Pattern (Docusaurus Model)

**Pros**:
- Low complexity
- No runtime API dependency
- Broad compatibility with any VCS provider that exposes local Git history

**Cons**:
- Delayed updates tied to rebuild cycles
- Cannot support real-time collaboration and PR-aware workflows
- Build pipeline issues block documentation freshness

### Option 2: Dynamic/API Integration Pattern (Fumadocs Model) ✅ **SELECTED**

**Pros**:
- Near-real-time updates and live metadata
- Supports collaboration features that depend on current VCS state
- Decouples documentation freshness from site rebuilds

**Cons**:
- Requires runtime infrastructure and API handling
- Must manage provider availability, caching, and rate limits

## Decision Outcome Rationale

**Why Dynamic/API Integration**:

1. **Real-time Accuracy**: Engineering teams need documentation that reflects the current state of the codebase without waiting for CI builds. A 5-10 minute lag is unacceptable for active development workflows.

2. **Decoupled Updates**: Documentation changes should not require full application redeployment. Developers should be able to push a commit and see the change reflected immediately.

3. **Live Collaboration**: Inline comments, PR reviews, and file browsing require real-time data from the VCS provider. Comments must be visible alongside ongoing PR changes as files evolve.

4. **Metadata Richness**: Dynamic API access enables features like live author avatars, real-time PR status, up-to-date commit history, and blame information that are critical for collaboration.

5. **Alignment with Product Vision**: Cyber Wiki aims to be a "Living Document" platform where changes pushed to the VCS provider appear within seconds, not minutes or hours.

**Comparative Analysis**:

| Feature | Docusaurus (Build-time) | Fumadocs (Dynamic/API) | Cyber Wiki Choice |
|---------|-------------------------|------------------------|-------------------|
| Data Source | Local `.git` folder | VCS Provider API | **VCS Provider API** |
| Update Latency | 5-10 min (CI build) | Seconds (ISR) | **Seconds (real-time)** |
| Metadata | Scraped during build | Fetched via API | **API-driven (live)** |
| Versioning | Filesystem snapshots | Branch/Tag mapping | **Branch mapping** |
| Complexity | Low (CLI commands) | Medium (API handling) | **Medium (justified by features)** |
| Infrastructure | Static hosting | Server/serverless | **Server-based** |

---

## Implementation Notes

- Implement abstract VCS provider interface with concrete implementations for GitHub and Bitbucket Server
- Use caching strategies (ISR, CDN caching) to minimize API calls and respect rate limits
- Implement graceful degradation when VCS provider API is unavailable
- Monitor API usage and implement rate limit handling
- Consider webhook-based cache invalidation for instant updates

---

## Related Decisions

- ADR-002: Comment System Architecture (requires real-time VCS integration)
- VCS Provider Interface Contract (PRD Section 6.11)

---

## References

- Docusaurus VCS Integration: https://docusaurus.io/docs/api/plugins/@docusaurus/plugin-content-docs
- Fumadocs GitHub Integration: https://fumadocs.vercel.app/docs/headless/source-api
- Next.js ISR: https://nextjs.org/docs/basic-features/data-fetching/incremental-static-regeneration

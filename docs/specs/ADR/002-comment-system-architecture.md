# ADR-002: Comment System Architecture (Database-Native vs Third-Party)


<!-- toc -->

- [Context and Problem Statement](#context-and-problem-statement)
- [Decision Drivers](#decision-drivers)
- [Considered Options](#considered-options)
  - [Option 1: Disqus (Third-Party Platform)](#option-1-disqus-third-party-platform)
  - [Option 2: Giscus (GitHub Discussions Frontend)](#option-2-giscus-github-discussions-frontend)
  - [Option 3: GitHub Discussions Integration (Fumadocs Pattern)](#option-3-github-discussions-integration-fumadocs-pattern)
  - [Option 4: Confluence (Enterprise Wiki Platform)](#option-4-confluence-enterprise-wiki-platform)
  - [Option 5: Database-Native with VCS Sync (Cyber Wiki Approach) ✅ **SELECTED**](#option-5-database-native-with-vcs-sync-cyber-wiki-approach--selected)
- [Decision Outcome](#decision-outcome)
  - [Consequences](#consequences)
  - [Confirmation](#confirmation)
- [Pros and Cons of the Options](#pros-and-cons-of-the-options)
  - [Option 1: Disqus (Third-Party Platform)](#option-1-disqus-third-party-platform-1)
  - [Option 2: Giscus (GitHub Discussions Frontend)](#option-2-giscus-github-discussions-frontend-1)
  - [Option 3: GitHub Discussions Integration (Fumadocs Pattern)](#option-3-github-discussions-integration-fumadocs-pattern-1)
  - [Option 4: Confluence (Enterprise Wiki Platform)](#option-4-confluence-enterprise-wiki-platform-1)
  - [Option 5: Database-Native with VCS Sync (Cyber Wiki Approach) ✅ **SELECTED**](#option-5-database-native-with-vcs-sync-cyber-wiki-approach--selected-1)
- [Decision Outcome Rationale](#decision-outcome-rationale)
  - [Key Requirements](#key-requirements)
  - [Comparative Analysis](#comparative-analysis)
- [Implementation Notes](#implementation-notes)
  - [Database Schema](#database-schema)
  - [Line-Anchoring Algorithm](#line-anchoring-algorithm)
  - [Optional VCS Sync (Future)](#optional-vcs-sync-future)
- [Related Decisions](#related-decisions)
- [References](#references)

<!-- /toc -->

**Status**: Accepted

**Date**: 2026-03-27

**ID**: `cpt-cyberwiki-adr-comment-system-architecture`

**Context**: Cyber Wiki requires an inline comment system for code review, documentation review, and collaboration. Comments must support line-level anchoring, threading, resolution workflows, and integration with VCS provider workflows (especially PR reviews). Modern platforms use various comment system architectures, from third-party services (Disqus) to VCS-backed storage (Giscus, GitHub Discussions) to enterprise wikis (Confluence).

---
## Context and Problem Statement

Cyber Wiki needs an inline comment architecture that supports code review and documentation review with line-level precision, threading, resolution, and VCS-aware workflows. The decision is whether to rely on an external comment platform, a VCS-hosted discussion system, or a database-native architecture owned by the product.

## Decision Drivers

- Line-level anchoring that survives document and PR evolution
- Visibility of comments alongside ongoing PR changes
- Multi-VCS support without tying the product to one provider
- Data ownership, privacy, and flexible access control
- Confluence-like collaboration UX for technical documents

## Considered Options

### Option 1: Disqus (Third-Party Platform)

**Description**: Standalone, third-party commenting service; embeds via JavaScript snippet; comments stored on Disqus servers.

**Implementation Characteristics**:
- **Mechanism**: Embed JavaScript snippet; comments stored on Disqus servers
- **Authentication**: Social login (Google, Facebook, Twitter) or native Disqus account
- **Storage**: Proprietary external database (Disqus servers)
- **Privacy**: Tracks users for analytics/marketing; not privacy-focused
- **Cost**: Free (with ads) or paid subscription

**Advantages**:
- Plug-and-play; no backend infrastructure required
- Powerful moderation dashboard
- Works with any website
- Mature platform with spam filtering

**Limitations**:
- **Comments stored on external servers** (vendor lock-in)
- Free version includes ads and user tracking
- No line-level anchoring (page-level only)
- No Git integration
- Comments not portable with repository
- No control over data export or privacy

**Verdict**: Not suitable. Comments must be stored in platform database, not external servers.

### Option 2: Giscus (GitHub Discussions Frontend)

**Description**: Open-source React component that embeds GitHub Discussions as a comment widget; uses GitHub Discussions API as backend.

**Implementation Characteristics**:
- **Mechanism**: React component; uses GitHub Discussions API as backend
- **Authentication**: GitHub account required (OAuth)
- **Storage**: GitHub Discussions (open, portable)
- **Privacy**: No tracking; privacy-focused; fully transparent
- **Cost**: Always free

**Advantages**:
- Zero backend infrastructure
- Comments stored in GitHub Discussions (open, portable)
- No ads or tracking
- Supports Markdown and reactions
- Comments move with repository

**Limitations**:
- **GitHub-only** (not multi-VCS)
- **No line-level anchoring** (page-level or section-level only)
- **Comments not visible alongside ongoing PR changes**
- Requires public repository for public comments
- Users must have GitHub accounts
- Cannot support Commenter role (requires GitHub repository access)

**Verdict**: Not suitable. Requires line-level anchoring, multi-VCS support, and PR workflow integration.

### Option 3: GitHub Discussions Integration (Fumadocs Pattern)

**Description**: Uses GitHub Discussions API as comment backend; feedback components post comments directly to GitHub repository discussions.

**Implementation Characteristics**:
- **Mechanism**: Direct API integration with GitHub Discussions
- **Authentication**: GitHub OAuth
- **Storage**: GitHub Discussions
- **Privacy**: No tracking

**Advantages**:
- Leverages existing GitHub authentication
- Comments visible in GitHub UI
- No separate comment database required

**Limitations**:
- **GitHub-only** (not multi-VCS)
- **Comments tied to repository discussions rather than specific file lines**
- **Limited line-anchoring support**
- **Comments not visible alongside ongoing PR changes**
- Page-level or section-level feedback only

**Verdict**: Not suitable. Requires line-level anchoring and multi-VCS support.

### Option 4: Confluence (Enterprise Wiki Platform)

**Description**: Proprietary inline comment system; comments stored in Confluence database; supports page-level and inline (paragraph/block) comments.

**Implementation Characteristics**:
- **Mechanism**: Proprietary inline comment system
- **Authentication**: Atlassian account or SSO integration
- **Storage**: Confluence database (Atlassian Cloud or self-hosted)
- **Privacy**: Enterprise-grade; full control over data
- **Cost**: License required

**Advantages**:
- **Excellent inline comment UX** (threading, resolution, @mentions, notifications)
- Mature moderation tools
- Rich formatting support
- Enterprise-grade security and privacy

**Limitations**:
- **No Git integration** (comments not linked to code or file versions)
- **No line-level anchoring for code files**
- **Limited code rendering options**
- Comments not visible alongside ongoing PR changes
- Requires expensive Confluence license
- Vendor lock-in

**Verdict**: Excellent UX but lacks Git integration. Use as inspiration for inline comment UX, but cannot adopt directly.

### Option 5: Database-Native with VCS Sync (Cyber Wiki Approach) ✅ **SELECTED**

**Description**: Comments stored in platform database with VCS metadata (repo, branch, file path, line range); optionally synced to VCS as commit annotations or PR comments.

**Implementation Characteristics**:
- **Mechanism**: Platform database storage with VCS metadata
- **Authentication**: SSO/OIDC (enterprise authentication)
- **Storage**: Platform database with full control
- **Privacy**: No tracking; full control over user data

**Advantages**:
- **Full control over comment features** (line anchoring, threading, status)
- **Works with any VCS provider** (GitHub, Bitbucket, GitLab, etc.)
- **Supports line-level and range-level comments**
- **Comments visible alongside ongoing PR changes**
- **Confluence-like inline comment UX** (threading, resolution, @mentions)
- **Code-first features** (syntax highlighting, line-level precision)
- Data ownership (no vendor lock-in)
- Access control flexibility (Commenter role without VCS write permissions)

**Limitations**:
- Requires database infrastructure
- Comments not visible in native VCS UI unless synced (optional feature)
- Medium implementation complexity

---

## Decision Outcome

**Cyber Wiki adopts a database-native comment system** with Confluence-like inline comment UX and deep Git integration.

The system **MUST** store all inline comments in the platform database with VCS metadata (provider, project, repository, branch, file path, line range). Comments **cannot be stored on external servers** or VCS provider platforms.

### Consequences

**Positive**:
- Full control over comment features (line anchoring, threading, status, resolution)
- Works consistently across all VCS providers (GitHub, Bitbucket, GitLab)
- Comments visible alongside ongoing PR changes
- Confluence-like inline comment UX for excellent user experience
- Access control decoupled from VCS permissions (enables Commenter role)
- No vendor lock-in; full data ownership
- No third-party tracking or privacy concerns
- Code-first features (syntax highlighting, line-level precision)

**Negative**:
- Requires database infrastructure and maintenance
- Comments not visible in native VCS UI unless optional sync is implemented
- Medium implementation complexity (line-anchoring algorithms, threading, status management)

**Neutral**:
- Infrastructure cost justified by feature requirements and data ownership
- Optional VCS sync can be added in future versions to make comments visible in native VCS UI

### Confirmation

This ADR confirms the accepted database-native architecture and preserves the rejected alternatives as reference points for future review.

## Pros and Cons of the Options

### Option 1: Disqus (Third-Party Platform)

**Pros**:
- Very low implementation effort
- Mature moderation and spam tooling

**Cons**:
- External data ownership and tracking concerns
- No line-level anchoring or Git integration

### Option 2: Giscus (GitHub Discussions Frontend)

**Pros**:
- No custom backend needed
- Portable within GitHub-based repositories

**Cons**:
- GitHub-only and not suitable for multi-VCS support
- No line-level anchoring or PR-evolution visibility

### Option 3: GitHub Discussions Integration (Fumadocs Pattern)

**Pros**:
- Reuses GitHub authentication and discussion surfaces
- Minimal separate comment infrastructure

**Cons**:
- Repository discussion model is not file-line centric
- Ties the product to GitHub-specific workflows

### Option 4: Confluence (Enterprise Wiki Platform)

**Pros**:
- Strong inline collaboration UX
- Mature enterprise moderation and access patterns

**Cons**:
- No deep Git or PR integration
- Vendor lock-in and limited code-centric workflows

### Option 5: Database-Native with VCS Sync (Cyber Wiki Approach) ✅ **SELECTED**

**Pros**:
- Full control over anchoring, threading, status, and access control
- Consistent behavior across multiple VCS providers
- Supports PR-aware and code-aware comment experiences

**Cons**:
- Requires backend and database ownership
- Higher implementation complexity than embedding a third-party option

## Decision Outcome Rationale

**Why Database-Native (Cyber Wiki Approach)**:

Cyber Wiki requires a **flexible, extensible, Confluence-like inline comment system with deep Git integration**. While each existing solution offers valuable concepts, none meets all requirements.

### Key Requirements

1. **Line-Level Anchoring**: The platform requires sophisticated line-anchoring algorithms that track comment positions as files evolve through Git commits. This is not supported by Disqus, Giscus, GitHub Discussions, or Confluence.

2. **Comments Visible with Ongoing PR Changes**: **Comments must be visible alongside ongoing PR changes**. Users must be able to comment on files in active PRs and see those comments update as the PR evolves. This requires tight integration with VCS metadata and file versioning.

3. **Cannot Store Comments on External Servers**: The system **cannot store comments on external servers** (Disqus, Giscus) because:
   - Comments must be tightly integrated with VCS metadata (repo, branch, file path, line range)
   - Comments must remain visible and anchored as files change through Git commits and PR updates
   - The platform needs full control over comment lifecycle, threading, status, and line-anchoring algorithms

4. **Multi-VCS Support**: Database storage decouples comments from any specific VCS provider, enabling consistent comment functionality across GitHub, Bitbucket, GitLab, etc. Giscus and GitHub Discussions are GitHub-only.

5. **Access Control Flexibility**: Database storage allows users without VCS write permissions to comment, enabling the Commenter role. Giscus requires GitHub accounts with repository access.

6. **Confluence-Like UX**: The platform must provide excellent inline comment UX inspired by Confluence:
   - Threaded discussions
   - Rich formatting
   - @mentions and notifications
   - Comment resolution workflow
   - Mature moderation tools

7. **Code-First Features**: Full syntax highlighting and code-specific features that Confluence lacks.

### Comparative Analysis

| Feature | Disqus | Giscus | GitHub Discussions | Confluence | Database-Native (Cyber Wiki) |
|---------|--------|--------|-------------------|------------|------------------------------|
| Data Storage | Disqus Servers | GitHub Discussions | GitHub Discussions | Confluence Database | Platform Database |
| Authentication | Social (FB, Google, etc.) | GitHub Only | GitHub Only | Atlassian/SSO | SSO/OIDC |
| Cost | Free (with ads) or Paid | Always Free | Always Free | License Required | Infrastructure cost |
| Privacy | Tracks users for ads | No tracking | No tracking | Enterprise-grade | No tracking |
| Formatting | Basic HTML | Full Markdown | Full Markdown | Rich Text + Markdown | Full Markdown |
| Line-Level Comments | No | No | No | No | **Yes** |
| Inline Comment UX | Basic | Good | Good | **Excellent** | **Excellent** (Confluence-like) |
| Git Integration | No | Yes (GitHub only) | Yes (GitHub only) | **No** | **Yes (Multi-VCS)** |
| Code Rendering | No | Yes | Yes | **Limited** | **Yes (Syntax highlighting)** |
| PR Integration | No | No | No | No | **Yes (comments visible with PR changes)** |
| Multi-VCS Support | Yes | No | No | No | **Yes** |
| Comment Portability | Vendor lock-in | Moves with repo | Moves with repo | Vendor lock-in | Database export |
| Threaded Discussions | Yes | Yes | Yes | **Yes** | **Yes** |
| Resolution Workflow | Basic | Reactions only | Reactions only | **Yes** | **Yes** |
| Backend Required | No | No | No | Yes (Confluence) | Yes |
| Alignment | General Audience | Developers | Developers | Enterprise Docs | **Code Review + Docs** |

---

## Implementation Notes

### Database Schema

Comments must be stored with the following metadata:
- VCS provider identifier (e.g., `bitbucket_server`, `github`)
- Project key / organization
- Repository slug / name
- Branch name
- File path
- Line range (start and end line numbers)
- Comment content and author
- Timestamp and status (open, resolved, deleted)
- Parent comment ID (for threading)

### Line-Anchoring Algorithm

Implement deterministic line-anchoring algorithm that:
- Captures exact commented line content and surrounding context
- Tracks comment positions as files evolve through Git commits
- Reports status: anchored, moved, outdated, or deleted
- Uses line normalization and exact string matching with context-window fallback

### Optional VCS Sync (Future)

The platform **MAY** implement optional VCS sync in future versions:
- **GitHub**: Sync comments as PR review comments or commit annotations via GitHub API
- **Bitbucket**: Sync comments as inline PR comments via Bitbucket API
- **Bidirectional Sync**: Import comments created in VCS UI back into platform database
- Sync would be **optional** and **unidirectional by default** (platform → VCS) to avoid conflicts

---

## Related Decisions

- ADR-001: VCS Integration Pattern (Dynamic/API enables real-time comment visibility with PR changes)
- Comment Line-Anchoring Algorithm (PRD Section 6.3)
- Comment Storage Requirement (PRD Section 6.3)

---

## References

- Disqus: https://disqus.com/
- Giscus: https://giscus.app/
- Fumadocs Feedback Component: https://fumadocs.vercel.app/docs/ui/blocks/feedback
- Confluence Comments: https://confluence.atlassian.com/doc/comments-139414.html

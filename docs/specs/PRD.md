# PRD — Cyber Wiki

<!-- toc -->

- [1. Overview](#1-overview)
  - [1.1 Purpose](#11-purpose)
  - [1.2 Background / Problem Statement](#12-background--problem-statement)
  - [1.3 Goals (Business Outcomes)](#13-goals-business-outcomes)
  - [1.4 Glossary](#14-glossary)
- [2. Actors](#2-actors)
  - [2.1 Human Actors](#21-human-actors)
  - [2.2 System Actors](#22-system-actors)
- [3. Operational Concept & Environment](#3-operational-concept--environment)
  - [3.1 Module-Specific Environment Constraints](#31-module-specific-environment-constraints)
- [4. Competitors & Industry Analysis](#4-competitors--industry-analysis)
  - [4.1 VCS Integration Patterns](#41-vcs-integration-patterns)
  - [4.2 Comment System Architecture](#42-comment-system-architecture)
- [5. Scope](#5-scope)
  - [5.1 In Scope](#51-in-scope)
  - [5.2 Out of Scope](#52-out-of-scope)
- [6. Functional Requirements](#6-functional-requirements)
  - [6.1 Repository & Space Navigation](#61-repository--space-navigation)
  - [6.2 IDE Integration](#62-ide-integration)
  - [6.3 Live Document Editing](#63-live-document-editing)
  - [6.4 Contextual Inline Comments](#64-contextual-inline-comments)
  - [6.5 Change Review Workflow](#65-change-review-workflow)
  - [6.6 Rich Content Previews](#66-rich-content-previews)
  - [6.7 Document Validation](#67-document-validation)
  - [6.8 Git Synchronisation](#68-git-synchronisation)
  - [6.9 Search](#69-search)
  - [6.10 JIRA Integration](#610-jira-integration)
  - [6.11 Access Control](#611-access-control)
  - [6.12 VCS Integration](#612-vcs-integration)
  - [6.13 Document Metadata & Tagging](#613-document-metadata--tagging)
- [7. Non-Functional Requirements](#7-non-functional-requirements)
  - [7.1 Module-Specific NFRs](#71-module-specific-nfrs)
  - [7.2 NFR Exclusions](#72-nfr-exclusions)
- [8. Public Library Interfaces](#8-public-library-interfaces)
  - [8.1 Public API Surface](#81-public-api-surface)
  - [8.2 External Integration Contracts](#82-external-integration-contracts)
- [9. Use Cases](#9-use-cases)
  - [Edit and Commit a Document](#edit-and-commit-a-document)
  - [Authenticate and Configure Git Credentials](#authenticate-and-configure-git-credentials)
  - [Browse Repository File Tree](#browse-repository-file-tree)
  - [View File Content with Inline Comments](#view-file-content-with-inline-comments)
  - [View Pull Requests and Navigate to VCS Provider](#view-pull-requests-and-navigate-to-vcs-provider)
  - [Tag and Link Documents Across Repositories](#tag-and-link-documents-across-repositories)
  - [Discover Documents by Tags](#discover-documents-by-tags)
- [10. Acceptance Criteria](#10-acceptance-criteria)
- [11. Dependencies](#11-dependencies)
- [12. Assumptions](#12-assumptions)
- [13. Risks](#13-risks)
- [14. Open Questions](#14-open-questions)

<!-- /toc -->

---

## 1. Overview

### 1.1 Purpose

Cyber Wiki is a Git-native documentation and collaboration platform that brings a GitHub-like experience to engineering teams who need more than a code host — structured doc authoring, rich previews, context-aware commenting, semantic search, smart validation, and deep integrations with project-tracking tools. It treats Git as the single source of truth while removing the barriers that prevent non-engineers from participating in documentation workflows.

The platform bridges the gap between raw Git tooling and heavyweight wiki/knowledge-base products: it is fast, version-controlled, validation-aware, and extensible.

### 1.2 Background / Problem Statement

Engineering teams already store their most important content — architecture decisions, API specs, runbooks, design docs — inside Git repositories. However, the available tooling forces a painful trade-off: either use a plain Git host (GitHub/GitLab) and accept a minimal editing and review experience, or use a separate wiki product (Confluence, Notion) and accept that the content drifts away from the codebase.

The result is fragmented knowledge: stale wiki pages that no longer reflect the code, review comments that get lost after merge, JIRA tickets that must be opened in a separate tab just to read the status, and broken links that nobody notices until it is too late.

**Target Users:**

- Engineers and architects authoring and reviewing technical documentation
- Product managers and designers who need to comment on specs without a Git client
- Team leads who need to track document state, pending reviews, and JIRA alignment
- Automation and CI pipelines that need to validate document conformance

**Key Problems Solved:**

- Fragmentation between source code and documentation
- High friction for non-engineers to contribute to or comment on any Git-hosted documents (including PRDs, requirements, use cases, design docs, and technical documentation)
- Lack of in-context JIRA visibility — readers must context-switch to find ticket status
- No enforcement mechanism for document quality or link integrity
- Semantic search is unavailable across Git-hosted documentation
- Advanced editing capabilities - WYSIWYG for tables, heading, styles
- Advanced documents and code content presentation capabilities - diagrams, tables, code snippets, xls tables or ppt or pdf preview, etc
- Automated navigation across git source files and documents - table of contents, parent/child pages, references to other repositories or files

### 1.3 Goals (Business Outcomes)

**Success Criteria:**

- Editing and committing a document takes under 60 seconds for an authenticated Editor (Baseline: no baseline — new product; Target: v1.0 — Q3 2026)
- Broken internal links are surfaced before a document is saved (Baseline: not possible today; Target: v1.0 — Q3 2026)
- Semantic search returns relevant results across 10,000 documents in under 2 seconds (Baseline: N/A; Target: v1.0 — Q3 2026)
- JIRA issue status is visible inline without leaving the document (Baseline: not possible today; Target: v1.0 — Q3 2026)
  - It must be possible to configure what JIRA fields to be displayed, such as fix version, assignee, title, etc
  - It must be possible to show the whole JIRA items list with selected fields

**Capabilities:**

- Browse, author, and review Git-backed documents from a web UI
- Seamless bidirectional navigation between Git raw documents and Cyber Wiki viewer (click raw doc link in Git to open in browser with full context; click in viewer to see raw doc in Git)
- VS Code extension for IDE-native access to documentation browsing, editing, and commenting
- REST API access for AI agents (CyPilot) to read, search, and analyze documentation content
- Leave context-aware inline comments that survive content changes (comments are flagged when anchored text is removed)
- Document-level comments displayed at page bottom (Confluence-style end-of-page comments for general feedback not tied to specific lines)
- Preview rich content: Markdown, sequence diagrams, draw.io diagrams, tables
- Validate documents against configurable rules before saving (Admins configure validation rules per Space to enforce link integrity, schema compliance, and custom domain-specific requirements; prevents broken links and malformed documents)
- Synchronise document changes bidirectionally with Git repositories
- Surface JIRA issue data (status, assignee, priority) inline in documents
- Full-text search across all documents with exact keyword matching, file/folder filtering, and highlighted results (basic search that works reliably first)
- Optional semantic search using AI-powered embeddings for relevance-ranked results (enhancement for exploratory queries when exact keywords aren't known)
- Edit documents with WYSIWYG editor by default (headings, styles, tables, links render as formatted content while editing) with optional raw editing mode toggle for developers who need to see/edit underlying Markdown/HTML source
- Multi-repository documentation workspace (Admins configure which Git repositories are accessible as Spaces, which files/folders are discoverable, and how documents are organized; enables unified documentation access across multiple repositories without requiring users to know Git repository locations)
- Configurable notification system for document changes (users subscribe to specific documents, folders, or Spaces; choose notification channels per subscription — email, Teams, Slack; prevents notification flooding by requiring explicit opt-in per document/folder)
- Embedded AI chat interface for documentation assistance (LLM-powered assistant with full documentation context enables users to ask questions, request summaries, and explore content conversationally)
- Inline AI editing assistance (integrate LLM-based assistants such as CyPilot, Claude, GPT, or local models to fix misprints, suggest better wording, and improve content directly within the editor)
- Support integration with local LLM models for AI-powered editing and content enhancement

### 1.4 Glossary

| Term | Definition |
|------|------------|
| VCS (Version Control System) | A system that tracks changes to files over time, enabling multiple people to collaborate on documents and code while maintaining a complete history of all changes. Common VCS platforms include Git, GitHub, and Bitbucket. |
| Space | A top-level organisational unit that groups related documents, optionally linked to a Git repository |
| Document | A file (typically Markdown) stored within a Space, version-controlled through Git |
| VCS Provider | An external version control system hosting service (e.g., GitHub, Bitbucket Server) accessed via an abstract pluggable interface; v1 supports GitHub and Bitbucket Server, and the interface allows further providers to be added without changing application logic |
| Document View | A left navigation mode that presents Space contents as a titled document hierarchy (Confluence-style), derived from a configurable Document Index rather than the raw file tree |
| File Tree View | A left navigation mode that presents Space contents as the raw directory and file structure from the Git repository, mirroring the on-disk layout |
| Document Index | A configurable mapping that determines which files in a Space are treated as Documents, how they are labelled (title extraction rules), and how they are ordered and grouped in the Document View |
| Title Extraction Rule | A configurable rule specifying how the platform derives a human-readable title for a Document (e.g., first `#` heading in Markdown, YAML front-matter `title` field, filename without extension) |
| Inline Comment | An annotation anchored to a line range within a Document, visible to all readers |
| Pending Change | A proposed edit submitted by a Commenter for review and approval by an Editor or Admin |
| Change Record | An immutable audit entry created each time a Document is saved or synced |
| Git Sync | Bidirectional synchronisation between a Space and a Git repository |
| Validator | A configurable rule that checks a Document before it can be saved |
| JIRA Badge | An inline widget rendered from a `[JIRA:KEY-123]` reference that shows live issue data |
| Semantic Search | AI-powered full-text search using vector embeddings for relevance-ranked results |

---

## 2. Actors

### 2.1 Human Actors

#### Admin

**ID**: `cpt-cyberwiki-actor-admin`

**Role**: Full platform administrator — manages users, spaces, Git sync configurations, validator rules, and integration credentials.

**Needs**: Ability to configure and control every aspect of the platform; visibility into sync health, pending changes, and access control.

#### Editor

**ID**: `cpt-cyberwiki-actor-editor`

**Role**: Creates, edits, and deletes documents within available git repositories; reviews and approves or rejects Pending Changes submitted by Commenters.

**Needs**: A fast, distraction-free editing experience with rich previews, inline validation feedback, and a clear review queue.

#### Commenter

**ID**: `cpt-cyberwiki-actor-commenter`

**Role**: Reads documents, leaves inline comments, and submits Pending Changes for review; does not have direct write access to apply edits.

**Needs**: Ability to annotate and propose changes without requiring a Git client or deep Git knowledge.

#### Viewer

**ID**: `cpt-cyberwiki-actor-viewer`

**Role**: Read-only access to assigned spaces and documents.

**Needs**: Fast, well-rendered document views with visible inline comments and JIRA context.


### 2.2 System Actors

#### Git Repository

**ID**: `cpt-cyberwiki-actor-git-repo`

**Role**: External source-of-truth for document content; the platform reads from and writes to repositories via a pluggable VCS backend. In v1 the supported VCS providers are GitHub and Bitbucket Server; the abstract provider interface allows additional providers to be added in future versions.

**Integration**: Bidirectional — platform reads content (Git → Wiki) and writes commits (Wiki → Git) via the VCS provider's API. Provider selection and base URL are configurable per user.

**Availability**: If the VCS provider is unreachable, the platform operates in read-only mode; sync operations are queued and retried when connectivity is restored.

#### JIRA Instance

**ID**: `cpt-cyberwiki-actor-jira`

**Role**: External issue tracker; provides live issue metadata (status, assignee, priority, summary) consumed by inline JIRA Badges.

**Integration**: Outbound — platform queries JIRA REST API for issue data; no inbound calls from JIRA to the platform in v1.

**Availability**: If JIRA is unreachable, inline badges degrade gracefully to display the raw `[JIRA:KEY-123]` reference; document editing is unaffected.

#### CI / Automation Pipeline

**ID**: `cpt-cyberwiki-actor-ci`

**Role**: Automated process that triggers document validation or Git sync as part of a broader build or release workflow.

**Integration**: Inbound — CI calls the platform to trigger validation or sync; no outbound calls from the platform to CI in v1.

**Availability**: CI integration is optional; absence of CI does not affect manual editing or sync workflows.

---

## 3. Operational Concept & Environment

### 3.1 Module-Specific Environment Constraints

Cyber Wiki is a self-hosted, single-team web application. It is accessed via a browser by all human actors. All document changes flow through Git — the platform never holds document state that is not committed or pending commit to a repository.

The platform provides seamless bidirectional navigation between Git raw documents and the Cyber Wiki viewer: users can click document links in their VCS provider (GitHub, Bitbucket) to open documents in Cyber Wiki with full context, and every document in Cyber Wiki provides a link back to the raw document in Git. This ensures users can move fluidly between the raw Git view (for code review, blame, history) and the Cyber Wiki view (for rich preview, comments, validation) without manual navigation overhead.

---

## 4. Competitors & Industry Analysis

### 4.1 VCS Integration Patterns

Modern documentation platforms implement VCS integration using two distinct architectural patterns: **Build-time Extraction** (static, exemplified by Docusaurus) and **Dynamic/API-driven Fetching** (real-time, exemplified by Fumadocs).

**Architectural Decision**: Cyber Wiki adopts the **Dynamic/API Integration pattern** as the primary VCS integration strategy. The system **MUST** implement VCS integration using the Dynamic/API pattern, fetching content, metadata, and repository information from VCS provider APIs at runtime rather than during build-time extraction.

**Rationale**: Real-time accuracy, decoupled updates, live collaboration features (inline comments, PR reviews), and metadata richness require dynamic API access. This enables the "Living Document" model where changes pushed to the VCS provider appear in the platform within seconds.

**For detailed analysis, options considered, and implementation notes, see**: [`ADR-001: VCS Integration Pattern`](./ADR/001-vcs-integration-pattern.md)

### 4.2 Comment System Architecture

Modern platforms use various comment system architectures: third-party services (Disqus), VCS-backed storage (Giscus, GitHub Discussions), and enterprise wikis (Confluence).

**Architectural Decision**: Cyber Wiki adopts a **database-native comment system** with Confluence-like inline comment UX and deep Git integration. Comments **MUST** be stored in the platform database with VCS metadata. Comments **cannot be stored on external servers**.

**Rationale**: Line-level anchoring, comments visible with ongoing PR changes, multi-VCS support, access control flexibility, and Confluence-like UX require database-native storage with full control over comment lifecycle and line-anchoring algorithms.

**For detailed analysis, options considered, and comparative table, see**: [`ADR-002: Comment System Architecture`](./ADR/002-comment-system-architecture.md)

---

## 5. Scope

### 5.1 In Scope

- Web-based browsing and editing of Git-backed documents (Markdown focus)
- VS Code extension providing IDE-native access to core platform features
- True WYSIWYG editing (titles, bold, underline, colors, tables render as formatted content while editing; no separate preview mode; underlying format is transparent to users)
- Inline commenting on documents
- Pending Changes workflow: propose → review → approve/reject (system detects conflicting edits and shows visual diff highlighting with word-level changes; users see exactly what changed and where conflicts exist)
- Immutable change history per document
- Bidirectional Git synchronisation with configurable direction and schedule (users never interact with Git commands directly; platform handles all commit/push/PR operations automatically; users simply save documents and platform manages Git workflow)
- Pluggable VCS backend: GitHub and Bitbucket Server supported in v1; abstract interface supports adding further providers (GitLab, Azure DevOps) without changing application logic
- Repository browsing, file tree navigation, and pull request listing via the VCS provider interface
- Dual-mode left navigation panel: Document View (Confluence-style titled hierarchy from a configurable Document Index) and File Tree View (raw directory structure); user-switchable per Space
- Configurable Document Index per Space: rules for which files are treated as documents, title extraction strategy (e.g., first Markdown heading, front-matter field, filename), and custom ordering/grouping
- Configurable document validators (link checking, schema validation, custom rules)
- JIRA integration: inline status badges, issue views (grid, chart, Gantt), and issue search within the app
- Full-text and semantic (AI-powered) search across all accessible documents
- Access control inherited from Git repository permissions
- Self-hosted, single-team deployment

### 5.2 Out of Scope

- Production deployment (staging only in v1)
- Mobile native applications
- Real-time collaborative editing (concurrent multi-user editing of the same document)
- Replacing a full-featured Git hosting platform (no code review, branch management, CI/CD)
- Multi-tenancy or SaaS delivery
- Native support for non-text file types (binary assets, large media)

---

## 6. Functional Requirements

### 6.1 Repository & Space Navigation

#### Browse Repositories and Spaces

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-browse-spaces`

The system **MUST** allow any authenticated actor to browse spaces and navigate to the documents within them from a unified entry point.

**Rationale**: Discoverability is the first step in the documentation workflow; without it, the platform cannot replace fragmented tooling.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Single-Repo Entry Page

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-single-repo-entry`

The system **MUST** support a configurable "entry page" mode where the platform opens directly on a specific repository or space, suitable for teams with a single primary repository.

**Rationale**: Teams that organise around one canonical repository benefit from a focused, direct landing experience rather than a multi-space directory.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`

#### Dual-Mode Left Navigation Panel

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-left-nav-dual-mode`

The system **MUST** provide a persistent left navigation panel within a Space that supports two distinct view modes, switchable by the user at any time:

1. **Document View** — presents Space contents as a titled document hierarchy, analogous to the Confluence left sidebar. Items are displayed using their human-readable document titles (not file paths), grouped and ordered according to the Space's Document Index configuration. The hierarchy supports multiple levels of nesting (sections, child pages). A page can be a parent/child of another page regardless of its position in the file tree.

2. **File Tree View** — presents Space contents as the raw directory and file structure from the Git repository, mirroring the on-disk layout. All files and folders are shown, using their actual filenames.

The user's last-selected mode **MUST** be persisted per Space so that returning to the Space restores the previous selection. Both modes **MUST** remain navigable and functional; switching modes **MUST NOT** navigate away from the currently open document.

**Rationale**: Non-engineers (PMs, designers, writers) expect a Confluence-style titled hierarchy for intuitive navigation; engineers expect the raw file tree for precise file location. Supporting both modes serves the full user population without forcing either group to compromise. Per-Space persistence avoids repetitive mode switching.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Configurable Document Index

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-document-index`

Each Space **MUST** support a configurable Document Index that defines how the Document View is constructed. The Document Index **MUST** be configurable by Admins (and optionally Editors) per Space and **MUST** support the following settings:

1. **Included file extensions** — a list of file extensions treated as Documents and shown in Document View (e.g., `.md`, `.mdx`, `.txt`, `.yaml`, `.rst`). Files with unlisted extensions are excluded from Document View but remain visible in File Tree View.

2. **Excluded paths** — glob patterns for files or directories to exclude from Document View entirely (e.g., `**/node_modules/**`, `**/.github/**`).

3. **Custom title/ordering mapping** — an optional explicit mapping that overrides the default ordering and nesting, specified as a structured index file (e.g., `_index.yaml`, `_sidebar.md`) committed to the repository. When present, this file defines the Document View hierarchy; entries not listed in the file are appended at the end under an "Other" group.

4. **Document ordering strategy** — when no explicit mapping is provided, documents are ordered by: (a) an explicit `order` front-matter field, then (b) document title alphabetically, then (c) filename alphabetically.

5. **Section headings** — support for virtual section headings in Document View that are not themselves navigable documents (display-only grouping labels), defined in the custom mapping file.

**Rationale**: Different teams organise their repositories differently (Cypress-style `docs/` folders, ADR directories, mixed code+docs repos). A configurable index allows each Space to surface only relevant documents in the correct order without requiring repository restructuring. Supporting an index file committed to the repository keeps the navigation structure version-controlled alongside the content.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Document Title Extraction Rules

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-title-extraction`

The system **MUST** support a per-Space configurable strategy for extracting a human-readable title for each Document shown in Document View. The following extraction strategies **MUST** be supported and **MUST** be selectable per Space (with a configurable priority order when multiple strategies apply):

1. **First Markdown heading** — extract the text of the first `#` heading in the file (e.g., `# Architecture Decision Record` → `Architecture Decision Record`). Applicable to `.md` and `.mdx` files.

2. **Front-matter field** — extract a named field from YAML front-matter at the top of the file (e.g., `title:` field). The field name is configurable (default: `title`). Applicable to any file format supporting YAML front-matter.

3. **First non-empty line** — use the first non-empty, non-comment line of the file as the title. Applicable to any text format as a fallback.

4. **Filename without extension** — use the filename without its extension, with underscores and hyphens replaced by spaces, and title-cased (e.g., `api-design-guide.md` → `Api Design Guide`). This is the default fallback when no other strategy yields a result.

When no strategy yields a non-empty result for a file, the system **MUST** fall back to the full relative file path as the display title.

The configured extraction strategy **MUST** apply consistently to all documents in the Space and **MUST** be re-evaluated whenever a document is saved or synced.

**Rationale**: Engineering repositories use a variety of conventions for document titles. A configurable extraction hierarchy lets each Space surface meaningful titles without requiring authors to follow a single format. Falling back gracefully to filename ensures no document is ever displayed with an empty or broken title. Re-evaluating on save/sync keeps the navigation panel current without manual refresh.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

### 6.2 IDE Integration

#### VS Code Extension

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-vscode-extension`

The system **MUST** provide a VS Code extension that enables users to access core Cyber Wiki features directly from their IDE without switching to a web browser. The extension **MUST** support at minimum:

1. **Document browsing** — view and navigate the Space/repository document hierarchy within VS Code's sidebar
2. **Document viewing** — open and view documents with rich preview rendering (Markdown, diagrams, JIRA badges)
3. **Document editing** — edit documents with inline validation feedback and save/commit workflow
4. **Inline comments** — view existing inline comments and create new comments on document line ranges
5. **Search** — search across documents using both full-text and semantic search
6. **Authentication** — authenticate with the Cyber Wiki backend using the same credentials as the web UI

The extension **MUST** communicate with the Cyber Wiki backend via the same REST API used by the web UI. The extension **MUST** respect the same access control and permissions as the web UI.

**Rationale**: Engineers spend most of their time in their IDE (VS Code, Windsurf, Cursor, etc.) and context-switching to a web browser disrupts flow. An IDE extension brings documentation workflows into the developer's primary workspace, reducing friction for the most active contributors. VS Code is chosen as the initial target due to its dominant market share and extension API compatibility with VS Code-based IDEs (Windsurf, Cursor).

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### API Access for AI Agents

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-api-agent-access`

The system **MUST** provide a REST API that enables AI agents (such as CyPilot) to programmatically access documentation content. The API **MUST** support at minimum:

1. **Document retrieval** — read document content by path or ID
2. **Document search** — perform full-text and semantic search across accessible documents
3. **Document metadata** — retrieve document metadata (title, last modified, author, change history)
4. **Space browsing** — list available spaces and navigate document hierarchies
5. **Authentication** — authenticate using API tokens or service account credentials
6. **Access control** — respect the same permission model as human users

The API **MUST** return structured responses (JSON) suitable for programmatic consumption. The API **MUST** support pagination for large result sets.

**Rationale**: AI agents like CyPilot need programmatic access to documentation to provide context-aware assistance, answer questions about documentation, and help users navigate and understand content. API access enables integration with AI workflows without requiring agents to scrape web pages or access Git repositories directly.

**Actors**: `cpt-cyberwiki-actor-ci`, AI agents (CyPilot)

### 6.3 Live Document Editing

#### WYSIWYG Editing with Optional Raw Mode

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-live-edit`

The system **MUST** allow Editors to edit document content directly in the browser using a WYSIWYG editor by default. The WYSIWYG editor **MUST** render formatting (headings, bold, underline, colors, tables, links) as formatted content while editing, with no separate preview mode. The underlying file format (Markdown, HTML, etc.) **MUST** be transparent to users in WYSIWYG mode.

The system **MUST** provide a toggle to switch between WYSIWYG mode and raw editing mode. In raw editing mode, users can view and edit the underlying Markdown/HTML source directly. Users **MUST** be able to switch between modes at any time without losing unsaved changes.

**Rationale**: WYSIWYG editing eliminates the need for non-technical users (PMs, designers) to learn Markdown syntax or understand file formats, reducing contribution friction to zero. Raw editing mode preserves the ability for developers and technical users to work directly with source when needed (e.g., for complex formatting, troubleshooting, or preference).

**Actors**: `cpt-cyberwiki-actor-editor`

#### Standard Formatting Controls and Rendering

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-standard-formatting`

The system **MUST** support standard text formatting in edit and view modes, including at minimum bold, italic, strikethrough, inline code, headings, lists, blockquotes, and links. Formatting **MUST** be preserved and rendered consistently between editor preview and read-only document view.

**Rationale**: Rich-but-standard formatting is required for readable technical documentation and parity with author expectations from modern knowledge tools.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-commenter`

#### Date Insertion via `//` Shortcut

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-date-shortcut`

The system **MUST** support date insertion when the user types the `//` keyboard shortcut in the editor. The UI **MUST** show a calendar picker with the current date highlighted, and the selected date **MUST** be inserted in `YYYY-MM-DD` format.

**Rationale**: Fast structured date insertion improves authoring speed and reduces formatting ambiguity.

**Actors**: `cpt-cyberwiki-actor-editor`

#### Date Badge Rendering in All Views

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-date-badge-rendering`

The system **MUST** render all valid `YYYY-MM-DD` date values as date badges (not plain text) in edit preview and read-only document view.

**Rationale**: Consistent badge rendering makes dates visually scannable and standardizes timeline-oriented documentation.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-commenter`

#### User Search and Tagging via `@` Shortcut

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-user-tag-search-shortcut`

The system **MUST** support automatic user search and tagging when an author types `@` in the editor, including suggestions/autocomplete sourced from accessible workspace members.

**Rationale**: Real-time search during tagging is a baseline collaboration requirement for fast, accurate mentions.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### Mention and Task Discovery from Synced Markdown

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-mention-task-sync-discovery`

The system **MUST** regularly scan synced Markdown files to discover newly added `@user` mentions and checklist tasks (`[ ]` / `[x]`) that were introduced outside the Cyber Wiki UI (for example, direct Git commits or pull requests).

**Rationale**: Discovery from Git-originated edits keeps mentions and tasks complete even when authoring bypasses the web editor.

**Actors**: `cpt-cyberwiki-actor-git-repo`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### Mention Entity Storage and Badge Rendering

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-mention-entity-badge-render`

Each detected or inserted user tag **MUST** be stored as a structured mention entity (not plain text only). Mentions **MUST** be rendered as user badges in document views, and the currently authenticated user's own badge **MUST** be visually highlighted.

**Rationale**: Structured mention entities and badge rendering enable reliable indexing, notifications, and rapid self-relevance scanning.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Mention Index for Tagged Users

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-mention-index`

The system **MUST** provide a view where a tagged user can see all places they were mentioned across documents, including at minimum document name, location/snippet, mention author, and mention time.

**Rationale**: A consolidated mention index prevents missed actions and removes the need to manually scan documents for `@` references.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Task Extraction from Checkbox Lines with Mentions and Dates

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-task-extraction-checkbox`

The system **MUST** treat Markdown checklist items such as `[ ] lorem ipsum` as tasks.

For any checklist line:
1. If one or more `@` mentions are present on the same line, the task **MUST** be assigned to the tagged user(s)
2. If a date badge/date value is present on the same line, that date **MUST** be treated as the task deadline
3. `[ ]` **MUST** represent an open task; `[x]` **MUST** represent a closed task

**Rationale**: Converting lightweight checklist syntax into structured tasks preserves authoring simplicity while enabling accountability and deadline-driven execution.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Task Dashboard by Assignee and Deadline

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-task-dashboard`

The system **MUST** provide a standalone task dashboard showing tasks assigned to users, with filters for open/closed status and assignee, and sorting by deadline (nearest first by default). Individual users **MUST** be able to view all tasks assigned to themselves, including both open and closed tasks.

**Rationale**: A dedicated task dashboard turns inline checklist syntax into an actionable work queue.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### User-Configurable Mention Notifications

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-mention-notification-preferences`

When Cyber Wiki discovers a user mention, the tagged user **MUST** receive a notification according to their personal notification preferences. Users **MUST** be able to configure whether to receive mention notifications via email, Microsoft Teams, and Slack.

**Rationale**: Per-user channel preferences reduce notification fatigue while preserving responsiveness to mentions.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Admin-Configurable Default Notification Channels

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-admin-default-notification-channels`

Admins **MUST** be able to configure default mention notification channels (email, Microsoft Teams, Slack) that apply to users until users explicitly override those defaults in personal settings.

**Rationale**: Central defaults provide a safe baseline communication policy while preserving user-level control.

**Actors**: `cpt-cyberwiki-actor-admin`

#### Document Change Notification Subscriptions

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-document-change-notifications`

Users **MUST** be able to subscribe to document change notifications at three levels: individual documents, folders, or entire Spaces. For each subscription, users **MUST** be able to configure:

1. **Notification channels** — choose which channels to receive notifications on (email, Microsoft Teams, Slack) per subscription
2. **Notification triggers** — select which events trigger notifications (document created, document updated, document deleted, comment added)
3. **Subscription management** — view all active subscriptions and unsubscribe at any time

The system **MUST** use an explicit opt-in model: users receive notifications only for documents/folders/Spaces they have explicitly subscribed to. The system **MUST NOT** send unsolicited notifications for documents the user has not subscribed to (except for direct mentions, which follow the mention notification preferences).

**Rationale**: An opt-in subscription model prevents notification flooding by giving users granular control over what they are notified about and how. Users can stay informed about critical documents without being overwhelmed by changes to documents they don't care about. Per-subscription channel configuration allows users to route high-priority notifications to immediate channels (Teams/Slack) and lower-priority ones to email.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Smart Editing: Newly Typed Text Highlighting

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-smart-edit-highlight-new-text`

The system **MUST** visually distinguish newly typed text during an editing session (for example, via subtle highlight background, underline, or change marker) so users can immediately identify fresh input before saving.

**Rationale**: Immediate visibility of freshly authored content helps users review and validate edits in long technical documents.

**Actors**: `cpt-cyberwiki-actor-editor`

#### Smart Editing: AI Refinement of Typed Text

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-smart-edit-ai-refine`

The system **MUST** allow users to refine selected or newly typed text with AI via a keyboard shortcut and/or by sending the text to an integrated chat assistant. Users **MUST** be able to preview and accept or reject the AI-proposed refinement before applying it.

**Rationale**: Inline AI refinement shortens the edit loop and improves clarity without forcing users to leave the document workflow.

**Actors**: `cpt-cyberwiki-actor-editor`

#### Inline Pending Changes Visibility

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-inline-pending-changes`

The system **MUST** display pending changes from open pull requests inline within the document view for all users, as if the changes were already committed, with the following capabilities:

1. **Visual Indication**: Pending changes **MUST** be highlighted with a distinct background color to clearly indicate they are not yet merged
2. **Change Metadata**: Each pending change snippet **MUST** display:
   - Author name
   - Last update timestamp
   - Quick link to the full pull request
   - Visual indicators similar to diff view (red/green sections for deletions/additions)
3. **Inline Comments**: Users **MUST** be able to comment directly on pending change snippets; comments **MUST** be linked to the pull request
4. **Snippet Approval**: Users **MUST** be able to mark individual change snippets as "reviewed" or "pre-approved" for visibility to other reviewers; approved snippets **MUST** have a visually distinct background color from unreviewed pending changes
5. **PR Navigation**: Users **MUST** be able to navigate from any pending change snippet directly to the full pull request view to see all changes, leave comprehensive comments, or formally approve the PR

**Rationale**: Inline visibility of pending changes eliminates context-switching between the document and the PR review interface, enabling reviewers to see proposed changes in the context of the full document rather than isolated diffs. Per-snippet approval tracking helps teams coordinate review effort on large PRs. This mirrors the "viewed file" checkbox pattern familiar from Git hosting platforms while providing richer in-context review capabilities.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Save to Fork and Commit to Main

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-save-commit`

The system **MUST** support a GitHub-style review workflow with a "Submit review" button pattern: (1) save the edit to a personal fork or branch, then (2) submit for review/merge to the main branch. The system **MUST** display changes with visual diff highlighting (background colors for additions and deletions, including word-level changes) before submission, making it clear what content was added, removed, or modified.

**Rationale**: The GitHub "Submit review" pattern is familiar to engineering teams and provides clear visual feedback on changes before they are committed. Visual diff highlighting (showing deleted words/lines and added content with distinct background colors) reduces errors by making changes immediately apparent, mirroring the Git diff experience while keeping Git as the source of truth.

**Actors**: `cpt-cyberwiki-actor-editor`

### 6.4 Contextual Inline Comments

#### Anchor Comments to Line Ranges

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-inline-comments`

The system **MUST** allow authenticated actors to leave inline comments anchored to a specific line range within a document.

**Rationale**: Context-specific comments are more actionable and easier to navigate than document-level notes; they enable non-Git users to participate meaningfully in review.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### Comments Survive Content Changes

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-comment-persistence`

The system **MUST** keep comments visible and relevant even after the lines they are anchored to have changed; when an anchor becomes outdated (including when the anchored text is modified or removed), the comment **MUST** be flagged as "outdated" rather than hidden. Comments anchored to completely removed text **MUST** remain visible with a clear indication that the original anchor no longer exists.

**Rationale**: Comments that silently disappear after a document edit cause reviewers to lose track of unresolved concerns; flagging preserves traceability without cluttering the view. When anchored text is removed, the comment still provides valuable context about what was discussed and why changes were made.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`

#### Threaded Comment Replies

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-comment-threads`

The system **MUST** support threaded replies to inline comments (one level of nesting) and allow Editors or Admins to resolve or delete comment threads.

**Rationale**: Threaded replies allow back-and-forth resolution of a concern without creating new top-level comments, keeping the review gutter readable.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-commenter`

#### Document-Level Comments

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-document-level-comments`

The system **MUST** support document-level comments that are anchored to the document as a whole rather than to specific line ranges. Document-level comments **MUST** be displayed in a dedicated section at the bottom of the document page (Confluence-style end-of-page comments). Document-level comments **MUST** support the same features as inline comments: threaded replies, resolve/delete actions, and author/timestamp metadata.

**Rationale**: Not all feedback is tied to specific lines — general observations, overall document quality feedback, high-level questions, and cross-cutting concerns are better expressed as document-level comments. Displaying these at the page bottom (Confluence pattern) keeps them separate from inline comments, reducing clutter in the line-anchored comment gutter while ensuring general feedback is not lost. This serves reviewers who want to provide holistic feedback without forcing them to pick an arbitrary line to anchor to.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Comment Storage

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-comment-storage`

The system **MUST** persist all inline comments in the platform database. This storage configuration applies to **all inline comments** in the platform, including:
- Comments on Cyber Wiki documents
- Comments on VCS provider files (source code, configuration files, etc.)
- Comments on pull request diffs (if in-platform PR review is implemented in phase 2)

Each comment **MUST** be stored with the following metadata to enable retrieval and line anchoring:
- VCS provider identifier (e.g., `bitbucket_server`, `github`)
- Project key / organization
- Repository slug / name
- Branch name
- File path
- Line range (start and end line numbers)
- Comment content and author
- Timestamp and status (open, resolved, deleted)

**Access Control**: All authenticated users can comment on any file they can view, regardless of Git repository write permissions. The platform manages comment access control independently through its own permission system.

**Rationale**: Database storage provides simple, centralized comment management without requiring Git write access for commenters. This enables the Commenter role to participate in reviews without needing repository write permissions, and avoids the complexity of syncing comments back to Git repositories.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

**Note**: The architectural decision for comment system architecture, including detailed analysis of alternative approaches (Disqus, Giscus, GitHub Discussions, Confluence) and comparative evaluation, is documented in [`ADR-002: Comment System Architecture`](./ADR/002-comment-system-architecture.md).

### 6.5 Change Review Workflow

#### Propose Pending Changes

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-pending-changes`

The system **MUST** allow Commenters (and above) to propose a change to a document as a Pending Change that enters a review cycle before being applied.

**Rationale**: Gives non-Editor roles a structured path to contribute content changes without direct write access, enabling broader participation without compromising quality gates.

**Actors**: `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-editor`

#### Approve and Reject Changes

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-change-approval`

The system **MUST** allow Editors and Admins to approve or reject Pending Changes; approving a change **MUST** apply the edit to the document and create a Change Record.

**Rationale**: Without a gatekeeping step, any Commenter could overwrite document content; the approval gate preserves editorial control.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`

#### Immutable Change History

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-change-history`

The system **MUST** maintain an immutable per-document change history that records author, timestamp, change type, summary, the content diff, change approvers, and the person who merged the change for every save.

**Rationale**: Auditability and the ability to understand why a document changed over time are fundamental to trust in a documentation platform. Recording change approvers and the person who merged it is critical to know who reviewed and authorized the change, especially for compliance and accountability purposes.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-viewer`

### 6.6 Rich Content Previews

#### Markdown Rendering

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-markdown-preview`

The system **MUST** render Markdown documents with full GFM (GitHub Flavored Markdown) support, including headings, lists, code blocks, tables, links, and images.

**Rationale**: Markdown is the primary content format; high-fidelity rendering is a baseline expectation for any documentation platform.

**Actors**: `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### Sequence and Mermaid Diagram Previews

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-diagram-preview`

The system **MUST** render Mermaid diagram fences (including sequence diagrams) as inline SVG within the document preview.

**Rationale**: Sequence and flow diagrams are essential to architectural documentation; requiring engineers to export diagrams separately introduces friction and stale images.

**Actors**: `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-editor`

#### draw.io Diagram Previews

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-drawio-preview`

The system **MUST** render draw.io diagram files linked or embedded within documents as interactive previews within the document viewer.

**Rationale**: draw.io is widely used for system and network diagrams in engineering teams; native rendering eliminates the round-trip to the draw.io application.

**Actors**: `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-editor`

#### Table Rendering

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-table-rendering`

The system **MUST** render Markdown tables as styled HTML tables with readable formatting in all document views. The system **SHOULD** support automated sorting and filtering capabilities for rendered tables to enable users to interact with tabular data without editing the source.

**Rationale**: Plain-text table syntax is unreadable at a glance; rendered tables are a basic quality-of-life requirement for structured documentation. Automated sorting and filtering enhance usability for large tables, allowing users to quickly find relevant data without manually reorganizing the table content.

**Actors**: `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-editor`

#### Extensible Visual Elements

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-custom-visuals`

The system **MUST** provide an extension point for rendering custom visual elements within documents beyond the built-in preview types. Additionally, the system **SHOULD** support the following Confluence-style rendering features:

1. **Checkbox rendering**: Interactive checkboxes within documents (similar to task lists in Confluence)
2. **Date rendering**: Formatted date display with calendar picker integration
3. **Current user highlight**: Automatic highlighting of content relevant to the currently logged-in user (e.g., mentions, assigned tasks)

**Rationale**: Teams have diverse visualisation needs (Gantt charts, topology maps, custom dashboards); a fixed set of renderers will eventually be insufficient. Confluence-style features like checkboxes, date rendering, and user highlighting are familiar to documentation teams and enhance interactivity and personalization without requiring custom extensions.

**Actors**: `cpt-cyberwiki-actor-admin`

### 6.7 Document Validation

#### Link Checker

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-link-checker`

The system **MUST** validate all internal links within a document (including links to other documents and Git repository paths) before the document can be saved; a document with broken internal links **MUST NOT** be saved until the links are resolved or explicitly overridden by the Editor.

**Rationale**: Broken links are the most common form of documentation rot; catching them at save time prevents accumulation of dead references.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-ci`

#### Schema Validation

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-schema-validation`

The system **MUST** support configurable schema validators (e.g., JSON Schema, RAML) that check the structure of documents or embedded data against a declared schema before saving.

**Rationale**: Structured documents (API specs, configuration manifests, data contracts) must conform to a schema to be consumable by downstream tooling; schema validation at the editor prevents non-conformant documents from entering the repository.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-ci`

#### Custom / Domain-Specific Validators

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-custom-validators`

The system **MUST** support pluggable custom validators (e.g., CTI-specific rules, GTS-specific rules) that can be configured per space and that block or warn on save when triggered.

**Rationale**: Domain-specific teams (e.g., Cyber Threat Intelligence) have validation requirements that no generic validator can address; a plugin interface future-proofs the platform for these use cases.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-ci`

### 6.8 Git Synchronisation

#### Bidirectional Sync

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-git-sync`

The system **MUST** support bidirectional synchronisation between a Space and a linked Git repository, with configurable sync direction (repository → wiki, wiki → repository, or both) and schedule. All sync operations **MUST** be performed through the pluggable VCS interface (`cpt-cyberwiki-fr-vcs-backend`) so that sync works consistently across all supported VCS providers.

**Rationale**: Git is the source of truth; the sync keeps the platform in alignment with changes made via other Git clients and ensures edits made in the wiki reach the repository. Routing sync through the VCS provider interface ensures it benefits from the same provider abstraction as browsing and PR listing.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-git-repo`, `cpt-cyberwiki-actor-ci`

#### Conflict Detection

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-conflict-detection`

The system **MUST** detect merge conflicts during sync and surface them to the change author for resolution; whoever is second must update their PR to resolve conflicts, following standard Git workflow. Conflicted PRs **MUST** be clearly indicated in the UI.

**Rationale**: Undetected conflicts silently overwrite content; surfacing them preserves data integrity. Conflict resolution is the author's responsibility, not the Admin's, matching standard Git practices where the second committer must rebase or merge and resolve conflicts before their changes can be merged.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

### 6.9 Search

#### Full-Text Search

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-fulltext-search`

The system **MUST** provide full-text search across all documents and spaces the requesting actor has access to. Search results **MUST** support:

1. **Exact keyword matching** — find documents containing the exact search terms
2. **File/folder filtering** — filter results by specific files, folders, or Spaces
3. **Tag filtering** — filter results by document tags (see `cpt-cyberwiki-fr-tag-search` for detailed tag search requirements)
4. **Result highlighting** — show document title, space name, highlighted excerpt with matched terms, and line number
5. **Search within results** — ability to determine if a specific term exists in a file/folder without ranking

**Rationale**: Basic full-text search is the foundation requirement for any knowledge platform; without reliable keyword search that works consistently, users cannot find documents they need. This must work first before adding advanced features. Simple "does this term exist in this folder" queries are often more useful than relevance-ranked results. Tag filtering enables topic-based discovery complementing keyword search.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Semantic (AI-Powered) Search

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-semantic-search`

The system **MAY** provide optional AI-powered semantic search using vector embeddings so that queries return conceptually relevant documents even when they do not share exact keywords with the query. Semantic search **MUST** be offered as an opt-in enhancement alongside full-text search, not as a replacement.

**Rationale**: Semantic search is useful for exploratory queries when exact keywords aren't known, but it should not replace basic keyword search. Sometimes users just want to know if a specific term exists in a file/folder without AI-powered relevance ranking. Semantic search is an enhancement, not a requirement for v1.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

### 6.10 JIRA Integration

#### Inline JIRA Issue Badges

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-jira-badge`

The system **MUST** render `[JIRA:KEY-123]` references in documents as inline status badges showing the issue key, summary, status, assignee, and priority; clicking the badge **MUST** open the JIRA issue in a new tab.

**Rationale**: Context-switching to JIRA to check a ticket's status is a constant interruption; inline badges eliminate the need to leave the document.

**Actors**: `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-jira`

#### JIRA Issue Views (Grid, Chart, Gantt)

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-jira-views`

The system **MUST** allow users to view JIRA issues associated with a space or document as a grid, a chart, or a Gantt diagram within the platform.

**Rationale**: Different actors need different perspectives on issue data: PMs need a timeline (Gantt), engineers need a flat list (grid), stakeholders need a summary (chart); providing all three removes the need to open JIRA for reporting.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-jira`

#### JIRA Issue Search

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-jira-search`

The system **MUST** allow users to search JIRA issues from within the platform without leaving the document context.

**Rationale**: Enables users to find and reference relevant JIRA tickets while authoring documents, reducing the need to switch applications.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

### 6.11 Access Control

#### User Authentication

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-authentication`

The system **MUST** authenticate all users before granting access to any space or document; the platform **MUST** support SSO/OIDC integration for user authentication. Username/password authentication is explicitly out of scope for v1.

**Rationale**: SSO/OIDC authentication eliminates credential storage risks and integrates with existing enterprise identity providers, providing a consistent security model across the platform.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

### 6.12 VCS Integration

#### VCS Provider Authentication

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-vcs-authentication`

The system **MUST** support SSO-based authentication for VCS providers without storing user credentials. For v1, the system **MUST** support:

1. **Bitbucket** - Authentication through ZTA (Zero Trust Access) tokens
2. **GitHub** - Standard OAuth app authentication through GitHub

Both authentication methods **MUST NOT** require credentials to be stored by the platform. The system **MUST** leverage provider-native authentication flows where users authenticate directly with the VCS provider.

**Rationale**: SSO-based authentication eliminates the security risk of storing credentials while providing seamless access to Git repositories. ZTA tokens for Bitbucket and OAuth for GitHub are standard enterprise authentication patterns that do not require credential storage.

**Note**: Credential storage for Confluence, JIRA, and other services may be addressed in future ADR/DESIGN documents if required.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Pluggable VCS Backend

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-vcs-backend`

The system **MUST** support GitHub and Bitbucket Server as VCS providers, and **MUST** implement provider integration through an abstract interface so that additional providers (GitLab, Azure DevOps) can be added without changing the consuming application logic. Each provider **MUST** be selectable per user with a configurable base URL to support self-hosted instances.

**Rationale**: Engineering teams run a variety of self-hosted or cloud VCS platforms; a pluggable interface prevents vendor lock-in and enables incremental provider coverage.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Seamless Git-to-Viewer Navigation

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-git-viewer-navigation`

The system **MUST** provide seamless bidirectional navigation between Git raw documents and the Cyber Wiki viewer:

1. **Git → Viewer** — clicking a document link in the VCS provider (GitHub, Bitbucket) **MUST** open the document in Cyber Wiki with full context (Space navigation, inline comments, JIRA badges, rich preview)
2. **Viewer → Git** — every document view in Cyber Wiki **MUST** provide a "View in Git" or "View raw" link that opens the raw document in the VCS provider at the current commit/branch
3. **Deep linking** — links **MUST** preserve context such as line numbers, commit SHA, and branch name when navigating between systems

The system **MUST** support this navigation through URL patterns or browser extensions that intercept VCS provider document URLs and redirect to Cyber Wiki.

**Rationale**: Users need to move fluidly between the raw Git view (for code review, blame, history) and the Cyber Wiki view (for rich preview, comments, validation). Forcing users to manually navigate between systems breaks their workflow. Seamless linking ensures users can click a GitHub/Bitbucket link and immediately see the document with full Cyber Wiki context, and vice versa.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### VCS Provider Interface Contract

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-vcs-interface`

The abstract VCS provider interface **MUST** define the following operations to support the requirements in section 5.11. Each VCS provider implementation (GitHub, Bitbucket Server) **MUST** implement these operations:

**Required Operations**:
1. `listRepositories(page, pageSize)` → Returns paginated list of repositories accessible to the authenticated user, including repository name, description, default branch, and last update timestamp
2. `getBranches(repoId)` → Returns list of branches for a repository, including branch name and whether it is the default branch
3. `getDirectoryContents(repoId, branch, path)` → Returns list of files and directories at the specified path, including name, type (file/directory), size, last modified date, and last author
4. `getFileContent(repoId, branch, path)` → Returns file content as text or binary, with detected MIME type
5. `listPullRequests(repoId, state, page, pageSize)` → Returns paginated list of pull requests filtered by state (open/merged/declined), including PR number, title, author, source/target branches, age, commit count, and LoC delta

**Optional Operations** (for phase 2 in-platform PR review):
6. `getPullRequestFiles(repoId, prId)` → Returns list of changed files in a PR with addition/deletion counts per file
7. `getPullRequestDiff(repoId, prId, filePath)` → Returns diff hunks for a specific file in a PR with line-level changes

**Optional Operations** (for Git blame feature):
8. `getBlame(repoId, branch, path)` → Returns per-line authorship information (author, commit SHA, date) for a file

**Interface Requirements**:
- Each operation **MUST** accept a configurable base URL for self-hosted instances
- Each operation **MUST** use the authenticated user's OAuth token or ZTA token for authorization
- Pagination **MUST** follow a consistent pattern (page number + page size or cursor-based)
- Error handling **MUST** distinguish between: authentication failures (401), authorization failures (403), not found (404), and provider errors (5xx)
- All operations **MUST** return structured data types (not raw API responses) to decouple consuming code from provider-specific formats

**Rationale**: A concrete interface contract ensures consistent behavior across VCS provider implementations and enables implementers to know exactly what operations to support. This contract supports all functional requirements in section 5.11 while allowing optional operations to be deferred to phase 2.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Repository Listing and Search

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-repo-listing`

The system **MUST** list all repositories accessible via the user's configured VCS token, with support for pagination and name/description search. The system **MUST** allow users to mark repositories as favourites (persisted per user) and track recently viewed repositories (last 10, auto-pruned), with favourites surfaced first in the listing.

**Rationale**: Teams with dozens or hundreds of repositories need fast discovery; favourites and recents reduce the time to reach frequently-accessed repos to zero.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Branch Browsing and File Tree Navigation

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-file-tree-navigation`

The system **MUST** display a repository's directory tree for any selectable branch, including last-modified date and last-author metadata per entry where available from the VCS provider. The system **MUST** support recursive directory drill-down and display files that exist only in open pull requests (phantom files) as a distinct visual type within the tree.

**Rationale**: Navigating a repository as a browsable file tree — rather than raw clone output — is the expected interaction model for non-Git-client users; last-author/date metadata provides provenance context without requiring a separate blame query.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### File Content Display with Syntax Highlighting

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-file-content-display`

The system **MUST** render the content of any text file from a Git repository with syntax highlighting appropriate to the file's detected language. The system **MUST** display line numbers and allow the user to select individual lines or line ranges as the basis for inline comments.

**Rationale**: Syntax-highlighted, line-numbered file viewing is the baseline expectation for any developer-facing tool; line selection is required for attaching contextual comments.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

#### Git Blame

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-git-blame`

The system **MUST** display per-line authorship (author name, commit SHA, commit date) for any file from a Git repository, sourced directly from the VCS provider's blame API.

**Rationale**: Blame information is essential for understanding who introduced a specific line of code or content and when, enabling faster triage and accountability without leaving the platform.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`

#### Pull Request Listing and External View

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-pr-listing`

The system **MUST** list pull requests for a repository (filterable by state: open / merged / declined, and by search query) and display each PR's metadata: title, author, source and target branches, age, commit count, lines-of-code delta, reviewer count, and comment count. The system **MUST** provide a "View on [VCS Provider]" link for each PR that opens the PR in the VCS provider's native interface.

**Rationale**: Viewing PRs in the native VCS provider interface leverages existing, mature PR review tools without requiring complex in-platform diff rendering. This reduces implementation complexity for v1 while still providing PR visibility and quick access.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### In-Platform Pull Request Diff Review

- [ ] `p3` - **ID**: `cpt-cyberwiki-fr-pr-diff-review`

**(Phase 2 / Future)** The system **MAY** allow users to open a PR within the platform, view its changed-files list (with addition/deletion counts per file), select a file to view its full diff with hunk-level navigation (previous/next chunk), and see deletion and addition lines distinguished by background colour with old and new line numbers.

**Rationale**: In-platform PR review would remove the need to switch to the Git host for reviewing proposed changes, but is deferred to phase 2 to reduce v1 complexity. The external view link provides sufficient functionality for v1.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

#### API Token Management

- [ ] `p2` - **ID**: `cpt-cyberwiki-fr-api-token-management`

The system **MUST** allow users to create, list, and delete named personal API tokens that can be used to authenticate programmatic access (CI, scripts) to the platform. API tokens **MUST** be distinct from the VCS provider OAuth/ZTA tokens.

**Token Format**:
- Tokens **MUST** be opaque random strings with minimum 128 bits of entropy (e.g., UUID v4 or cryptographically secure random bytes encoded as base64)
- Tokens **MUST** be prefixed with a version identifier (e.g., `cwt_v1_`) to enable format evolution

**Token Expiration**:
- Default lifetime **MUST** be 90 days
- Maximum lifetime **MUST** be 365 days
- Users **MAY** specify custom expiration at creation time within the maximum limit
- Expired tokens **MUST** be rejected immediately with a 401 Unauthorized response

**Token Scope**:
- For v1, tokens **MUST** grant full user-level access (same permissions as the creating user's interactive session)
- Scope model for future versions **MAY** include role-limited, repository-scoped, or granular read/write scopes
- Token scope **MUST** be stored with the token and enforced on every API request

**Token Revocation**:
- Revocation **MUST** take effect immediately (no grace period)
- Revoked tokens **MUST** be rejected with a 401 Unauthorized response
- Token validation **MUST** check revocation status on every request (no client-side caching of token validity)

**Audit Events**:
- The system **MUST** log the following events with timestamp, actor (user ID), and token ID:
  - Token creation (including token name and expiration)
  - Token usage (API endpoint accessed, success/failure)
  - Token revocation (including whether revoked by owner or admin)
- Audit logs **MUST** be retained for at least 90 days

**Rationale**: CI pipelines and scripts need a stable, revocable credential that does not expose the user's primary Git token; named tokens with individual revocation capability provide that without requiring service accounts. Explicit token format, expiration, scope, and auditing requirements enable implementers to design secure storage, validation, and enforcement mechanisms.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Comment Line-Anchoring Algorithm

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-comment-line-anchoring`

The system **MUST** implement a line-anchoring algorithm that tracks the current position of an inline comment as the file it is attached to evolves.

**Capture Phase** (at comment creation):
1. Normalize the commented line: trim leading/trailing whitespace, optionally normalize case (configurable)
2. Store the normalized line string as the primary identifier
3. Store the `original_line_number`
4. Capture N context lines before and after (default N=3), each normalized using the same rules

**Matching Phase** (on every file view):
1. **Exact line matching**: Search the entire current file for exact matches of the normalized commented line
   - If **single match** found:
     - At same line number → status = `anchored`, `computed_line_number` = `original_line_number`
     - At different line number → status = `moved`, `computed_line_number` = new line number
   - If **multiple matches** found:
     - Select the match nearest to `original_line_number` (minimum absolute distance)
     - If multiple matches are equidistant, use diff-based position tracer (optional) or select the first occurrence
     - Report status = `moved` if selected line differs from `original_line_number`, otherwise `anchored`
   - If **no exact match** found → proceed to step 2

2. **Context-window matching**: Attempt to locate the comment using surrounding context lines
   - For each position in the file, count how many of the K captured context lines (before + after) match at that position
   - If at least M of K context lines match (configurable majority rule, default M=ceil(K/2)):
     - Status = `outdated`, `computed_line_number` = best-match position
   - If no position meets the threshold → status = `deleted`, `computed_line_number` = null

**Status Definitions**:
- `anchored` — Exact normalized line found at the original position
- `moved` — Exact normalized line found at a different position
- `outdated` — Exact line not found, but context lines match (comment may be stale)
- `deleted` — Neither exact line nor sufficient context can be located

**Configuration Options**:
- Line normalization: whitespace handling (trim, collapse, ignore), case sensitivity
- Context window size N (default 3 lines before/after)
- Context match threshold M/K (default majority: ceil(K/2))
- Diff-based position tracer: optional fallback for disambiguation (conservative outdating)

**Rationale**: Comments that silently disappear after file edits destroy review continuity. A deterministic line-normalization + exact string matching algorithm with context-window fallback provides resilient anchoring that survives reformatting, line insertions, and moderate refactors without requiring a full diff-apply engine. Explicit normalization rules and matching steps enable consistent implementation across the platform.

**Actors**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

### 6.13 Document Metadata & Tagging

#### Unique Document Identifiers

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-document-unique-id`

The system **MUST** assign a unique, stable identifier to every document in the platform. Document IDs **MUST** meet the following requirements:

1. **Uniqueness** — IDs **MUST** be globally unique across all spaces and repositories
2. **Stability** — IDs **MUST** remain stable when documents are renamed, moved, or refactored within the repository
3. **Format** — IDs **MUST** be URL-safe strings (e.g., UUID v4, nanoid, or content-addressable hash)
4. **Persistence** — IDs **MUST** be stored in document metadata (front-matter or platform database) and preserved across Git operations
5. **Generation** — IDs **MUST** be automatically generated on first document indexing if not present
6. **Visibility** — IDs **MUST** be visible in document metadata view and copyable for linking purposes

**Rationale**: Stable document identifiers enable reliable cross-document linking that survives file renames and moves. Without stable IDs, links break when documents are reorganized, creating maintenance burden and broken references. Unique IDs are the foundation for cross-repository linking and reference tracking.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`

#### Auto-Generated Tags (Word Cloud)

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-auto-tags`

The system **MUST** automatically generate tags for each document based on the most common and significant words in the document content. Auto-generated tags **MUST** meet the following requirements:

1. **Extraction Algorithm** — Extract tags using TF-IDF (Term Frequency-Inverse Document Frequency) or similar statistical analysis to identify significant terms
2. **Stop Words Filtering** — Exclude common stop words (the, and, or, etc.) and programming language keywords from tag generation
3. **Tag Count** — Generate between 5-15 tags per document, prioritized by relevance score
4. **Tag Normalization** — Normalize tags to lowercase, remove special characters, and apply stemming/lemmatization
5. **Update Frequency** — Regenerate tags automatically when document content changes significantly (configurable threshold, e.g., >20% content change)
6. **Visibility** — Display auto-generated tags in document metadata view with visual distinction from custom tags (e.g., different color or icon)
7. **Non-Editable** — Auto-generated tags **MUST NOT** be directly editable by users; they are system-managed

**Rationale**: Auto-generated tags provide immediate discoverability for documents without requiring manual tagging effort. They enable content-based search and document clustering based on semantic similarity. Word cloud tags help users quickly understand document topics and find related content.

**Actors**: System-generated, visible to all actors

#### Custom User Tags

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-custom-tags`

The system **MUST** allow users with Editor or Admin roles to create, edit, and delete custom tags for any document. Custom tags **MUST** meet the following requirements:

1. **Tag Creation** — Users **MUST** be able to add custom tags through a tag input interface (autocomplete with existing tags)
2. **Tag Format** — Tags **MUST** be alphanumeric strings with optional hyphens/underscores, maximum 50 characters
3. **Tag Suggestions** — System **MUST** suggest existing tags as user types to encourage tag reuse and consistency
4. **Tag Management** — Users **MUST** be able to remove custom tags they added
5. **Tag Persistence** — Custom tags **MUST** be stored in the platform database and associated with document IDs
6. **Tag Visibility** — Custom tags **MUST** be visually distinct from auto-generated tags
7. **Tag Hierarchy** — System **MAY** support hierarchical tags (e.g., `category:subcategory`) for advanced organization
8. **Bulk Tagging** — System **MAY** support applying tags to multiple documents simultaneously

**Rationale**: Custom tags enable users to organize documents according to team-specific taxonomies, project phases, ownership, or any other classification scheme that auto-generated tags cannot capture. Manual tagging complements algorithmic tagging by adding human context and domain knowledge.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`

#### Cross-Repository Document Linking

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-cross-repo-linking`

The system **MUST** support linking between documents across different Git repositories and spaces using stable document identifiers. Cross-repository linking **MUST** meet the following requirements:

1. **Link Syntax** — Support a universal link syntax that references documents by their unique ID: `[[doc:DOCUMENT_ID]]` or `[[doc:DOCUMENT_ID|Display Text]]`
2. **Link Resolution** — Resolve document IDs to their current location across all accessible repositories and spaces
3. **Link Rendering** — Render links as clickable hyperlinks with document title as default display text
4. **Link Validation** — Validate links during document save and warn users about broken references (missing documents or inaccessible repositories)
5. **Link Preview** — Display document preview tooltip on hover showing document title, space, repository, and first few lines
6. **Backlinks** — Display a "Referenced By" section showing all documents that link to the current document
7. **Cross-System Links** — Support linking to external systems using URI schemes (e.g., `jira:KEY-123`, `github:org/repo#123`, `confluence:space/page`)
8. **Link Migration** — Provide tools to update links when documents are moved between repositories

**Rationale**: Cross-repository linking enables building a knowledge graph that spans multiple codebases and documentation repositories. Teams often split documentation across multiple repos (e.g., architecture docs in one repo, API specs in another, runbooks in a third), and need to reference documents across these boundaries. Stable IDs ensure links survive repository reorganizations.

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`

#### Tag-Based Search and Filtering

- [ ] `p1` - **ID**: `cpt-cyberwiki-fr-tag-search`

The system **MUST** support searching and filtering documents by tags (both auto-generated and custom). Tag-based search **MUST** meet the following requirements:

1. **Tag Search** — Users **MUST** be able to search for documents by entering tag names in the search interface
2. **Tag Filtering** — Search results **MUST** be filterable by one or more tags (AND/OR logic)
3. **Tag Cloud View** — System **MUST** provide a tag cloud visualization showing all tags with frequency/size indication
4. **Tag Navigation** — Clicking a tag **MUST** show all documents with that tag
5. **Combined Search** — Users **MUST** be able to combine tag filters with full-text search queries
6. **Tag Autocomplete** — Search interface **MUST** provide tag autocomplete suggestions
7. **Related Tags** — System **MAY** suggest related tags based on co-occurrence patterns

**Rationale**: Tags are only useful if they enable discovery. Tag-based search provides a complementary navigation path to full-text search, enabling users to browse documents by topic, category, or classification. Combined tag and text search enables precise filtering (e.g., "all architecture documents tagged 'security'").

**Actors**: `cpt-cyberwiki-actor-admin`, `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

---

## 7. Non-Functional Requirements

### 7.1 Module-Specific NFRs

#### Search Response Time

- [ ] `p1` - **ID**: `cpt-cyberwiki-nfr-search-latency`

The system **MUST** return search results (both full-text and semantic) in under 2 seconds for a corpus of up to 10,000 documents at p95.

**Threshold**: ≤ 2 000 ms at p95, corpus ≤ 10,000 documents

**Rationale**: Search latency above 2 seconds degrades the experience to the point where users abandon it and fall back to manual navigation.

#### Document Save Latency

- [ ] `p1` - **ID**: `cpt-cyberwiki-nfr-save-latency`

The system **MUST** complete a document save (validation + write) in under 3 seconds for documents up to 500 KB.

**Threshold**: ≤ 3 000 ms, document ≤ 500 KB

**Rationale**: A slow save loop breaks the editing flow and discourages frequent incremental saves.

#### Repository List and Search Performance

- [ ] `p1` - **ID**: `cpt-cyberwiki-nfr-repo-list-performance`

The system **MUST** display the repository list and return search results in under 1 second at p95 for users with access to up to 500 repositories. The system **MUST** implement repository list caching to avoid repeated API calls to the VCS provider on every page load.

**Threshold**: ≤ 1 000 ms at p95, ≤ 500 repositories per user

**Rationale**: Users frequently navigate between repositories and return to the repository list; without caching, every navigation would trigger a slow API call to the VCS provider, degrading the user experience. Caching enables instant repository list display and fast search filtering.

#### Availability

- [ ] `p2` - **ID**: `cpt-cyberwiki-nfr-availability`

The system **MUST** maintain 99% uptime during business hours in the staging environment.

**Threshold**: 99% uptime, business hours

**Rationale**: Even in staging, unplanned downtime blocks the team's documentation workflows.

#### Recovery Objectives

- [ ] `p2` - **ID**: `cpt-cyberwiki-nfr-recovery`

The system **MUST** tolerate loss of the application database without losing any committed document content, as Git is the recovery source of truth; the RPO for the comment and embedding store is ≤ 24 hours; the RTO is ≤ 4 hours.

**Threshold**: RPO ≤ 24 h, RTO ≤ 4 h (staging)

**Rationale**: Without defined recovery objectives, the DESIGN team has no basis for choosing backup strategies or defining acceptable data loss windows.

#### User Experience Goals

- [ ] `p2` - **ID**: `cpt-cyberwiki-nfr-ux`

The system **MUST** be operable by non-engineers (product managers, designers) without prior Git knowledge; the core workflows (read document, leave comment, propose change) **MUST** be completable without consulting documentation.

**Threshold**: Core workflows completable by a non-engineer in under 5 minutes without documentation

**Rationale**: An explicit UX goal for non-engineers is required because they are primary actors; without it, the DESIGN team has no basis for UI architecture decisions.

**Note**: WCAG 2.1 AA accessibility compliance is not required in v1 (internal tool, known engineering user base); deferred to production deployment.

#### Credential Security

- [ ] `p1` - **ID**: `cpt-cyberwiki-nfr-credential-security`

All user credentials stored by the platform — including Confluence tokens and JIRA tokens — **MUST** be encrypted at rest using symmetric encryption with a key that is never stored alongside the data. The plaintext of any credential **MUST NOT** be written to the database, application logs, or any audit record. The application **MUST** use a configurable encryption key (distinct from the application secret key) so that key rotation is possible without re-deploying the application.

**Note**: VCS provider access tokens (GitHub OAuth, Bitbucket ZTA) are not stored by the platform; they are obtained via the provider's OAuth/SSO flow and held only for the duration of the user session. This NFR applies to any service credentials (e.g., Confluence, JIRA) that require persistent storage.

**Threshold**: Zero stored credentials in plaintext; encryption key is externally configurable

**Rationale**: User credentials for external services are high-value secrets; accidental database exposure must not also expose Git or JIRA tokens. A configurable, separately managed key enables key rotation and meets baseline secret-management expectations for an internal engineering tool.

#### Theme and Personalisation

- [ ] `p2` - **ID**: `cpt-cyberwiki-nfr-theme`

The system **MUST** support light and dark display themes selectable per user. The selected theme **MUST** be persisted and applied consistently across all views without requiring a page reload.

**Threshold**: Light and dark themes available; preference persisted per user

**Rationale**: Dark mode is a standard expectation for developer-facing tools; per-user persistence avoids repeated reconfiguration.

### 7.2 NFR Exclusions

- **Multi-region availability**: Not applicable in v1 — single-node staging deployment only.
- **Horizontal scalability under high load**: Not applicable in v1 — single-team usage, no public traffic.
- **GDPR / regulatory compliance**: Not in scope for v1; to be addressed before any production or multi-tenant deployment.

---

## 8. Public Library Interfaces

### 8.1 Public API Surface

Not applicable — Cyber Wiki is an end-user web application, not a library. It does not expose a programmatic API surface for external consumers in v1.

### 8.2 External Integration Contracts

Cyber Wiki depends on the following external integration contracts:

- **VCS Provider**: Reads and writes document content over standard Git protocols (SSH/HTTPS). No custom API contract; standard Git wire protocol applies.
- **JIRA REST API**: Consumes JIRA issue data (status, assignee, priority, summary) via the JIRA Cloud/Server REST API; contract format TBD in DESIGN.
- **Embedding Service**: Sends document text and receives vector embeddings; contract format (input schema, vector dimensions, batch size) TBD in DESIGN.
- **Vector Database**: Stores and queries document embeddings for semantic search; query protocol and index format TBD in DESIGN.

---

## 9. Use Cases

### Edit and Commit a Document

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-edit-commit`

**Actor**: `cpt-cyberwiki-actor-editor`

**Preconditions**:
- Editor is authenticated and has Editor role in the target space
- The target document exists and is synced with Git

**Main Flow**:
1. Editor opens the document in the browser
2. Editor switches to edit mode; document opens in WYSIWYG editor by default (titles, bold, underline, colors, tables render as formatted content while editing; no separate preview mode)
3. Editor makes changes; validators run in the background and surface issues inline
4. Editor resolves any validation errors
5. Editor clicks "Save" button; system automatically handles Git commit/push operations without requiring Editor to interact with Git commands
6. System creates a Change Record and triggers a Git sync

**Postconditions**:
- Document content is updated in the Space and committed to the linked Git repository
- A Change Record is created with author, timestamp, and diff

**Alternative Flows**:
- **Raw editing mode**: Developer/technical user can toggle to raw editing mode to see and edit the underlying Markdown/HTML source directly; toggle back to WYSIWYG at any time
- **Validation failure**: System blocks save and highlights the failing validator; Editor must resolve before proceeding
- **Merge conflict**: System detects conflict during sync and notifies the Admin

---

### Authenticate and Configure Git Credentials

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-auth-configure`

**Actor**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-admin`

**Preconditions**:
- User has a valid account in the enterprise identity provider (SSO/OIDC)

**Main Flow**:
1. User navigates to the application
2. System redirects to SSO/OIDC identity provider for authentication
3. User authenticates with their enterprise credentials; identity provider redirects back with authentication token
4. System validates the token and creates an authenticated session
5. User navigates to the Profile settings page
6. User selects a VCS provider (GitHub or Bitbucket Server) and enters the provider base URL
7. User initiates OAuth flow for the selected VCS provider (GitHub OAuth or Bitbucket ZTA)
8. VCS provider authenticates the user and grants access; system receives access token via OAuth callback
9. System stores minimal session information; no credentials are stored

**Postconditions**:
- User session is active; all subsequent API calls are authenticated via SSO token
- VCS provider access is established via OAuth/ZTA without credential storage

**Alternative Flows**:
- **SSO authentication failure**: System returns to login page with error message; user must retry authentication
- **OAuth flow cancellation**: User cancels VCS provider OAuth; system notifies user that VCS access is not configured

---

### Browse Repository File Tree

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-browse-repo`

**Actor**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-viewer`, `cpt-cyberwiki-actor-commenter`

**Preconditions**:
- User is authenticated and has a valid Git token configured
- At least one repository is accessible via the configured VCS provider

**Main Flow**:
1. User opens the Repositories view; system lists all accessible repositories (via configured VCS token)
2. User can search repositories by name/description
3. User marks a repository as a favourite (persisted per user); favourited repos appear at the top
4. User opens a repository; system loads the default branch and displays the root directory tree
5. User selects a branch from the branch dropdown; file tree reloads for the selected branch
6. User navigates into subdirectories by clicking folder entries
7. User selects a file; system fetches and displays file content

**Postconditions**:
- Selected file content is displayed in the file viewer
- Repository is recorded in the user's recent-repos list (last 10 entries retained)

**Alternative Flows**:
- **No Git token configured**: System returns 401/422 with a message directing the user to configure credentials in Profile settings
- **Repository not found**: System surfaces a 404 error with the repository path
- **Provider rate limit**: System returns a 429 with a retry-after indication

---

### View File Content with Inline Comments

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-view-file-comments`

**Actor**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`, `cpt-cyberwiki-actor-viewer`

**Preconditions**:
- User is authenticated
- User has navigated to a file in the repository file tree

**Main Flow**:
1. System fetches file content from the VCS provider and renders it with syntax highlighting
2. User selects one or more lines in the rendered file; the "Add comment" action becomes available
3. User types a comment and submits; system captures the commented line content and 2–3 lines of surrounding context for future anchoring
4. System persists the comment with: line range, line content hash, context before/after, original line number, and anchoring status (`anchored`)
5. System re-renders the comment panel showing all comments for the current file/branch
6. On subsequent file views, system fetches current file content and runs the line-matching algorithm to compute current line positions for all comments:
   - If the exact line content is found → status remains `anchored`, `computed_line_number` updated
   - If the line has shifted position → status set to `moved`, new position reported
   - If the line content is no longer found but context matches → status set to `outdated`
   - If neither line nor context match → status set to `deleted`
7. User can edit or delete their own comments (ownership enforced); status can be toggled to `resolved`

**Postconditions**:
- Comment is persisted against the VCS provider + project + repo + branch + file path coordinates
- All future views of the same file show the comment at the dynamically computed current line position

**Alternative Flows**:
- **File content unavailable** (provider error): System falls back to displaying comments at their original line numbers without recomputing positions
- **Comment by non-owner**: System returns 403 on attempted edit or delete

---

### View Pull Requests and Navigate to VCS Provider

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-view-pr`

**Actor**: `cpt-cyberwiki-actor-editor`, `cpt-cyberwiki-actor-commenter`

**Preconditions**:
- User is authenticated and has a valid Git token configured
- The target repository has at least one pull request

**Main Flow**:
1. User opens a repository and switches to the "Pull Requests" tab
2. System fetches PRs from the VCS provider and displays them with: title, author, source → target branch, age, commit count, LoC delta, reviewer count, and comment count
3. User can filter PRs by search query, project, or repository; user can toggle between open/merged/declined states
4. User clicks "View on [VCS Provider]" link for a PR
5. System opens the PR in the VCS provider's native interface in a new tab

**Postconditions**:
- User is viewing the PR in the VCS provider's native review interface
- User can perform all PR review actions (comment, approve, merge) in the VCS provider

**Alternative Flows**:
- **PR not found**: System shows a 404 error with the PR identifier
- **No PRs available**: System shows an empty PR list with an informational message

**Note**: In-platform PR diff review with hunk-level navigation is deferred to phase 2 (see `cpt-cyberwiki-fr-pr-diff-review`). For v1, all PR review actions are performed in the VCS provider's native interface.

---

### Tag and Link Documents Across Repositories

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-tag-link-docs`

**Actor**: `cpt-cyberwiki-actor-editor`

**Preconditions**:
- Editor is authenticated and has Editor role
- Multiple documents exist across different repositories
- Documents have been indexed and assigned unique IDs

**Main Flow**:
1. Editor opens a document in Repository A (e.g., architecture decision record)
2. System displays the document with auto-generated tags based on content analysis (e.g., "architecture", "security", "authentication", "api")
3. Editor adds custom tags to categorize the document (e.g., "phase-1", "reviewed", "critical")
4. System provides tag autocomplete suggestions based on existing tags in the platform
5. Editor wants to reference a related document in Repository B (e.g., API specification)
6. Editor clicks "Insert Link" and searches for the target document by title or tags
7. System shows search results with document titles, repositories, and preview snippets
8. Editor selects the target document; system inserts link using document ID: `[[doc:abc-123-def|API Specification]]`
9. System validates the link and shows a preview tooltip with document metadata
10. Editor saves the document; system validates all links and warns about any broken references
11. System updates backlinks: the referenced document in Repository B now shows this document in its "Referenced By" section

**Postconditions**:
- Document has both auto-generated and custom tags visible in metadata view
- Cross-repository link is established using stable document ID
- Link survives if either document is renamed or moved within its repository
- Both documents show bidirectional reference relationship

**Alternative Flows**:
- **Tag already exists**: System suggests existing tag with same name to maintain consistency
- **Broken link**: If referenced document is deleted or becomes inaccessible, system marks link as broken with visual indicator
- **Link to external system**: Editor can also insert links to JIRA (`jira:KEY-123`), GitHub issues (`github:org/repo#123`), or other systems using URI schemes

---

### Discover Documents by Tags

- [ ] `p1` - **ID**: `cpt-cyberwiki-usecase-discover-by-tags`

**Actor**: `cpt-cyberwiki-actor-viewer`

**Preconditions**:
- User is authenticated
- Multiple documents exist with various tags (auto-generated and custom)

**Main Flow**:
1. User opens the search interface
2. User clicks on the "Tag Cloud" view to see all available tags with frequency indicators
3. User clicks on a tag (e.g., "security") to see all documents with that tag
4. System displays filtered results showing documents from all accessible repositories
5. User adds additional tag filters (e.g., "security" AND "api") to narrow results
6. System applies AND logic and shows only documents matching all selected tags
7. User combines tag filter with text search (e.g., tag:"security" + text:"authentication")
8. System returns documents that match both tag and text criteria
9. User clicks on a document to view it; document shows all its tags (auto-generated in one color, custom in another)
10. User clicks on another tag in the document view to find related documents

**Postconditions**:
- User has discovered relevant documents using tag-based navigation
- User understands document topics through visible tags
- User can navigate between related documents using tag links

**Alternative Flows**:
- **No results**: System shows "No documents found with selected tags" message with suggestions for related tags
- **Tag suggestions**: System suggests related tags based on co-occurrence patterns (e.g., documents tagged "security" are often also tagged "compliance")

---

## 10. Acceptance Criteria

- [ ] An Editor can open, edit, and commit a Markdown document entirely from the browser without a local Git client
- [ ] The left navigation panel displays in Document View by default, showing document titles derived by the configured title extraction strategy (not raw filenames)
- [ ] A user can switch the left navigation panel from Document View to File Tree View and back using a visible toggle; the switch is instant and does not navigate away from the currently open document
- [ ] The selected navigation mode (Document View or File Tree View) is persisted per Space; returning to the Space after navigating away restores the last-selected mode
- [ ] In Document View, documents are listed using their extracted titles and respect any custom ordering defined in the Space's index file (e.g., `_index.yaml`); documents not listed in the index file are appended at the end
- [ ] In Document View, virtual section headings (defined in the index file) are displayed as non-navigable grouping labels above their child documents
- [ ] An Admin can configure per Space: the list of file extensions treated as documents, the excluded path patterns, and the title extraction strategy
- [ ] When a document's title extraction strategy is set to "first Markdown heading", the panel shows the text of the first `#` heading; when the heading is absent, the system falls back to the filename without extension
- [ ] When a title extraction strategy is set to "front-matter field", the panel shows the value of the configured YAML field; when the field is absent, the system falls back to the filename without extension
- [ ] Documents with extensions not in the configured inclusion list do not appear in Document View but remain visible in File Tree View
- [ ] After a document is saved or synced, the Document View title and position in the left panel are updated without requiring a full page reload
- [ ] An Editor can apply standard formatting (bold, italic, strikethrough, links, lists) and see identical rendering in edit preview and read-only view
- [ ] Typing `//` opens a date picker with current day highlighted and inserts selected dates in `YYYY-MM-DD` format
- [ ] All `YYYY-MM-DD` date values are rendered as date badges in edit preview and read-only view
- [ ] Typing `@` triggers user autocomplete/search; mentions are saved as structured entities and rendered as badges with current user highlight
- [ ] The platform discovers `@user` mentions and Markdown checklist tasks from synced Git changes, including edits made outside the Cyber Wiki UI
- [ ] Checklist lines (`[ ]`) are treated as tasks; same-line `@` mentions become assignees, same-line dates become deadlines, and `[x]` marks tasks as closed
- [ ] A standalone task dashboard shows assigned tasks with open/closed filtering and deadline ordering
- [ ] Tagged users can see all mention locations and receive mention notifications by configured channels (email, Teams, Slack)
- [ ] Admins can define default mention notification channels (email, Teams, Slack) used until overridden by users
- [ ] Newly typed text is visually highlighted during an edit session, and the Editor can invoke AI refinement (shortcut or chat) with accept/reject control
- [ ] A document with a broken internal link cannot be saved until the link is resolved or the check is explicitly overridden
- [ ] Mermaid and draw.io diagrams render inline in the document viewer
- [ ] Semantic search returns relevant results for a natural-language query across a corpus of at least 1,000 documents
- [ ] `[JIRA:KEY-123]` references render as inline badges showing live status, assignee, and priority
- [ ] A Viewer cannot edit or propose changes to a document (access is denied)
- [ ] All document saves are reflected as commits in the linked Git repository within the configured sync interval
- [ ] A user can authenticate via SSO/OIDC; an active session is established and persisted across page reloads
- [ ] A user can configure a VCS provider (GitHub or Bitbucket Server) and initiate OAuth authentication flow; access is granted without storing credentials
- [ ] A user can create, list, and revoke named API tokens for programmatic access to the platform API
- [ ] The Repositories view lists all repositories accessible via the user's Git token; the list is searchable by name/description
- [ ] A user can mark any repository as a favourite; favourites appear at the top of the listing and persist across sessions
- [ ] The system records the last 10 repositories opened by each user; this recent list is visible in the Repositories view
- [ ] Opening a repository displays the default branch and root directory tree; the user can select any branch from a dropdown to reload the tree
- [ ] A user can navigate into subdirectories by clicking folder entries; file entries added only in open pull requests are visually distinguished from committed files
- [ ] Each file entry in the directory tree displays the last-modified date and last-author name where available from the VCS provider
- [ ] Opening a file displays its content with syntax highlighting appropriate to the detected language and line numbers on every line
- [ ] A user can view per-line authorship (author, commit SHA, date) for any file via a blame view
- [ ] A user can select a line range in a file view and submit an inline comment; the comment appears anchored to that line range
- [ ] After the commented file is modified, reopening the file re-computes the comment's current line position; the comment is marked `anchored`, `moved`, `outdated`, or `deleted` accordingly
- [ ] A user can edit or delete only their own comments; attempting to modify another user's comment is rejected with a 403 error
- [ ] Comment counts per file are displayed as badges in the directory tree listing
- [ ] The Pull Requests tab lists open PRs for a repository with title, author, source→target branch, age, commit count, LoC delta, reviewer count, and comment count; the list is filterable by state (open / merged / declined) and searchable
- [ ] Selecting a PR shows the list of changed files with per-file addition and deletion counts
- [ ] Selecting a changed file in a PR renders its diff with old and new line numbers, context lines, deletion lines highlighted red, and addition lines highlighted green
- [ ] The user can navigate between change hunks in a diff using previous/next chunk controls
- [ ] A user can select a line in a PR diff and add an inline comment; the comment is persisted with the same line-anchoring metadata as file-view comments
- [ ] A user can switch between GitHub and Bitbucket Server as their Git provider in Profile settings; all repository browsing, file tree navigation, and PR listing features work correctly for the selected provider without any code changes to the application logic
- [ ] A user can configure a custom base URL for the selected Git provider to support self-hosted instances (e.g., an on-premises Bitbucket Server)

---

## 11. Dependencies

| Dependency | Description | Criticality |
|------------|-------------|-------------|
| Git Provider | Pluggable backend; v1 supports GitHub and Bitbucket Server; abstract interface allows further providers | p1 |
| JIRA Instance | Provides issue metadata for inline badges and search | p2 |
| Vector Database | Stores document embeddings for semantic search | p1 |
| Embedding Service | Generates vector embeddings from document content | p1 |

---

## 12. Assumptions

- Teams operate a single self-hosted instance per team; multi-tenancy is not required in v1.
- The primary document format is Markdown; support for other formats is not in scope for v1.
- Git is always available as the underlying storage; the platform does not operate in an offline-first mode.
- v1 supports exactly two Git providers: GitHub and Bitbucket Server. The pluggable provider interface allows additional providers (GitLab, Azure DevOps, etc.) to be added in future versions without changing application logic.
- JIRA integration is optional; teams without JIRA can use the platform without configuring it.
- The embedding/vector search service is available as an external dependency; the platform integrates with it rather than hosting its own model.
- Staging deployment is the only target environment for v1; production hardening is deferred.
- Expected team size: ≤ 50 registered users; ≤ 10 concurrent active editors; ≤ 30 concurrent viewers.
- Expected document corpus: up to 10,000 documents across all spaces in v1.
- Change Records and inline comments are retained for the lifetime of the Space; deleting a Space permanently removes all associated documents, comments, and change records.
- Individual comment deletion by end-users is not required in v1; Admin-only moderation is sufficient.

---

## 13. Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Git sync conflicts corrupt document content | HIGH — data loss or silent overwrites | Implement conflict detection with Admin notification before applying any conflicting change |
| Semantic search quality is insufficient for domain-specific jargon | MEDIUM — users abandon search and fall back to manual browsing | Allow teams to tune embedding models or supplement with keyword search as a fallback |
| Validator false positives block legitimate saves | MEDIUM — Editor frustration, validation bypassed | All validators must support an explicit override with a reason logged to the Change Record |
| draw.io rendering adds significant bundle size or latency | LOW — slower page loads | Lazy-load the draw.io renderer only when a draw.io file is detected on the page |
| Git provider API differences break the abstract interface contract | MEDIUM — a new provider behaves differently from the interface specification, causing silent failures or missing operations | Define the interface contract with explicit error semantics; validate each provider implementation against a shared test suite before release |

---

## 14. Open Questions

| Question | Owner | Target Resolution |
|----------|-------|-------------------|
| Which embedding model and service will be used for semantic search? | TBD | Before DESIGN |
| Which JIRA API version (Cloud vs Server/Data Center) must be supported? | TBD | Before DESIGN |
| Should draw.io rendering be client-side (draw.io JS SDK) or server-side? | TBD | Before DESIGN |
| Should Git sync support webhook-triggered pushes in addition to polling? | TBD | Before DESIGN |
| What is the expected maximum document corpus size beyond the 10,000 target? | TBD | Before M1 |
| Should comment re-anchoring run on every file view, on a push webhook from the Git provider, or on a scheduled background job? | TBD | Before DESIGN |
| Should users be able to see comments on repository files if they don't have access to view the repository itself? If yes, what information should be visible (comment content, file path, repository name)? | TBD | Before DESIGN |
| Which Git providers beyond GitHub and Bitbucket Server are required for v1? | TBD | Before DESIGN |
| For Bitbucket Server: should ZTA token refresh be fully automated (background renewal) or require a manual re-authenticate action in the UI? | TBD | Before DESIGN |

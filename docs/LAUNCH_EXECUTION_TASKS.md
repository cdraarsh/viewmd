# ViewMD Launch Execution Tasks

Source: `docs/BROAD_AWARENESS_LAUNCH.md`  
Created: 2026-06-06  
Updated: 2026-06-14  
Launch direction: unsigned GitHub Releases public beta first, supported by GitHub Pages and technical-audience seeding.

## Phase 0: Source Material

- [x] Confirm launch positioning: "Your AI gives you Markdown. ViewMD makes it readable."
- [x] Confirm first audience: AI power users on Mac.
- [x] Confirm first distribution surface: GitHub Releases.
- [x] Source 3 AI-generated Markdown documents that make the app feel obviously useful.

## Phase 1: Public Story

- [x] Create a public README that leads with the AI-output workflow, not generic Markdown tooling.
- [x] Create a lightweight product page with hero, workflow, privacy, limitations, and download CTA.
- [x] Create release-note draft copy for the first public GitHub Release.
- [x] Add feedback-beta CTA and generated product preview to the product page.
- [x] Add launch copy variants for X/Twitter, LinkedIn, Show HN, Reddit/forums, direct outreach, and Product Hunt follow-up.
- [x] Update launch copy for public beta and broad awareness.
- [ ] Add 2 to 3 product screenshots to the README, product page, and release notes.
- [ ] Replace placeholder release links after the unsigned public beta build is uploaded.

## Phase 2: Release Trust

- [x] Produce a local macOS app bundle for install-flow testing.
- [x] Add repeatable universal macOS release build script.
- [x] Add explicit unsigned public beta release mode.
- [ ] Produce a Developer ID signed universal macOS app build after paid Apple Developer Program access is available.
- [x] Decide whether first public build must be notarized before launch: no, if limited to technical public beta with clear unsigned disclosure.
- [x] Package the app as a `.zip` suitable for non-technical users.
- [ ] Verify unsigned install flow, checksum verification, and Apple's per-app Open Anyway flow on a clean Mac user account.
- [x] Generate SHA-256 checksum during release packaging.
- [x] Confirm README and release notes explain that files stay local.
- [x] Remove remote font loading from the app render template so local/offline copy remains accurate.
- [x] Confirm known limitations are visible before download.
- [x] Add GitHub issue forms for beta feedback and bug reports.
- [x] Add app Help menu links for beta feedback and bug reports.
- [x] Add GitHub Actions workflow for unsigned beta and future signed/notarized release assets.
- [x] Add GitHub Pages workflow for the static landing page.

## Phase 3: Demo Assets

- [ ] Open each launch example in ViewMD and verify it renders cleanly.
- [ ] Export each launch example to PDF.
- [ ] Capture 3 annotated screenshots:
  - Opened AI-generated report in ViewMD.
  - Polished PDF-style reading view with tables or code blocks.
  - Exported PDF beside the source `.md` file.
- [ ] Record a 20 to 40 second demo: open `.md` -> read in ViewMD -> export PDF.
- [ ] Optimize GIF/video size for GitHub release page readability.

## Phase 4: Manual Audience Seeding

- [x] Draft X/Twitter launch post focused on before/after AI document output.
- [x] Draft Show HN title and body.
- [x] Draft one Reddit/forum post for an AI power-user community.
- [x] Draft r/MacApps, AI subreddit, AlternativeTo, and MacUpdate copy.
- [x] Mark Product Hunt, AlternativeTo, and MacUpdate as deferred until a notarized build exists.
- [x] Draft reusable channel copy in `docs/LAUNCH_COPY.md`.
- [ ] Build direct outreach list of 10 people who regularly share AI-generated reports, plans, or docs.
- [ ] Ask first 3 outside users whether they understood the product within 10 seconds.

## Phase 5: First-Contact Learning

- [ ] Track whether visitors understand the product before download.
- [ ] Track whether GitHub Releases creates enough trust to download.
- [ ] Track whether users open one of their own AI-generated Markdown files.
- [ ] Track whether users export and share a PDF.
- [ ] Update positioning if feedback describes ViewMD as only "a Markdown viewer."
- [x] Add feedback tracking playbook in `docs/FEEDBACK_PLAYBOOK.md`.

## Current Local Work Completed

- [x] Added launch execution task list.
- [x] Added GitHub-first README.
- [x] Added first-release notes draft.
- [x] Added launch example candidate notes.
- [x] Added 3 public-safe AI-generated launch example files.
- [x] Added static GitHub Pages-ready landing page.
- [x] Removed remote font loading from rendered document HTML.
- [x] Built local app bundle at `ViewMD/build/ViewMD.app`.
- [x] Added feedback-beta GTM runbook.
- [x] Added GitHub issue forms for feedback and bugs.
- [x] Added in-app Help menu feedback links.
- [x] Added generated product preview asset for launch surfaces.
- [x] Added broad awareness launch runbook.
- [x] Added universal release packaging automation.
- [x] Added unsigned public beta packaging automation.

## Current Blockers

- No git remote is configured in this checkout, so the GitHub Release and Pages deploy cannot be published locally yet.
- This Mac has an Apple Development certificate, but no Developer ID Application certificate, so local signing and notarization cannot complete yet.
- Product Hunt, AlternativeTo, MacUpdate, Setapp, and Mac App Store submissions should wait until a Developer ID signed and notarized release exists.
- Social posting can proceed for technical audiences after the unsigned release asset, checksum, and install disclosure are live.

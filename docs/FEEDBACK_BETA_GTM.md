# ViewMD Feedback-Beta Retail GTM

Status: superseded by `docs/BROAD_AWARENESS_LAUNCH.md`
Audience: AI power users on Mac
Primary surface: GitHub Releases
Primary goal: real usage feedback, not broad awareness

## Positioning

**Your AI gives you Markdown. ViewMD makes it readable.**

ViewMD should launch as a small, local-first Mac utility for people who receive `.md` files from ChatGPT, Claude, Cursor, Codex, and other AI workflows. Do not lead with "Markdown viewer." Lead with the complete workflow: open the AI-generated file, read it like a normal document, export a PDF beside the source.

## Retail Surfaces

| Surface | Purpose | Status |
|---|---|---|
| GitHub Releases | Primary download and trust surface | Release copy in `docs/RELEASE_NOTES_v1.0.0.md` |
| README | Cold repo visitor explanation | Live in `README.md` |
| Product page | Simple public storefront | Live in `docs/index.html` |
| Issue form: feedback | Non-code feedback capture | Live in `.github/ISSUE_TEMPLATE/feedback.yml` |
| Issue form: bugs | Reproducible defect capture | Live in `.github/ISSUE_TEMPLATE/bug_report.yml` |
| App Help menu | In-product feedback entry | Live in `ViewMDApp.swift` |
| Launch examples | Screenshot and PDF source material | Live in `docs/launch-examples/` |
| Launch copy | Channel-specific posts and DMs | Live in `docs/LAUNCH_COPY.md` |
| Feedback playbook | First-user tracking and interview prompts | Live in `docs/FEEDBACK_PLAYBOOK.md` |

## Launch Sequence

1. **Package trust first**
   - Produce a universal macOS app build.
   - Sign and notarize before sending to strangers.
   - Zip the app and generate a SHA-256 checksum.
   - Create the GitHub Release as a draft, attach all assets, then publish.

2. **Run a 10-20 person public beta feedback loop**
   - Target people who already receive AI-generated Markdown.
   - Ask each person to try one real file and export one PDF.
   - Track where they stop: install, open file, view document, export PDF, or share.

3. **Publish the public beta**
   - Update the product page and README release links.
   - Post to X/Twitter, LinkedIn, one AI-heavy community, and direct outreach.
   - Use Show HN only when install trust is solved and the release has screenshots.

4. **Decide the next surface**
   - Product Hunt only after a Developer ID signed and notarized build exists.
   - MacUpdate and AlternativeTo after notarized packaging, screenshots, and versioning are stable.
   - Mac App Store only if users ask for easier install/update trust.

## Feedback Metrics

| Signal | Target for first beta |
|---|---|
| Real installs | 5 or more |
| Own-file opens | 3 or more |
| PDF exports | 1 or more |
| Install blockers | 0 unresolved critical blockers |
| Positioning comprehension | 3 outside users understand it within 10 seconds |

## Launch Decision Rules

- If users hesitate before downloading, improve signing, notarization, release copy, and screenshots.
- If users download but do not open their own files, improve onboarding and default file association instructions.
- If users open files but do not export PDFs, reduce emphasis on PDF or make export more obvious.
- If users call it only "a Markdown viewer," sharpen copy around AI-output handoff and local PDF sharing.

## Manual Work Remaining

- Capture 3 product screenshots from the launch examples.
- Record a 20-40 second demo: open `.md` -> read -> export PDF.
- Replace placeholder release links after the first public artifact is uploaded.
- Run a clean install test with no terminal steps.
- Ask 3 outside users the 10-second comprehension question.

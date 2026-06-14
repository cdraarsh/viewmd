# 30-Day Launch Plan for a Small Mac Utility

Generated example for ViewMD launch screenshots.

## Goal

Ship a focused public launch for a Mac utility without waiting for the Mac App Store. The launch should make one thing clear: who the app is for, what problem it solves, and how someone can try it today.

## Launch Strategy

Use a GitHub Releases-first launch supported by a lightweight product page. The release page is the download surface. The homepage explains the promise and sends users to the release.

## Timeline

| Week | Focus | Output |
|---|---|---|
| Week 1 | Message and proof | README, landing page, release copy, screenshots |
| Week 2 | Packaging | Signed app, install test, checksum, release draft |
| Week 3 | Demo | 30-second video, annotated screenshots, example files |
| Week 4 | Distribution | X post, Show HN draft, direct outreach, feedback log |

## Phase 1: Make the Story Obvious

- Lead with the workflow, not the implementation.
- Show one before/after example above the fold.
- Explain privacy in plain English.
- List known limitations before download.

## Phase 2: Reduce Download Anxiety

- [ ] Use a signed app artifact.
- [ ] State notarization status clearly.
- [ ] Include install steps with no terminal commands.
- [ ] Add screenshots directly to the release page.
- [ ] Publish a SHA-256 checksum.

## Phase 3: Seed the First Audience

Start with people already feeling the pain:

1. AI power users who export plans and reports.
2. Solo builders who use coding agents.
3. Consultants who turn AI drafts into client-facing documents.
4. Researchers who save long AI outputs as Markdown.

## Launch Copy

> If your AI hands you `.md`, this makes it presentable in one step.

Avoid calling it "just a Markdown viewer." The launch should frame the app as a bridge between AI output and normal Mac documents.

## Success Metrics

- A cold visitor understands the product in under 10 seconds.
- Three outside users open their own Markdown files.
- One user exports a PDF and shares it.
- Feedback mentions the workflow benefit, not only rendering quality.

## Risks

- Users may not trust a GitHub download without signing or notarization clarity.
- The message may be too narrow if examples are weak.
- A generic landing page could make the product feel less useful than it is.

## Decision

Launch only after the examples make the product feel obvious.


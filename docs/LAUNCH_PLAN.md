# Design: ViewMD Public Launch Plan

Generated during /office-hours on 2026-06-06
Branch: main
Repo: viewmd
Status: SUPERSEDED by `docs/BROAD_AWARENESS_LAUNCH.md`
Mode: Builder
Supersedes: aarsh-main-design-20260605-134206.md

## Problem Statement

ViewMD already has a clear product wedge: it turns AI-generated Markdown into a
normal Mac document workflow. The launch problem is different. Right now the
product exists, but the public entry point does not. People need to understand
what ViewMD is, why it exists, and how to try it without being told in a DM.

## What Makes This Cool

The strongest story is still the workflow:

1. Your AI gives you Markdown.
2. ViewMD makes it readable.
3. You export a polished PDF beside the source file.

The "whoa" is not "another Markdown viewer." The "whoa" is that AI output
stops feeling like an awkward intermediate file and starts feeling like a
finished document.

## Constraints

- Keep the audience narrow at launch: AI power users on Mac.
- Do not lead with generic developer-tool language.
- Do not make the first launch depend on Mac App Store review.
- The launch surface should be lightweight enough to ship soon.
- GitHub must be a product surface, not just a code host.
- The repo and release page need to build trust for people who discover the app
  cold.

## Premises

1. The first public audience is people already generating `.md` files from AI
   tools and agents.
2. The core message is the AI-output workflow, not Markdown rendering in the
   abstract.
3. The first launch should optimize for clear message and low-friction trial,
   not maximum distribution breadth.
4. GitHub Releases should be the first distribution channel because it is fast,
   legible, and good enough for the first wave of users.
5. A simple product page is still useful, but it should support the GitHub
   release, not replace it with a vague waitlist.

## Approaches Considered

### Approach A: Website-First Waitlist

Summary: Launch with a landing page, screenshots, and email capture before
shipping a public downloadable build.

- Effort: S
- Risk: Medium
- Pros:
  - Fastest way to test messaging.
  - Useful if the build is not ready for strangers yet.
  - Gives time to refine packaging and onboarding.
- Cons:
  - Risks collecting polite interest without real usage.
  - Weakens the builder energy of "you can use this now."
  - Delays the moment of truth on install friction.
- Reuses:
  - Existing product positioning and screenshots.

### Approach B: GitHub Releases-First Launch

Summary: Publish a polished GitHub release with a downloadable app, strong
README, release notes, screenshots, and a light product page that points to the
release. Current plan uses an unsigned public beta until Developer ID signing is
available.

- Effort: M
- Risk: Low to medium
- Pros:
  - Fastest route to a real public launch people can actually use.
  - Keeps distribution simple while still feeling legitimate.
  - Lets launch assets and product messaging stay aligned.
- Cons:
  - Requires the GitHub surface to be unusually polished.
  - Still needs packaging quality high enough for non-technical users.
  - Discovery will depend on outbound sharing, not built-in marketplace traffic.
- Reuses:
  - Existing product positioning.
  - Existing app build and PDF export workflow.
  - Existing repo docs as raw material for README and release copy.

### Approach C: AI Report Handoff Campaign

Summary: Package the launch around a specific use case: AI-generated reports,
plans, and research that need to become shareable PDFs fast.

- Effort: M
- Risk: Medium
- Pros:
  - Stronger and more memorable than generic Markdown language.
  - Easy to demonstrate with before/after examples.
  - Better fit for communities already using AI tools daily.
- Cons:
  - Narrows the product story aggressively.
  - Could make broader Markdown use feel secondary.
  - Needs better demo assets and stronger editorial taste.
- Reuses:
  - Existing "AI-generated Markdown" positioning.
  - Existing PDF export wedge.

## Recommended Approach

Choose Approach B, with some of the storytelling from Approach C.

That means:

- GitHub Releases is the actual download surface.
- A simple landing page exists to explain the promise and point to the release.
- Launch assets should show AI-output examples, not generic Markdown snippets.

This keeps the launch real. People can download the app immediately. It also
keeps the story sharp enough to travel in AI-heavy communities.

## Launch Plan

### Phase 1: Tighten the public story

Ship three public-facing assets together:

1. A homepage with:
   - Hero: "Your AI gives you Markdown. ViewMD makes it readable."
   - 3-step workflow: open `.md`, read beautifully, export PDF.
   - 2 to 3 screenshots using realistic AI-generated documents.
   - CTA: "Download for Mac"
2. A GitHub README that mirrors the same story and avoids developer-tool drift.
3. Release notes that explain exactly who the app is for and what problem it
   solves.

### Phase 2: Make the release page trustworthy

The GitHub release should include:

- Signed app artifact.
- Clear install steps.
- 3 annotated screenshots.
- A 20 to 40 second demo GIF or video.
- Plain-English explanation of privacy: local files stay local.
- Known limitations section so early adopters do not feel tricked.

### Phase 3: Seed the first audience manually

The first launch should not depend on passive discovery. Push it into places
where AI power users already live:

- X/Twitter posts showing before/after AI document output.
- Reddit or forum posts where people complain about ugly AI exports.
- Hacker News "Show HN" if the build quality and story are sharp enough.
- Personal outreach to people who regularly share AI-generated plans, reports,
  and docs.

The message should not be "I built a Markdown viewer." It should be "If your AI
hands you `.md`, this makes it presentable in one step."

### Phase 4: Learn from first-contact behavior

Track four things during the first launch wave:

1. Do people understand what the app is within 5 seconds?
2. Do they trust a GitHub release enough to download it?
3. Do they actually open one of their own AI-generated files with it?
4. Do they export and share a PDF, or stop after viewing?

If people stall before download, the trust problem is packaging and message.
If they download but do not use it, the problem is wedge or onboarding.
If they use it but do not export, the PDF story is overemphasized.

## Open Questions

- Should the first launch page live on a standalone domain or GitHub Pages?
- Is the current build polished enough for strangers, or does it need a tighter
  install experience first?
- What is the minimum acceptable release packaging before public launch:
  unsigned technical beta now, then signed plus notarized universal app later?
- Which 2 or 3 AI-generated documents best demonstrate the product fast?

## Success Criteria

- A cold visitor understands the product in under 10 seconds.
- A GitHub visitor can download and install the app without terminal steps.
- At least 3 real users outside the immediate circle open their own Markdown
  files in ViewMD.
- At least 1 user independently shares an exported PDF or comments on that
  workflow specifically.
- Launch feedback mentions the workflow benefit, not just the existence of a
  viewer.

## Distribution Plan

- Primary: GitHub Releases
- Support: lightweight product page pointing to the release
- Near-term follow-up: unsigned public beta automation through GitHub
- Later follow-up: signed and notarized build automation after Apple Developer Program access
  Actions
- Deferred: Mac App Store

## Next Steps

1. Write the public README and release copy using the approved positioning.
2. Produce 3 strong screenshots using realistic AI-generated files.
3. Record a short demo of open -> read -> export.
4. Decide whether the first launch page is GitHub Pages or a standalone site.
5. Package the first public release to a quality level suitable for strangers.
6. Prepare a short outbound launch list: X, Show HN, direct outreach, and one
   or two relevant communities.

## The Assignment

Before doing more packaging work, find 3 real AI-generated Markdown documents
you would be proud to use as launch examples. If those examples do not make the
product feel obviously useful, the launch message is still too weak.

## What I Noticed About How You Think

- You did not ask for "marketing ideas." You asked how to "launch this personal
  tool to the people," which means you care about actual public contact, not
  internal polish.
- You kept pulling toward GitHub instead of accepting a generic waitlist plan.
  That is a good instinct for a builder tool that needs trust fast.
- You chose the AI-output workflow as the differentiator, which keeps the story
  about user outcome instead of renderer features.

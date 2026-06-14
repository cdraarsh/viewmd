# ViewMD Broad Awareness Launch Runbook

Status: implementation-ready
Goal: awareness among technical Mac users who receive Markdown from AI tools and coding agents
Primary message: **Your AI gives you Markdown. ViewMD makes it readable.**

## Release Strategy

ViewMD does not currently have paid Apple Developer Program access. That means the first release cannot be Developer ID signed or notarized.

The launch strategy is now two-stage:

1. **Unsigned public beta now** for technical Mac and AI-builder audiences.
2. **Signed/notarized broad consumer release later** after Apple Developer Program access is available.

Do not tell users to disable Gatekeeper globally. Document only Apple's per-app override flow.

Unsigned public beta requirements:

- Universal app binary for Apple Silicon and Intel.
- Ad-hoc signed unsigned beta artifact.
- SHA-256 checksum attached to the release.
- Clear unsigned/not-notarized warning before download.
- Build-from-source path for technical users.
- Clean install test including Apple's per-app Open Anyway flow.
- One real `.md` opened and one PDF exported beside the source file.

Local build command:

```bash
./scripts/release-build.sh --unsigned-public-beta
```

Future notarized release build command with local Apple credentials:

```bash
VIEWMD_SIGN_IDENTITY="Developer ID Application: <name> (<team-id>)" \
VIEWMD_NOTARY_PROFILE="viewmd-notary" \
./scripts/release-build.sh --require-release-signing --notarize
```

GitHub Actions unsigned release path:

1. Push the repo to `cdraarsh/viewmd`.
2. Run the **Release** workflow for `v1.0.0`.
3. Choose `distribution = unsigned-public-beta`.
4. Keep the release as a draft until install QA passes.
5. Publish the draft release after verifying the zip and checksum.

## Public Surfaces

- Download: `https://github.com/cdraarsh/viewmd/releases/tag/v1.0.0`
- Landing page: GitHub Pages from `docs/index.html`
- Release notes: `docs/RELEASE_NOTES_v1.0.0.md`
- Launch copy: `docs/LAUNCH_COPY.md`
- Feedback: GitHub feedback and bug issue forms

## Launch Day

- Publish the GitHub Release with the unsigned public beta zip and checksum.
- Confirm the landing page CTA points to the release tag.
- Confirm every public surface says the build is unsigned and not notarized.
- Post the X/Twitter and LinkedIn launch copy with the demo asset.
- Send direct outreach to 30-50 technical Mac/AI power users.
- Track replies in the feedback log from `docs/FEEDBACK_PLAYBOOK.md`.

## Days 1-3

- Post Show HN only after the release can be downloaded without signup and the unsigned status is clearly disclosed.
- Post to r/MacApps with official distribution links and transparent maker disclosure.
- Use AI communities with a value-led workflow post, not a link-only promotion.
- Respond quickly to install friction, rendering gaps, and export confusion.

## Days 4-10

- Do not launch on Product Hunt, AlternativeTo, or MacUpdate while the only build is unsigned.
- Create a first-party Homebrew tap/cask for technical users after the GitHub release URL is stable.
- Defer official Homebrew Cask submission until ViewMD has external awareness and maintenance signal.

## Weeks 3-4

- Reassess whether demand justifies Apple Developer Program membership.
- Prepare Product Hunt, MacUpdate, AlternativeTo, Setapp, or Mac App Store only after a Developer ID signed and notarized build exists.

## Compliance Checks

- Product Hunt: use the primary product/download page, no shortened or tracking links.
- Show HN: make the app directly tryable and do not ask anyone for upvotes.
- r/MacApps: use official distribution links, disclose maker relationship, and respect promotion limits.
- Reddit: check each community rule immediately before posting.
- Apple: normal off-store distribution uses Developer ID signing and notarization. This beta is intentionally unsigned and must disclose the macOS warning before download.
- Apple: use only the per-app Open Anyway override flow. Do not document global Gatekeeper disablement.

## Metrics

14-day technical beta target:

- 300+ landing/repo visits.
- 50+ unsigned release downloads or source builds.
- 10+ feedback/issue responses.
- 3+ independent mentions or comments outside the immediate circle.

Activation target:

- 10 users confirm they opened their own `.md`.
- 5 users confirm PDF export.

Quality target:

- Zero unresolved install blockers before paying for Developer ID distribution.

Messaging target:

- Feedback describes ViewMD as an AI Markdown-to-readable-document/PDF workflow, not just another Markdown viewer.

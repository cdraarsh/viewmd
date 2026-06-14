# ViewMD Public Beta Feedback Playbook

Use this during the first public beta wave. The goal is to find the first point of friction, not to collect compliments.

## Recruit Profile

Prioritize Mac users who already receive `.md` files from:

- ChatGPT, Claude, or other AI assistants
- Cursor, Codex, Claude Code, or coding agents
- AI research/report workflows
- Markdown-heavy note, writing, or handoff workflows

## Ask

Send each tester one request:

> Please try ViewMD with one real AI-generated Markdown file. Open it, review it, export a PDF, and tell me where you got stuck.

## 10-Second Comprehension Test

Before they install, show the product page or README and ask:

> What do you think this app does?

Pass condition: they describe AI Markdown becoming readable or shareable.
Fail condition: they describe only a generic Markdown viewer or editor.

## Feedback Log

Use this table in notes, a spreadsheet, or a GitHub project.

| Tester | Source of `.md` | Installed? | Opened own file? | Exported PDF? | First blocker | Would reuse? | Follow-up |
|---|---|---:|---:|---:|---|---|---|
|  |  |  |  |  |  |  |  |

## Interview Prompts

Ask only after the tester has tried the product:

1. What did you expect to happen after download?
2. What was the first confusing step?
3. Did the rendered document look good enough to share?
4. Did you notice where the exported PDF went?
5. What would make this a tool you keep installed?

## Triage Rules

- **Install blocker:** fix before public posting.
- **Open With confusion:** improve install instructions and screenshots.
- **Rendering bug:** capture a redacted sample file and create a bug issue.
- **Export confusion:** improve button visibility, confirmation, or release copy.
- **Positioning miss:** update README, product page, and launch copy together.

## First Public Beta Exit Criteria

- 5 or more real installs.
- 3 or more own-file opens.
- 1 or more PDF exports.
- No unresolved critical install blocker.
- Clear top 3 friction points documented.

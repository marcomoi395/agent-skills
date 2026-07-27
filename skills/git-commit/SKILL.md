---
name: git-commit
description: Standardizes commit messages for repositories using release-please and Conventional Commits, with optional interactive GitHub issue linking. Use when preparing a commit, choosing a commit type, or avoiding unintended releases.
---

# Git Commit for Release-Please Repositories

## Overview

This skill helps an agent write correct Conventional Commit messages in repositories that use `release-please`. The goal is to keep version bumps intentional, changelog generation predictable, and work-in-progress changes from accidentally triggering a release PR.

## When to Use

- Use when preparing a git commit in a repository managed by `release-please`.
- Use when deciding whether a change should be `feat`, `fix`, `chore`, `docs`, `refactor`, `style`, or `test`.
- Use when the main risk is triggering the wrong release type from an incorrect commit prefix.
- Use when you want to optionally link commits to GitHub issues for traceability.
- Do not use for branch strategy, merge conflict handling, or broader git hygiene; use `git-workflow-and-versioning` for that.

## How It Works

1. Classify the change by user-visible impact.
2. Decide whether the change should trigger a release.
3. Choose the Conventional Commit type that matches that intent.
4. Optionally query and present GitHub issues for interactive linking.
5. Write a short imperative summary.
6. Mark breaking changes explicitly when backward compatibility is broken.
7. Verify the final message will produce the intended `release-please` behavior.

## Commit Rules

### 1. Commit Message Structure

Every commit message must follow this format:

```text
<type>: <description>
```

If user provides issue or ticket URL with commit request, append it to same subject line in this exact form:

```text
<type>: <description>. Issue: <full-url>
```

The description must be concise and written in the imperative mood:

- `fix: handle empty token response`
- `chore: update internal prompts`
- `docs: clarify installation steps`
- `fix: default maintenance file ticket pagination to 50. Issue: https://github.com/marcomoi395/hera-flow/issues/40`

### 2. Commit Types and Release Impact

| Type | Use for | Release impact |
| --- | --- | --- |
| `feat` | New user-facing functionality | Minor release |
| `fix` | User-facing bug fix | Patch release |
| `chore` | Maintenance, internal updates, config, dependencies | No release |
| `docs` | Documentation-only changes | No release |
| `refactor` | Internal code changes without behavior change | No release |
| `style` | Formatting or whitespace-only changes | No release |
| `test` | Adding or correcting tests | No release |

### 3. Safe Defaults

To avoid unintended releases:

- Default to `chore:` for internal work, WIP changes, prompt edits, automation tweaks, and repository maintenance.
- Use `docs:` for Markdown or documentation-only edits.
- Do not use `feat:` or `fix:` until the change is complete and truly ready to be reflected in release notes.
- If the diff mixes user-facing work and internal cleanup, split the work into separate commits instead of forcing one prefix to cover both.

When user gives ticket URL explicitly, do not put it only in commit body or omit it. Put it in commit subject line using `. Issue: <url>` unless user asks for a different commit format.

### 4. Breaking Changes

If the change breaks backward compatibility, mark it explicitly with either form below:

- `feat!: change authentication payload format`
- Footer: `BREAKING CHANGE: clients must send device_id`

This triggers a major release.

### 5. Interactive Issue Linking

When preparing a commit, optionally link it to a GitHub issue through interactive selection:

**Workflow:**

1. Check if user explicitly provided an issue/ticket URL in their request.
   - If yes: use that URL directly with `. Issue: <url>` format.
   - If no: proceed to step 2.

2. Query open issues in the current repository:
   ```bash
   gh issue list --state open --limit 20 --json number,title,url
   ```

3. Present the list to user for selection:
   - Show issue number, title, and URL
   - Include a "Skip" or "None" option
   - Let user choose the most relevant issue

4. If user selects an issue:
   - Append `. Issue: <url>` to commit subject line
   - Use full GitHub URL format

5. If user skips or no issues exist:
   - Proceed without issue reference
   - This is perfectly acceptable for many commits

**When to link issues:**

- `feat` or `fix` commits that resolve a reported issue
- `chore` commits that address technical debt tracked in an issue
- Any commit where traceability to requirements/bugs is valuable

**When to skip:**

- Quick typo fixes or minor corrections
- Documentation updates without corresponding issue
- Routine maintenance (dependency updates, formatting)
- When no relevant issue exists and creating one adds no value

**Format examples:**

```text
fix: handle empty token response. Issue: https://github.com/owner/repo/issues/42
feat: add dark mode toggle. Issue: https://github.com/owner/repo/issues/105
chore: refactor auth module. Issue: https://github.com/owner/repo/issues/89
```

**GitHub CLI requirement:**

This workflow requires `gh` CLI to be installed and authenticated. If `gh` is not available:
- Fall back to manual issue URL entry
- Or skip issue linking entirely
- Never block the commit process

## Decision Flow

```text
Start
  │
  ├─ Is this documentation only?
  │    └─ Yes → docs
  │
  ├─ Is this internal maintenance, config, dependency, or WIP work?
  │    └─ Yes → chore
  │
  ├─ Does this change add end-user functionality?
  │    └─ Yes → feat
  │
  ├─ Does this change fix a user-facing bug?
  │    └─ Yes → fix
  │
  ├─ Is behavior unchanged and code is only being reorganized?
  │    └─ Yes → refactor
  │
  ├─ Is this formatting only?
  │    └─ Yes → style
  │
  └─ Is this test-only work?
       └─ Yes → test
```

## Usage

This is a process skill. It does not require a helper script.

Apply it immediately before writing a commit message:

1. Review the exact staged diff.
2. Decide whether the change should affect versioning.
3. Choose the commit type from the rules above.
4. **Optionally link to a GitHub issue** (see Interactive Issue Linking):
   - Check if user provided issue URL explicitly → use it
   - Otherwise, query and present open issues for selection
   - User may skip if no relevant issue exists
5. Write the final message, appending `. Issue: <url>` when issue was selected or provided.
6. Re-check that the chosen type matches the intended release impact.

**Examples:**

```text
chore: update agent skill descriptions
docs: clarify Claude Code installation steps
fix: prevent empty release notes in generator
feat: add HTML dashboard export for plan analysis
fix: default maintenance file ticket pagination to 50. Issue: https://github.com/marcomoi395/hera-flow/issues/40
```

## Output

The output of this skill is a recommended commit message and a short rationale for why that prefix is correct.

If user supplied issue or ticket URL, or selected one from the interactive list, the recommended commit must include that URL in the subject line as `. Issue: <url>`.

Example:

```text
Recommended commit: chore: update git-commit skill template
Why: the change only restructures skill documentation and should not trigger a release.
```

Example with issue:

```text
Recommended commit: fix: handle null auth token. Issue: https://github.com/owner/repo/issues/42
Release impact: patch
Why: this fixes a user-facing bug where empty tokens caused crashes.
```

## Present Results to User

Use this format when reporting back:

```text
Recommended commit: <type>: <summary> [. Issue: <url>]
Release impact: <none | patch | minor | major>
Why: <one or two sentences>
```

The `[. Issue: <url>]` portion is optional and included only when an issue is linked.

## Verification

Before finalizing the commit:

- [ ] Commit type matches the user-visible impact of the change.
- [ ] Release impact is intentional (no accidental `feat` or `fix` for internal work).
- [ ] Message is written in imperative mood ("add feature" not "added feature").
- [ ] Breaking changes are marked with `!` or `BREAKING CHANGE:` footer.
- [ ] Issue URL is included in subject line when user provided one or selected one from the list.
- [ ] Safe defaults are applied: prefer `chore:` when unsure, avoid unintended releases.

## Troubleshooting

**Commit type selection:**

- If you are unsure whether a change is user-facing, prefer `chore:` and explain the ambiguity.
- If one commit would mix release-triggering and non-release work, split it into separate commits.
- If the repository does not use `release-please`, the Conventional Commit format may still be useful, but the release-impact rules in this skill may not apply exactly.
- If the change is backward-incompatible, do not hide it under `chore:` or `refactor:`; mark it as breaking explicitly.

**Issue linking:**

- If `gh` CLI is not available or authentication fails, fall back to asking user for manual URL entry or skip issue linking.
- If no open issues exist or none are relevant, skip issue linking without concern.
- Never block or delay the commit process waiting for issue selection.
- If user provided issue URL explicitly in their request, always use it regardless of interactive workflow.

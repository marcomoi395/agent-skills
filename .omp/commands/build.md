# Build Command

Implement tasks incrementally — build, test, verify, commit. Add "auto" to run the whole plan in one approved pass.

## Arguments

- `$ARGUMENTS` — optional. Either:
  - Empty (default): implement the next pending task, then stop
  - `auto` or `all`: autonomous mode — implement every task in the plan without stopping between them
  - `<github-issue-url>`: issue-linked mode — create a branch for the issue, then implement the next task

## Steps

### 1. Determine the mode

Parse `$ARGUMENTS`:
- If `auto` or `all` → **autonomous mode** (run the whole plan)
- If matches `https://github.com/.*/issues/\d+` → **issue-linked mode** (create branch + implement one task)
- Otherwise → **default mode** (one task at a time)

Autonomous mode does not skip verification — it runs the same test-driven loop for every task, removing only the manual stepping between tasks.

### 2. Default mode: Implement one task

Pick the next pending task from `tasks/todo.md` or `tasks/plan.md`. Then:

1. **Read the task's acceptance criteria** — Understand what success looks like
2. **Load relevant context** — Read existing code, patterns, types, and conventions
3. **Write a failing test for the expected behavior (RED)** — Follow the `test-driven-development` skill
4. **Implement the minimum code to pass the test (GREEN)** — Write only what's needed
5. **Run the full test suite to check for regressions** — Ensure no existing tests break
6. **Run the build to verify compilation** — Confirm the build succeeds
7. **Run the formatter over changed files** — Apply consistent code style
8. **Commit with a descriptive message** — Follow `git-workflow-and-versioning` or `git-commit` skill
9. **Mark the task complete and stop** — Update the task status and yield control

### 3. Issue-linked mode: Create branch and implement one task

When a GitHub issue URL is provided (e.g., `https://github.com/owner/repo/issues/10`), create a feature branch linked to that issue before implementing the task.

#### a. Parse the issue URL

Extract the issue number from the URL. Example:
- Input: `https://github.com/marcomoi395/hera-nest/issues/10`
- Extract: issue number `10`

#### b. Determine branch naming convention

Inspect the current plan (`tasks/plan.md` or `tasks/todo.md`) to understand the goal:
- If the plan describes a **feature** (e.g., "Add authentication", "Implement dashboard") → use prefix `feat/`
- If the plan describes a **fix** (e.g., "Fix login bug", "Resolve timeout issue") → use prefix `fix/`
- If the plan describes a **refactor** or **chore** → use prefix `refactor/` or `chore/`
- If unclear or general tasks → no prefix (just `10-description`)

Branch name format:
```
<prefix>/<issue-number>-<brief-description>
```

Examples:
- `feat/10-add-auth-module`
- `fix/10-resolve-timeout`
- `10-update-dependencies` (no prefix if unclear)

Keep the description short (3-5 words max), lowercase, hyphen-separated.

#### c. Create and checkout the new branch

```bash
git checkout -b <branch-name>
```

Verify the branch was created successfully.

#### d. Implement the task

Follow the exact same workflow as **default mode** (step 2 above):
1. Read task acceptance criteria
2. Load relevant context
3. Write failing test (RED)
4. Implement minimum code (GREEN)
5. Run full test suite
6. Run build
7. Run formatter
8. Commit with descriptive message
9. Mark task complete and stop

#### e. Link the issue in commit message

When committing, append the issue URL to the commit message following the `git-commit` skill format:

```text
<type>: <description>. Issue: <full-url>
```

Example:
```bash
git commit -m "feat: implement user authentication. Issue: https://github.com/marcomoi395/hera-nest/issues/10"
```


### 4. Autonomous mode: Implement the whole plan

Use this once a spec exists and you want to collapse plan + build into one run.

#### a. Require a spec

Look for a spec at known paths: `SPEC.md` at the repo root, `docs/SPEC.md`, or files under `spec/`.

A README or arbitrary doc does NOT count. If no spec exists, stop and tell the user to run `/spec` first — do not invent requirements.

#### b. Establish a clean baseline

Run `git status --porcelain`. If there are uncommitted changes outside the expected planning artifacts (`SPEC.md`, `docs/SPEC.md`, `spec/*`, `tasks/plan.md`, `tasks/todo.md`), stop and ask the user to commit, stash, or confirm how to handle them.

Autonomous per-task commits must not absorb unrelated local work, or the clean-rollback guarantee breaks.

#### c. Plan if needed

If there is no `tasks/plan.md`, invoke the `planning-and-task-breakdown` skill to generate one.

#### d. Single checkpoint

Present the full plan and wait for an unambiguous affirmative response (e.g., "approve", "go", "yes").

Treat hedged responses ("looks reasonable", "I guess") as NOT approved.

This is the only human gate — after approval, run autonomously.

If you generated `tasks/plan.md`, commit it as a single preparatory commit now so it doesn't bleed into the first task's commit.

#### e. Execute every task in dependency order

Use each task's declared dependencies; if they aren't explicit, execute in the order the plan lists them.

For each task:
1. Run the full default loop (step 2 above: RED → GREEN → regression → build → format → commit → mark complete)
2. Stage only the files that task touched plus its task-status update — never `git add -A` blindly
3. Make one commit per task so any point is a clean rollback

#### f. Stop and ask the user when:

- A test can't be made to pass or the build breaks without an obvious fix → follow the `debugging-and-error-recovery` skill
- The spec is ambiguous, or a task needs a decision the spec doesn't cover
- A task is high-risk or irreversible:
  - Auth/permission changes
  - Destructive data migrations
  - Payments, deletions, deploys
  - Anything touching secrets
  - Anything you can't undo with `git revert`
  
  → Follow the `doubt-driven-development` skill and get explicit sign-off before continuing

After the user resolves a blocker, they re-invoke `/build auto` — it resumes from the next pending task.

#### g. Summarize at the end

Print a summary: tasks completed, tests added, commits made, and anything skipped, flagged, or left for the user.

## Rules

- **MUST** invoke `incremental-implementation` and `test-driven-development` skills — do not implement their workflows inline.
- **MUST** write a failing test before implementing each task (RED before GREEN).
- **MUST** run the full test suite after each task to check for regressions.
- **MUST** create a new branch from the current branch when a GitHub issue URL is provided.
- **MUST** extract the issue number from the URL and include it in the branch name.
- **MUST** determine the appropriate branch prefix (feat/, fix/, etc.) based on the plan's goal.
- **MUST** append the issue URL to the commit message in issue-linked mode.
- **MUST** run the build after each task to verify compilation.
- **MUST** commit after each task with a descriptive message.
- **MUST** stage only files touched by that task — never `git add -A` blindly in autonomous mode.
- **MUST** require a spec before running autonomous mode.
- **MUST** establish a clean git baseline before autonomous mode (no uncommitted work outside planning artifacts).
- **MUST** wait for unambiguous approval before starting autonomous mode.
- **MUST** stop and ask when a task is high-risk, irreversible, or blocked.
- **MUST** follow `debugging-and-error-recovery` skill when tests or builds fail.
- **MUST NOT** skip verification steps to go faster — every task earns a passing test.
- **MUST NOT** implement multiple tasks in one commit in autonomous mode.
- **MUST NOT** proceed with autonomous mode if no spec exists.

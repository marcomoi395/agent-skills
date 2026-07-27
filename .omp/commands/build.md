# Build Command

Implement tasks incrementally — build, test, verify, commit. Add "auto" to run the whole plan in one approved pass.

## Arguments

- `$ARGUMENTS` — optional. Either:
  - Empty (default): implement the next pending task, then stop
  - `auto` or `all`: autonomous mode — implement every task in the plan without stopping between them

## Steps

### 1. Determine the mode

Parse `$ARGUMENTS`:
- If `auto` or `all` → **autonomous mode** (run the whole plan)
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

### 3. Autonomous mode: Implement the whole plan

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

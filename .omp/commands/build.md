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
- If matches `https://github.com/.*/issues/\d+` → **issue-linked mode** (user-provided issue URL)
- Otherwise → **default mode** (one task at a time)

### 2. Check for issue links and create branch (ALL MODES)

Before implementing any task, check for a GitHub issue URL:

#### a. Determine the issue URL source

1. **If in issue-linked mode** — Use the issue URL provided in `$ARGUMENTS`
2. **Otherwise** — Scan `tasks/plan.md` or `tasks/todo.md` for GitHub issue URLs matching `https://github.com/.*/issues/\d+`

#### b. If an issue URL is found (from either source)

1. **Check if already on the correct issue branch (bypass optimization)**
   
   Before creating a new branch, check if you're already on a branch for this issue:
   
   ```bash
   git branch --show-current
   ```
   
   Parse the current branch name to extract the issue number:
   - Pattern `(feat|fix|refactor|chore)/(\d+)-.*` → extract issue number from second capture group
   - Pattern `(\d+)-.*` → extract issue number from first capture group
   
   Compare with the issue number from the detected URL:
   - **If they match** → You're already on the correct issue branch. Skip to step 4 (store the issue URL for commits). This commonly happens when continuing work from a previous session.
   - **If they don't match or no issue number found in branch name** → Continue to step 2 below to create a new branch.

2. **Extract the issue number** from the URL
   - Example: `https://github.com/owner/repo/issues/10` → issue number `10`

3. **Determine branch naming convention**
   
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

4. **Create and checkout the new branch**
   
   ```bash
   git checkout -b <branch-name>
   ```
   
   Verify the branch was created successfully from the current branch.

5. **Store the issue URL** for commit message linking (used in step 3 or 4)

#### c. If no issue URL is found

Skip branch creation and continue on the current branch.


### 3. Default mode: Implement one task

Pick the next pending task from `tasks/todo.md` or `tasks/plan.md`. Then:

1. **Read the task's acceptance criteria** — Understand what success looks like
2. **Load relevant context** — Read existing code, patterns, types, and conventions
3. **Write a failing test for the expected behavior (RED)** — Follow the `test-driven-development` skill
4. **Implement the minimum code to pass the test (GREEN)** — Write only what's needed
5. **Run the full test suite to check for regressions** — Ensure no existing tests break
6. **Run the build to verify compilation** — Confirm the build succeeds
7. **Run the formatter over changed files** — Apply consistent code style
8. **Commit with a descriptive message** — Follow `git-workflow-and-versioning` or `git-commit` skill. If an issue URL was found in step 2, append it to the end of the first line (subject): `<type>: <description>. Issue: <full-url>`
9. **Mark the task complete and stop** — Update the task status and yield control
### 4. Autonomous mode: Implement the whole plan

Use this once a spec exists and you want to collapse plan + build into one run.

#### a. Check for spec (optional but recommended)

Look for a spec at known paths: `SPEC.md` at the repo root, `docs/SPEC.md`, or files under `spec/`.

A spec is recommended for complex features but not required. For simple tasks, having `tasks/plan.md` or `tasks/todo.md` is sufficient to run autonomous mode.

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

- **MUST** check if already on the correct issue branch before creating a new one (bypass optimization).
- **MUST** extract issue number from current branch name and compare with detected issue URL to avoid duplicate branch creation.
- **MUST** check for GitHub issue URLs before implementing any task in ALL modes (default, autonomous, issue-linked).
- **MUST** scan `tasks/plan.md` or `tasks/todo.md` for issue URLs if not provided as an argument.
- **MUST** automatically create a branch from the current branch when a GitHub issue URL is found (from any source).
- **MUST** extract the issue number from the URL and include it in the branch name.
- **MUST** determine the appropriate branch prefix (feat/, fix/, refactor/, chore/) based on the plan's goal.
- **MUST** append the issue URL to the end of the commit subject line when a branch was created: `<type>: <description>. Issue: <full-url>` (NOT in the body)
- **MUST** invoke `incremental-implementation` and `test-driven-development` skills — do not implement their workflows inline.
- **MUST** write a failing test before implementing each task (RED before GREEN).
- **MUST** run the full test suite after each task to check for regressions.
- **MUST** run the build after each task to verify compilation.
- **MUST** commit after each task with a descriptive message.
- **MUST** stage only files touched by that task — never `git add -A` blindly in autonomous mode.
- **SHOULD** have a spec for complex features, but tasks/plan.md is sufficient for simple tasks in autonomous mode.
- **MUST** establish a clean git baseline before autonomous mode (no uncommitted work outside planning artifacts).
- **MUST** wait for unambiguous approval before starting autonomous mode.
- **MUST** stop and ask when a task is high-risk, irreversible, or blocked.
- **MUST** follow `debugging-and-error-recovery` skill when tests or builds fail.
- **MUST NOT** skip verification steps to go faster — every task earns a passing test.
- **MUST NOT** implement multiple tasks in one commit in autonomous mode.

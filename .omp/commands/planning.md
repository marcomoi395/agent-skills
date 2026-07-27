# Planning Command

Break work into small verifiable tasks with acceptance criteria and dependency ordering.

## Arguments

- `$ARGUMENTS` — optional. Scope or feature name to plan. If omitted, plans the full spec from `SPEC.md`.

## Steps

### 1. Verify spec exists

Check for a spec at known paths: `SPEC.md` at the repo root, `docs/SPEC.md`, or files under `spec/`. If no spec exists, stop and tell the user to run `/spec` first.

A README or arbitrary doc does NOT count as a spec.

### 2. Enter plan mode — read only

Do not make any code changes during planning. This phase is read-only analysis.

### 3. Invoke the planning-and-task-breakdown skill

Load and follow the `planning-and-task-breakdown` skill workflow. This skill encodes the full process for breaking work into verifiable tasks.

### 4. Analyze the codebase and dependencies

1. Read the spec and understand the full scope
2. Read relevant codebase sections to understand existing patterns
3. Identify the dependency graph between components
4. Determine natural seams and integration points

### 5. Slice work vertically

Break work into vertical slices — each task delivers one complete path through the system, not horizontal layers.

Good: "Implement user login flow (route → validation → DB → session → response)"
Bad: "Implement all database models" followed by "Implement all routes"

### 6. Write tasks with acceptance criteria

For each task, specify:

1. **Description** — What this task delivers (one sentence)
2. **Acceptance criteria** — Observable outcomes that prove the task is complete
3. **Verification steps** — Commands to run, tests to check, behavior to observe
4. **Dependencies** — Which tasks must complete before this one can start
5. **Estimated complexity** — Small (< 2 hours), Medium (2-6 hours), Large (> 6 hours, consider splitting)

### 7. Add checkpoints between phases

Insert review/integration checkpoints between major phases. These are natural stopping points to verify everything works together before proceeding.

### 8. Present the plan for human review

Save the plan to `tasks/plan.md` (detailed breakdown) and `tasks/todo.md` (simple checklist).

Present the plan and wait for approval before any implementation starts.

## Rules

- **MUST** verify a spec exists before planning; do not invent requirements.
- **MUST** invoke the `planning-and-task-breakdown` skill — do not implement its workflow inline.
- **MUST** make no code changes during planning — this is a read-only phase.
- **MUST** slice work vertically (complete paths) not horizontally (layers).
- **MUST** include acceptance criteria and verification steps for every task.
- **MUST** save the plan to `tasks/plan.md` and task list to `tasks/todo.md`.
- **MUST** wait for user approval of the plan before implementation.
- **MUST NOT** create tasks without clear acceptance criteria.
- **MUST NOT** create tasks larger than 6 hours without splitting them.

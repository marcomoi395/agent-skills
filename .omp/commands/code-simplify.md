# Code Simplify Command

Simplify code for clarity and maintainability — reduce complexity without changing behavior.

## Arguments

- `$ARGUMENTS` — optional. Specific files, functions, or modules to simplify. If omitted, simplifies recently changed code.

## Steps

### 1. Read project conventions

Check for `AGENTS.md`, `CONTRIBUTING.md`, or `.omp/rules/` to understand project-specific conventions before making changes.

### 2. Invoke the code-simplification skill

Load and follow the `code-simplification` skill workflow. This skill encodes the full simplification process.

### 3. Identify the target code

Determine what to simplify:
- Recently changed code (default): check `git log` for recent commits
- Specified scope: specific files, functions, or modules from `$ARGUMENTS`
- Staged changes: code in `git diff --cached`

### 4. Understand before simplifying

Before touching any code, understand:
1. **Purpose** — What does this code do? What problem does it solve?
2. **Callers** — Where is this code called from? What depends on it?
3. **Edge cases** — What boundary conditions does it handle?
4. **Test coverage** — What tests cover this code? Are they adequate?

Read the tests first — they document the expected behavior you must preserve.

### 5. Scan for simplification opportunities

Look for these common complexity patterns:

#### Deep nesting
- Replace with guard clauses (early returns)
- Extract nested logic into helper functions
- Invert conditions to reduce nesting depth

#### Long functions
- Split by single responsibility
- Extract cohesive blocks into named helpers
- Separate I/O from logic

#### Nested ternaries
- Replace with if/else or switch statements
- Extract to named variables for clarity

#### Generic names
- Replace `data`, `obj`, `temp`, `x` with descriptive names
- Use domain terminology consistently

#### Duplicated logic
- Extract to shared functions
- Identify the abstraction the duplication is hiding

#### Dead code
- Remove unused functions, imports, variables
- Confirm with `grep` or LSP references before removing

### 6. Apply simplifications incrementally

For each simplification:

1. **Make one change at a time** — Do not combine multiple simplifications in one edit
2. **Run tests after each change** — Ensure behavior is preserved
3. **Verify the build succeeds** — Confirm compilation after each change
4. **Review the diff** — Ensure only intended changes are present

If tests fail after a simplification:
- **Revert that change** — Use `git checkout` or undo the edit
- **Reconsider the approach** — The simplification may have changed behavior
- **Investigate the test failure** — Follow `debugging-and-error-recovery` skill

### 7. Verify final result

After all simplifications:

1. **Run the full test suite** — All tests should pass
2. **Run the build** — Compilation should succeed
3. **Review the complete diff** — Ensure the diff is clean
4. **Invoke `code-review-and-quality`** — Review the simplified code

### 8. Measure improvement

Compare before and after:
- Cyclomatic complexity (fewer branches)
- Line count (shorter is often simpler)
- Nesting depth (shallower is clearer)
- Function length (smaller is more focused)

## Rules

- **MUST** invoke the `code-simplification` skill — do not implement its workflow inline.
- **MUST** read and understand code before simplifying it.
- **MUST** read tests first — they document the behavior you must preserve.
- **MUST** apply simplifications one at a time.
- **MUST** run tests after each simplification to verify behavior is preserved.
- **MUST** revert a simplification if tests fail.
- **MUST** verify the full test suite passes after all changes.
- **MUST** verify the build succeeds after all changes.
- **MUST** use `code-review-and-quality` to review the result.
- **MUST NOT** change behavior — simplification preserves exact behavior.
- **MUST NOT** combine multiple simplifications in one commit.
- **MUST NOT** remove code without confirming it's unused.
- **MUST NOT** simplify code you haven't tested.

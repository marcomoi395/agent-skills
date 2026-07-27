# Test Command

Run TDD workflow — write failing tests, implement, verify. For bugs, use the Prove-It pattern.

## Arguments

- `$ARGUMENTS` — optional. Specific feature, module, or bug number to test. If omitted, applies TDD to the current task context.

## Steps

### 1. Invoke the test-driven-development skill

Load and follow the `test-driven-development` skill workflow. This skill encodes the full TDD process.

### 2. Choose the appropriate workflow

#### For new features (RED → GREEN → REFACTOR):

1. **Write tests that describe the expected behavior** — These tests should FAIL initially because the feature doesn't exist yet.
2. **Run the tests and confirm they fail** — Verify failure is for the right reason (not a syntax error or missing import).
3. **Implement the minimum code to make them pass** — Write only what's needed to make the tests green.
4. **Run the tests and confirm they pass** — All new tests should pass; no existing tests should break.
5. **Refactor while keeping tests green** — Clean up the implementation without changing behavior.

#### For bug fixes (Prove-It pattern):

1. **Write a test that reproduces the bug** — The test must FAIL, proving the bug exists.
2. **Confirm the test fails** — Verify it fails for the expected reason described in the bug report.
3. **Implement the fix** — Change the code to address the root cause.
4. **Confirm the test passes** — The new test should now pass.
5. **Run the full test suite for regressions** — Ensure the fix doesn't break other behavior.

### 3. Verify browser-related issues with DevTools

If the code under test runs in a browser, also invoke the `browser-testing-with-devtools` skill to verify behavior with Chrome DevTools MCP. This gives you runtime data (console errors, network requests, DOM state, performance metrics) that unit tests can't capture.

### 4. Run the full test suite

After all changes, run the complete test suite to check for regressions. Do not skip this step.

### 5. Verify the build succeeds

Run the project's build command to ensure compilation succeeds with the changes.

## Rules

- **MUST** invoke the `test-driven-development` skill — do not implement its workflow inline.
- **MUST** write tests before implementation code (RED before GREEN).
- **MUST** confirm tests fail for the right reason before implementing.
- **MUST** confirm tests pass after implementing.
- **MUST** run the full test suite to check for regressions.
- **MUST** verify the build succeeds after changes.
- **MUST** use the Prove-It pattern for bug fixes — write a failing test that reproduces the bug first.
- **MUST** invoke `browser-testing-with-devtools` for browser-related code.
- **MUST NOT** write code before writing the test that describes its behavior.
- **MUST NOT** skip the full test suite run after making changes.
- **MUST NOT** commit code with failing tests.

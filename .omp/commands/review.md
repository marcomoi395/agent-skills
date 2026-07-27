# Review Command

Conduct a five-axis code review — correctness, readability, architecture, security, performance.

## Arguments

- `$ARGUMENTS` — optional. Specific files, commits, or branches to review. If omitted, reviews current staged changes or recent commits.

## Steps

### 1. Invoke the code-review-and-quality skill

Load and follow the `code-review-and-quality` skill workflow. This skill encodes the full five-axis review process.

### 2. Identify the scope

Determine what to review:
- Staged changes (`git diff --cached`)
- Uncommitted changes (`git diff`)
- Recent commits (last N commits on current branch)
- Specific commits or commit ranges
- Specific files or directories
- Pull request diff

### 3. Review across all five axes

For each axis, assess the changes and identify findings:

#### Axis 1: Correctness
- Does the code match the spec or task acceptance criteria?
- Are edge cases handled (empty inputs, nulls, boundary values)?
- Are error paths tested?
- Is the test coverage adequate for the changes?

#### Axis 2: Readability
- Are names clear and descriptive?
- Is the logic straightforward to follow?
- Is the code well-organized?
- Are comments used only where the code can't be made self-explanatory?

#### Axis 3: Architecture
- Does the code follow existing patterns in the codebase?
- Are boundaries clean (separation of concerns)?
- Is the abstraction level appropriate (not too abstract, not too concrete)?
- Does it fit the intended module structure?

#### Axis 4: Security
- Is user input validated?
- Are secrets handled safely (not logged, not committed)?
- Are authentication and authorization checked?
- Invoke the `security-and-hardening` skill for security-focused review.

#### Axis 5: Performance
- Are there N+1 query patterns?
- Are there unbounded operations (loops without limits, recursive calls without guards)?
- Are expensive operations cached when appropriate?
- Invoke the `performance-optimization` skill for performance-focused review.

### 4. Categorize findings

For each finding, assign a severity:
- **Critical** — Blocks merge. Must fix before ship (correctness bugs, security vulnerabilities, data corruption risks).
- **Important** — Should fix before ship. Significant issues but not immediate blockers (performance problems, missing tests, unclear code).
- **Suggestion** — Nice to have. Improvements that don't block ship (minor style issues, potential future refactoring).

### 5. Output structured review

Generate a review report with:

```markdown
## Code Review Report

### Summary
- Files reviewed: <count>
- Critical findings: <count>
- Important findings: <count>
- Suggestions: <count>

### Critical Issues (MUST FIX)
- **[Axis]** `file.ext:line` — <description>
  - Problem: <what's wrong>
  - Impact: <why it matters>
  - Fix: <specific recommendation>

### Important Issues (SHOULD FIX)
- **[Axis]** `file.ext:line` — <description>
  - Problem: <what's wrong>
  - Fix: <specific recommendation>

### Suggestions
- **[Axis]** `file.ext:line` — <description>

### Positive Observations
- <what's well done>
```

### 6. Verify fix recommendations

If you recommend specific fixes, ensure they:
- Address the root cause, not just symptoms
- Match existing code conventions
- Don't introduce new issues
- Are feasible within the current architecture

## Rules

- **MUST** invoke the `code-review-and-quality` skill — do not implement its workflow inline.
- **MUST** review all five axes: correctness, readability, architecture, security, performance.
- **MUST** categorize findings as Critical, Important, or Suggestion.
- **MUST** provide specific file and line references for each finding.
- **MUST** explain the problem, impact, and recommended fix for Critical findings.
- **MUST** invoke `security-and-hardening` skill for security axis review.
- **MUST** invoke `performance-optimization` skill for performance axis review.
- **MUST NOT** flag style issues as Critical — those are Suggestions at most.
- **MUST NOT** recommend fixes that violate existing code conventions.
- **MUST NOT** review code you haven't actually read.

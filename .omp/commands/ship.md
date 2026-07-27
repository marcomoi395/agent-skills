# Ship Command

Run the pre-launch checklist via parallel fan-out to specialist personas, then synthesize a go/no-go decision.

## Arguments

- `$ARGUMENTS` — optional. Specific scope to review (commits, branches, or files). If omitted, reviews current staged changes or recent commits ready for production.

## Steps

### 1. Invoke the shipping-and-launch skill

Load and follow the `shipping-and-launch` skill workflow. This skill encodes the full pre-launch process.

### 2. Determine if fan-out is needed

**Skip the fan-out only if ALL of the following are true:**
- The change touches 2 files or fewer
- The diff is under 50 lines
- It does not touch auth, payments, data access, or config/env

Otherwise, default to fan-out. `/ship` is designed for production-bound changes — when the blast radius is non-trivial, run the parallel review even if the diff looks small.

### 3. Phase A — Parallel fan-out

Spawn three subagents concurrently. **Issue all three subagent tool calls in a single assistant turn so they execute in parallel** — sequential calls defeat the purpose of this command.

The CLI exposes each custom subagent in `agents/` as a tool with the same name — so `code-reviewer.md` becomes a `code-reviewer` tool the main agent can call, and `@code-reviewer` works as an explicit invocation in the prompt.

Dispatch each persona by tool name:

#### 1. code-reviewer
Run a five-axis review (correctness, readability, architecture, security, performance) on the staged changes or recent commits. Output the standard review template from the `code-review-and-quality` skill.

#### 2. security-auditor
Run a vulnerability and threat-model pass. Check:
- OWASP Top 10 vulnerabilities
- Secrets handling (not logged, not committed, not exposed)
- Auth/authz logic
- Dependency CVEs
- Input validation
- Output encoding

Output the standard audit report from the `security-and-hardening` skill.

#### 3. test-engineer
Analyze test coverage for the change. Identify gaps in:
- Happy path coverage
- Edge cases (boundary values, empty inputs, nulls)
- Error paths
- Concurrency scenarios

Output the standard coverage analysis from the `test-driven-development` skill.

**Constraints:**
- Subagents run in isolated context loops and return only their report to this main session
- Do not let one persona delegate to another — keep the fan-out flat
- For richer multi-agent collaboration where teammates talk to each other instead of just reporting back, see `references/orchestration-patterns.md`

**Persona resolution:** If you've defined your own `code-reviewer`, `security-auditor`, or `test-engineer` in `agents/` or your global configuration, those take precedence over this plugin's versions — `/ship` picks up your customizations automatically.

**Fallback:** If subagents are unavailable in the current CLI version, invoke each persona's system prompt sequentially in the main context and treat their outputs as if returned in parallel — the merge phase still works.

### 4. Phase B — Merge in main context

Once all three reports are back, the main agent (not a sub-persona) synthesizes them:

#### 1. Code Quality
Aggregate Critical/Important findings from `code-reviewer` and any failing tests, lint, or build output. Resolve duplicates between reviewers.

#### 2. Security
Promote any Critical/High `security-auditor` findings to launch blockers. Cross-reference with `code-reviewer`'s security axis.

#### 3. Performance
Pull from `code-reviewer`'s performance axis. Cross-check Core Web Vitals if applicable.

#### 4. Accessibility
Verify keyboard navigation, screen reader support, and contrast. This is not covered by the three personas — handle directly here, or invoke the accessibility checklist if one exists.

#### 5. Infrastructure
Verify:
- Environment variables are documented
- Database migrations are tested
- Monitoring/alerting is in place
- Feature flags are configured (if applicable)

#### 6. Documentation
Verify:
- README is updated (if public-facing changes)
- ADRs document architectural decisions
- Changelog captures user-facing changes

### 5. Phase C — Decision and rollback

Produce a single structured output:

```markdown
## Ship Decision: GO | NO-GO

### Blockers (must fix before ship)
- [Source persona] `file.ext:line` — <Critical finding with specific impact>

### Recommended fixes (should fix before ship)
- [Source persona] `file.ext:line` — <Important finding with specific recommendation>

### Acknowledged risks (shipping anyway)
- <Risk description>
  - Mitigation: <how we're reducing the risk>

### Rollback plan
- **Trigger conditions:** <what signals would prompt rollback>
- **Rollback procedure:** <exact steps to revert>
- **Recovery time objective:** <target time to complete rollback>

### Specialist reports (full)
#### Code Review (code-reviewer)
<full report>

#### Security Audit (security-auditor)
<full report>

#### Test Coverage (test-engineer)
<full report>
```

## Rules

- **MUST** invoke the `shipping-and-launch` skill — do not implement its workflow inline.
- **MUST** run the three Phase A personas in parallel — never sequentially.
- **MUST** issue all three subagent tool calls in a single assistant turn for parallel execution.
- **MUST NOT** let personas call each other — the main agent merges in Phase B.
- **MUST** include a rollback plan before any GO decision.
- **MUST** default to NO-GO if any persona returns a Critical finding, unless the user explicitly accepts the risk.
- **MUST** skip the fan-out only if all of these are true: ≤2 files, <50 lines, and no auth/payments/data/config changes.
- **MUST NOT** skip verification steps to go faster — `/ship` is for production-bound changes where correctness matters.

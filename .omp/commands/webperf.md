# Web Performance Command

Run web performance audit via web-performance-auditor persona.

## Arguments

- `$ARGUMENTS` — optional. URL, files, or components to audit. If omitted, audits the current project's web application.

## Applicability

`/webperf` targets **web applications specifically**. Do not use for:
- Utility libraries with no browser-facing output
- CLIs or command-line tools
- Server-only code with no frontend

## Steps

### 1. Determine the mode

Check what data sources are available:

#### Deep mode (use if ANY of these are available):
- **Lighthouse JSON report** — Generated via `npx lighthouse <url> --output json --output-path ./report.json`, or `npx -p chrome-devtools-mcp chrome-devtools lighthouse_audit --output-format=json` from Chrome DevTools MCP CLI
- **PageSpeed Insights JSON** — Response from PageSpeed Insights API (includes Lighthouse + CrUX field data)
- **CrUX API response** — Requires `$CRUX_API_KEY` or `$GOOGLE_API_KEY` environment variables (never hard-code API keys in config files)
- **DevTools performance trace** — Captured from Chrome DevTools
- **Live URL + chrome-devtools MCP server** — Configured in harness; capture metrics directly via `lighthouse_audit` or `performance_*` tools
- **Chrome DevTools MCP CLI** — Invoked locally via `npx -p chrome-devtools-mcp chrome-devtools <tool>`, passing JSON output to agent

#### Quick mode (fallback when Deep mode unavailable):
Scan source code for structural anti-patterns. Label findings as `potential impact` since they're not measured with real runtime data.

### 2. Invoke the web-perf skill

Load and follow the `web-perf` skill workflow. This skill encodes the full performance audit process and routes to current documentation.

### 3. Run the audit via web-performance-auditor

Spawn the `web-performance-auditor` subagent (CLI exposes custom subagents in `agents/` as tools with the same name).

Pass the subagent:
- **Files, components, or diff under review** — Specific scope to audit
- **Artifact paths or JSON content** — Lighthouse JSON, PageSpeed Insights JSON, CrUX response, or trace data
- **Target URL or page name** — When known
- **Mode note** — Explicitly state whether you expect Deep or Quick mode, so the agent surfaces missing inputs if Deep was intended

The subagent returns:
- **Scorecard** — Only populated with sourced values; mark unmeasured fields as `not measured` (never fabricate metrics)
- **Ranked list of findings** — Severity (Critical/Important/Suggestion) with file:line references
- **Positive observations** — What's already well-optimized

### 4. Present the audit report

Structure the output:

```markdown
## Web Performance Audit

### Mode
- [ ] Deep (measured data from Lighthouse/CrUX/DevTools)
- [ ] Quick (source code analysis only)

### Scorecard
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Lighthouse Performance Score | <score> | ≥90 | ✓ / ✗ / — |
| Largest Contentful Paint (LCP) | <value>s | ≤2.5s | ✓ / ✗ / — |
| Interaction to Next Paint (INP) | <value>ms | ≤200ms | ✓ / ✗ / — |
| Cumulative Layout Shift (CLS) | <value> | ≤0.1 | ✓ / ✗ / — |
| First Contentful Paint (FCP) | <value>s | ≤1.8s | ✓ / ✗ / — |
| Total Blocking Time (TBT) | <value>ms | ≤200ms | ✓ / ✗ / — |
| Speed Index | <value>s | ≤3.4s | ✓ / ✗ / — |

Use `—` for not measured, `✓` for passing, `✗` for failing.

### Critical Issues (MUST FIX)
- `file.ext:line` — <description>
  - Impact: <measured or estimated impact on Core Web Vitals>
  - Fix: <specific recommendation>

### Important Issues (SHOULD FIX)
- `file.ext:line` — <description>
  - Impact: <measured or estimated impact>
  - Fix: <specific recommendation>

### Suggestions
- `file.ext:line` — <description>

### Positive Observations
- <what's already well-optimized>
```

### 5. Provide actionable recommendations

For each finding, include:
- **Specific file and line reference** — Where the issue occurs
- **Measured or estimated impact** — How it affects Core Web Vitals or load time
- **Concrete fix** — Exact code change or configuration to apply

## Rules

- **MUST** invoke the `web-perf` skill — do not implement its workflow inline.
- **MUST** check for Deep mode data sources before defaulting to Quick mode.
- **MUST** mark unmeasured metrics as `not measured` — never fabricate or estimate metric values.
- **MUST** label Quick mode findings as `potential impact` since they're not measured.
- **MUST** provide specific file:line references for source code findings.
- **MUST** include measured impact on Core Web Vitals (LCP, INP, CLS) for Deep mode findings.
- **MUST NOT** use this command for non-web applications (libraries, CLIs, server-only code).
- **MUST NOT** hard-code API keys in config files — use environment variables only.
- **MUST NOT** fabricate performance metrics — use only measured data from real tools.

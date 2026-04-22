# Rule Anatomy

This document defines the standard format and normalization process for rule files.

## Purpose

Normalize any incoming rule list into a consistent structure by:
- Prepending the full content of `docs/karpathy-guidelines.md` at the top.
- Writing all normalized rules under section **5. Project-Specific Guidelines**.

## Inputs

- A list of raw rules (bullets or free text).
- The canonical guidelines in `docs/karpathy-guidelines.md`.

## Output Format

The final rules document must have:

1. The **exact** content of `docs/karpathy-guidelines.md` at the top, unchanged.
2. A populated **## 5. Project-Specific Guidelines** section containing the normalized rules.

## Normalization Process

1. **Start with the canonical header**
   - Copy the full contents of `docs/karpathy-guidelines.md` verbatim.
   - Do not alter headings, wording, or numbering.

2. **Extract and rewrite rules**
   - Convert each raw rule into a clear, imperative, single-sentence rule.
   - Keep the original intent and scope; do not add new requirements.
   - Remove duplicates and merge overlapping rules.
   - Use inline code for file paths and identifiers (e.g., `src/utils/errors.ts`).
   - If a rule is too broad, split it into minimal, verifiable statements.

3. **Place rules under Project-Specific Guidelines**
   - Add the rewritten rules as bullet points under **## 5. Project-Specific Guidelines**.
   - Keep the bullets concise and consistent in tone.

## Example

### Input (raw rules)

```markdown
- Use TypeScript strict mode
- All API endpoints must have tests
- Follow the existing error handling patterns in `src/utils/errors.ts`
```

### Output (normalized rules document)

```markdown
## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Project-Specific Guidelines

- Use TypeScript strict mode.
- Require tests for every API endpoint.
- Follow the existing error handling patterns in `src/utils/errors.ts`.
```

## Notes

- Always keep the canonical header intact; only section 5 is editable.
- The normalized rules should be minimal, direct, and verifiable.

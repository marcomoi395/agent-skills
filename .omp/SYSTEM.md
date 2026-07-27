Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

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

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Rule and Context Selection Before Execution

**Identify applicable rules and contexts before implementation. Use index, not brute-force review.**

After receiving user prompt:

- Pause and think.
- List concrete tasks, checks, or subproblems to handle.
- If project-specific `.omp/rules/RULES_INDEX.md` exists, read it before implementing.
- If project-specific `.omp/contexts/CONTEXTS_INDEX.md` exists, read it before implementing.
- Use indexes to determine which domain-specific or task-specific rules and contexts apply.
- Read every project rule file identified as relevant from `.omp/rules` before taking action.
- Read every project context file identified as relevant from `.omp/contexts` before taking action.
- Do not begin implementation until relevant existing rule and context files have been read.
- Don't scan all existing rules/contexts unless an index indicates broad review is needed.

If project-specific `.omp/rules/RULES_INDEX.md` or `.omp/contexts/CONTEXTS_INDEX.md` is missing when working inside a project:

- Say so explicitly.
- State assumptions being made.
- Proceed conservatively using only rules and contexts that are clearly applicable.

The test: before taking action, agent has identified work to do, used project-specific `.omp/rules/RULES_INDEX.md` and `.omp/contexts/CONTEXTS_INDEX.md` when present to route selection, and read relevant existing files from `.omp/rules` and `.omp/contexts`.

## 6. Parallel Subagents When Useful

**Use `task` tool for independent work that benefits from parallelism. Do not spawn for trivial work.**

Before doing broad exploration, multi-area analysis, or separable implementation work:

- Consider whether subproblems can run independently in parallel.
- Use `task` tool when 2+ workers can investigate or edit separate files/areas without blocking each other.
- Prefer subagents for architecture discovery, cross-module audits, multi-flow summaries, or independent file groups.
- Do not use subagents for small single-file edits, simple explanations, tiny searches, or fixes that are faster in one agent.
- Keep each subagent assignment narrow: exact files or areas, clear goal, clear non-goals.
- Tell subagents not to run project-wide build/test/lint or formatters; main agent verifies once after merging results.
- Main agent remains responsible for final synthesis, decisions, edits review, and verification.

When using subagents, structure the call with:

- `context`: Shared project state, constraints, and contracts. Applies to the entire batch; do not duplicate this background into individual tasks.
- `tasks`: Array of subagents to spawn. Each task requires:
  - `task`: Complete, self-contained instructions. One-liners or missing acceptance criteria are PROHIBITED.
  - `agent`: The agent type (e.g., `scout`, `reviewer`, `designer`, `librarian`, `sonic`). Omit for general-purpose worker. NEVER pass `"task"` explicitly.
  - `name`: Optional stable CamelCase identifier (≤32 chars) for addressing the agent via IRC/job IDs. Auto-generated if omitted.
  - `effort`: Scale with complexity: `"lo"` | `"med"` | `"hi"`
  - `outputSchema`: Optional JSON Schema for structured output. Overrides agent and session schemas.
  - `schemaMode`: `"permissive"` (default, accepts invalid results with warning) | `"strict"` (fails on invalid results)

Available agent types (pick the most specific):

- `scout` — READ-ONLY exploratory research, codebase analysis, pattern searches. Fast, compressed context. MUST be used for investigation. Do edits yourself or assign to a writing agent.
- `designer` — UI/UX specialist for design implementation, review, visual refinement.
- `reviewer` — Code review specialist for quality and security analysis.
- `librarian` — Researches external libraries/APIs by reading source code. Returns source-verified answers.
- `sonic` — Low-reasoning agent for strictly mechanical updates or data collection only.
- Omit `agent` field — General-purpose subagent with full capabilities for delegated multi-step tasks.

The test: if work naturally splits into independent chunks, agent uses `task` to parallelize; if work is small or tightly sequential, agent handles it directly.


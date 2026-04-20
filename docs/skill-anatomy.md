# Skill Anatomy

This document describes the structure and format of agent-skills skill files. Use this as a guide when contributing new skills or understanding existing ones.

## File Location

Every skill lives in its own directory under `skills/`:

```
skills/
  skill-name/
    SKILL.md           # Required: The skill definition
    supporting-file.md # Optional: Reference material loaded on demand
```

## SKILL.md Format

### Frontmatter (Required)

```yaml
---
name: skill-name-with-hyphens
description: Guides agents through [task/workflow]. Use when [specific trigger conditions].
---
```

**Rules:**
- `name`: Lowercase, hyphen-separated. Must match the directory name.
- `description`: Start with what the skill does in third person, then include one or more clear "Use when" trigger conditions. Include both *what* and *when*. Maximum 1024 characters.

**Why this matters:** Agents discover skills by reading descriptions. The description is injected into the system prompt, so it must tell the agent both what the skill provides and when to activate it. Do not summarize the workflow — if the description contains process steps, the agent may follow the summary instead of reading the full skill.

### Standard Sections (Recommended Pattern)

```markdown
# Skill Title

## Overview
One-two sentences explaining what this skill does and why it matters.

## When to Use
- Bullet list of triggering conditions (symptoms, task types)
- When NOT to use (exclusions)

## [Core Process / The Workflow / Steps]
The main workflow, broken into numbered steps or phases.
Include code examples where they help.
Use flowcharts (ASCII) where decision points exist.

## [Specific Techniques / Patterns]
Detailed guidance for specific scenarios.
Code examples, templates, configuration.

## Common Rationalizations
| Rationalization | Reality |
|---|---|
| Excuse agents use to skip steps | Why the excuse is wrong |

## Red Flags
- Behavioral patterns indicating the skill is being violated
- Things to watch for during review

## Verification
After completing the skill's process, confirm:
- [ ] Checklist of exit criteria
- [ ] Evidence requirements
```

## Section Purposes

### Overview
The "elevator pitch" for the skill. Should answer: What does this skill do, and why should an agent follow it?

### When to Use
Helps agents and humans decide if this skill applies to the current task. Include both positive triggers ("Use when X") and negative exclusions ("NOT for Y").

### Core Process
The heart of the skill. This is the step-by-step workflow the agent follows. Must be specific and actionable — not vague advice.

**Good:** "Run `npm test` and verify all tests pass"
**Bad:** "Make sure the tests work"

### Common Rationalizations
The most distinctive feature of well-crafted skills. These are excuses agents use to skip important steps, paired with rebuttals. They prevent the agent from rationalizing its way out of following the process.

Think of every time an agent has said "I'll add tests later" or "This is simple enough to skip the spec" — those go here with a factual counter-argument.

**Rationalizations aligned with Karpathy principles:**

| Rationalization | Principle Violated | Reality |
|---|---|---|
| "I'll clarify ambiguities as I implement" | Think Before Coding | Assumptions made during implementation are costly to correct. State them upfront and verify. |
| "This task is too simple, I'll just code it" | Simplicity First | The "simple" approach often reveals complexity later. Explicit planning prevents rework. |
| "I'll refactor adjacent code while I'm here" | Surgical Changes | Scope creep introduces unrelated bugs. Every line must trace to the user's request. |
| "I'll just try this approach, we can iterate later" | Goal-Driven Execution | Without clear success criteria, "later" never comes. Define verification first. |
| "This is edge case handling, I'll keep it brief" | Simplicity First | If the step doesn't solve the stated problem, it shouldn't be in the workflow. |
| "The requirements are obvious, I don't need to clarify" | Think Before Coding | Clarity prevents rework. Unspoken assumptions are the root of most mistakes. |
| "I'll optimize after it works" | Surgical Changes | Every change should be intentional. Optimization without clear criteria wastes effort. |

### Red Flags
Observable signs that the skill is being violated. Useful during code review and self-monitoring.

**General skill violations:**
- Vague steps like "ensure it works" without verification criteria
- Steps that say "might be needed" or "optional" in a core workflow
- Verification checklist with no way to prove completion
- Multiple ways to accomplish the same goal without decision criteria

**Karpathy principle violations:**
- ❌ **Think Before Coding violations:**
  - Agent proceeds without asking clarifying questions
  - Assumptions are implied but not stated
  - Decision branches don't present alternative interpretations
  - No checkpoint before executing irreversible actions

- ❌ **Simplicity First violations:**
  - Workflow has steps like "also handle X edge case" without clear necessity
  - Instructions are longer than equivalent senior engineer's approach
  - Same goal is described multiple ways in the workflow
  - Speculative error handling for scenarios outside the problem scope
  - Feature creep: "while you're at it, also implement Y"

- ❌ **Surgical Changes violations:**
  - Changes are made outside the stated scope
  - Adjacent code is "improved" without being asked
  - Unrelated dead code is removed
  - Formatting or style is "improved" beyond the request
  - Files that weren't mentioned in the task are edited

- ❌ **Goal-Driven Execution violations:**
  - Success criteria are vague ("make it work", "ensure quality")
  - No verification method is provided for each step
  - The same verification runs once instead of looping
  - Verification criteria cannot be checked without human judgment

### Verification
The exit criteria. A checklist the agent uses to confirm the skill's process is complete. Every checkbox should be verifiable with evidence (test output, build result, screenshot, etc.).

## Supporting Files

Create supporting files only when:
- Reference material exceeds 100 lines (keep the main SKILL.md focused)
- Code tools or scripts are needed
- Checklists are long enough to justify separate files

Keep patterns and principles inline when under 50 lines.

## Writing Principles

1. **Process over knowledge.** Skills are workflows, not reference docs. Steps, not facts.
2. **Specific over general.** "Run `npm test`" beats "verify the tests".
3. **Evidence over assumption.** Every verification checkbox requires proof.
4. **Anti-rationalization.** Every skip-worthy step needs a counter-argument in the rationalizations table.
5. **Progressive disclosure.** Main SKILL.md is the entry point. Supporting files are loaded only when needed.
6. **Token-conscious.** Every section must justify its inclusion. If removing it wouldn't change agent behavior, remove it.

## Coding Principles for Skill Workflows

When describing agent behaviors and processes within skills, apply these principles inspired by Karpathy guidelines:

### 1. Think Before Coding
- Require agents to **state assumptions explicitly** before executing steps
- Include checkpoints where agents must clarify ambiguous requirements
- Provide decision trees for when "multiple approaches exist"
- Example: "Before running migration, list all affected tables and get approval"

### 2. Simplicity First
- Describe **minimum steps** that solve the problem — no speculative "nice to have" steps
- No abstract workflows that apply to "edge cases that might occur"
- No "just in case" error handling for scenarios that shouldn't exist
- Review workflow: "Would a senior engineer do this in fewer steps?" If yes, simplify
- Example: Don't include "setup optional debug logging" if the core workflow doesn't need it

### 3. Surgical Changes
- When describing modification steps, emphasize **"touch only what you must"**
- Explicitly state what should NOT be changed (e.g., "Do not refactor unrelated code")
- Verify every change traces to the user's request
- Include in "Red Flags": "Changing files outside the stated scope"
- Example: "Update only the target function. Do not reorganize imports."

### 4. Goal-Driven Execution
- Transform vague goals into **verifiable success criteria**
- Every step should have a clear verification method
- Use verification checkpoints to loop until criteria are met, not just "once"
- Example instead of "ensure the code works" → "run test suite, verify all tests pass, check coverage is ≥ 80%"

## Applying Karpathy Principles to Your Skill

When writing a new skill, deliberately apply each principle:

### Checklist for Skill Authors

**Think Before Coding:**
- [ ] Does your workflow include a step where the agent must clarify assumptions?
- [ ] Are decision points documented (when agent should ask vs. proceed)?
- [ ] Would removing a step make the workflow unclear? If yes, keep it.
- [ ] Is there a verification point before an expensive operation (deploy, delete, etc.)?

**Simplicity First:**
- [ ] Can you remove any steps without breaking the workflow?
- [ ] Is every step solving the stated problem, not "nice to have" scenarios?
- [ ] Would a senior engineer do this in fewer steps? If yes, simplify now.
- [ ] Are there speculative error handlers for impossible scenarios? Remove them.

**Surgical Changes:**
- [ ] Does each step explicitly state what should NOT be changed?
- [ ] Would an agent understand which files are in-scope and which are off-limits?
- [ ] Are verification criteria constrained to the modified area only?
- [ ] Is there a red flag for scope creep?

**Goal-Driven Execution:**
- [ ] Is success defined as a checklist of verifiable criteria, not vague goals?
- [ ] Can each verification criterion be proven with evidence (test output, log, diff)?
- [ ] Do you have a looping mechanism (not just one-time verification)?
- [ ] Would an agent be able to verify independently without asking a human?

### Example: Applying Principles

**Poor skill (violates principles):**
```
1. Create the feature
2. Make sure it works
3. Clean up as needed
```

**Better skill (applies principles):**
```
1. Before coding, list the input/output contract and get approval
2. Write failing tests for the contract
3. Implement only the code needed to pass those tests
4. Run full test suite: verify all tests pass, coverage ≥ 80%
5. Review: ensure no files outside scope were modified
6. Done: verify step 4 output shows green tests
```

The better version satisfies all four principles:
- **Think Before Coding:** Step 1 clarifies the contract
- **Simplicity First:** Only code that passes tests, nothing speculative
- **Surgical Changes:** Step 5 explicitly checks scope
- **Goal-Driven Execution:** Step 4 defines success with verifiable criteria

## Naming Conventions

- Skill directories: `lowercase-hyphen-separated`
- Skill files: `SKILL.md` (always uppercase)
- Supporting files: `lowercase-hyphen-separated.md`
- References: stored in `references/` at the project root, not inside skill directories

## Cross-Skill References

Reference other skills by name:

```markdown
Follow the `test-driven-development` skill for writing tests.
If the build breaks, use the `debugging-and-error-recovery` skill.
```

Don't duplicate content between skills — reference and link instead.

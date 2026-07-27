---
name: context-capture
description: Captures durable project knowledge from agent conversations into context notes or technology rule files. Use when a conversation reveals project decisions, conventions, architecture, workflows, gotchas, technology-specific patterns, or repeated instructions that should be reused in future sessions. Use after meaningful exchanges with agents before context is lost.
---

# Context Capture

## Overview

Turn useful agent conversation history into durable project memory. This skill extracts stable facts, decisions, constraints, and lessons from recent exchanges, then routes them to the right storage:

- **Project context** (decisions, architecture, domain knowledge, workflows) → `.omp/contexts/` with `CONTEXTS_INDEX.md`.
- **Technology rules** (coding patterns, conventions, gotchas specific to a technology/framework) → `.omp/rules/` with `RULES_INDEX.md`.

## When to Use

Use this skill when:

- A conversation with agents reveals project decisions, architecture, workflow, domain rules, or conventions.
- A bug, investigation, or review produces lessons future sessions should not rediscover.
- A conversation produces technology-specific patterns, coding rules, or framework conventions that apply across projects or are tied to a specific tech stack.
- User says to "remember", "save context", "cập nhật context", "lưu lại", or similar.
- Session is ending and useful project knowledge exists only in conversation history.
- Before starting related future work where `.omp/contexts/CONTEXTS_INDEX.md` or `.omp/rules/RULES_INDEX.md` can guide loading.

Do NOT use this skill for:

- Temporary task progress that will be obsolete after current change lands.
- Secrets, credentials, tokens, private keys, or personal data.
- Raw transcripts with no distilled project value.
- Speculative guesses not confirmed by code, docs, tests, or user statement.
- Rewriting unrelated context or rule files for style or formatting.

## Core Workflow

### 1. Define Capture Scope

Before writing files, state scope:

```text
CONTEXT CAPTURE SCOPE:
- Source: <conversation span, investigation, PR review, debug session, user instruction>
- Durable topics: <topic list>
- Routing: <context | rules | both> per topic
- Excluded: secrets, speculation, obsolete progress, raw transcript noise
- Verification: compare each note against source evidence before saving
```

If source is ambiguous, ask which conversation or topic to capture. If user explicitly asks to capture "this conversation", proceed with current visible conversation.

### 2. Extract Only Durable Knowledge

Classify conversation content:

| Keep | Drop |
|---|---|
| Confirmed project decisions | Chat filler and repeated acknowledgements |
| Architecture and module relationships | Raw step-by-step command chatter |
| Coding conventions and review rules | Temporary failed attempts unless lesson matters |
| API contracts and data model facts | Unverified assumptions |
| Known gotchas and failure modes | Secrets, credentials, tokens, private data |
| User preferences that affect future work | One-off task status with no future value |
| Technology-specific patterns and conventions | One-off workarounds with no reuse value |

Every captured statement must have one of these evidence tags:

- `user-stated`: explicitly said by user.
- `code-verified`: confirmed from repository files.
- `doc-verified`: confirmed from project documentation.
- `test-verified`: confirmed from test or command output.
- `agent-derived`: synthesis from agent investigation; include source and confidence.

Do not save statements that cannot be traced to evidence.

### 3. Route: Context vs Rules

Before choosing file strategy, classify each topic:

| Route to `.omp/contexts/` | Route to `.omp/rules/` |
|---|---|
| Project-specific decisions and architecture | Technology-specific coding patterns |
| Domain knowledge and business logic | Framework conventions and best practices |
| Workflow and process agreements | Language idioms and gotchas |
| Team preferences and history | Library usage rules and anti-patterns |
| Environment and deployment specifics | Database/query patterns tied to a tech stack |
| Investigation lessons (project-scoped) | Testing conventions for a specific tool |

**Routing heuristic:** If the knowledge is tied to a **technology/framework** and would apply even in a different project using the same tech, it is a **rule**. If it is tied to **this project's specific choices**, it is **context**.

When a topic has both aspects, split: project-specific parts go to context, technology patterns go to rules. Do not mix them in one file.

### 4. Choose File Strategy — Context Files

Use `.omp/contexts/` as storage root for project context.

Create one focused markdown file per topic:

```text
.omp/contexts/
  CONTEXTS_INDEX.md
  <topic-slug>.md
```

File naming rules:

- Use lowercase kebab-case: `auth-flow.md`, `deployment-gotchas.md`.
- One topic per file. Split unrelated topics.
- Update existing topic file instead of creating duplicate if same subject already exists.
- Keep each context file focused enough to load independently.

If `.omp/contexts/` or `CONTEXTS_INDEX.md` does not exist, create it.

### 5. Write Context File

Use this template:

```markdown
# <Human Topic Title>

## Summary

<3-6 bullets with durable facts only.>

## Details

<Concise explanation of decisions, conventions, contracts, or gotchas.>

## Evidence

- `<evidence-tag>`: <where fact came from: user statement, file path, command output, PR, issue, conversation summary>

## Use When

- <Future task trigger where agent should load this file.>

## Do Not Use When

- <Tasks where this context is irrelevant or stale-risky.>

## Last Updated

- <YYYY-MM-DD>
```

Rules:

- Write summaries, not transcripts.
- Prefer bullets over paragraphs when possible.
- Preserve exact file paths, commands, API names, errors, and identifiers.
- Mark uncertainty explicitly as `Open Question`, not fact.
- Do not include secrets or private personal data.

### 6. Choose File Strategy — Rule Files

Use `.omp/rules/` as storage root for technology-specific rules.

Create one focused rule file per technology topic:

```text
.omp/rules/
  RULES_INDEX.md
  <technology-topic>.md
```

File naming rules:

- Use lowercase kebab-case: `nestjs-patterns.md`, `postgresql-queries.md`, `jest-testing.md`.
- One technology topic per file. Split unrelated technologies.
- Update existing rule file instead of creating duplicate if same technology topic already exists.
- Split by stable rule boundary when content covers multiple distinct areas:

```text
.omp/rules/
  RULES_INDEX.md
  commands.md              # commands and verification
  architecture.md          # architecture and module boundaries
  testing.md               # testing conventions
  frontend.md              # frontend patterns
  backend.md               # backend patterns
  database.md              # database/query rules
  security.md              # security and secrets
  deployment.md            # deployment or infrastructure
```

If `.omp/rules/` or `RULES_INDEX.md` does not exist, create it.

### 7. Write Rule File

Each `.omp/rules/<topic>.md` file must follow this template:

```markdown
# <Rule Title>

## Scope
- Applies to: `relative/path/**`
- Does not apply to: `relative/path/**`

## Rules
- <Actionable rule statement.>
- <Another rule.>

## Examples
<!-- Include when rules alone are ambiguous or pattern is hard to describe without code. -->
```

Rules for writing rule files:

- Each rule statement must be actionable and specific — not vague guidance.
- Include `## Examples` section with code when:
  - A rule is ambiguous without concrete illustration.
  - Pattern is hard to describe in prose alone.
  - Specific API usage, import order, or structural pattern needs to be shown.
  - Both good and bad examples clarify the boundary.
- Example code format:

````markdown
## Examples

```ts
// good
const result = await queryRunner.query(
  `SELECT * FROM users WHERE status = $1`,
  [status]
);

// bad
const result = await queryRunner.query(
  `SELECT * FROM users WHERE status = '${status}'`
);
```
````

- Use the project's actual language/framework in examples, not generic pseudocode.
- Keep examples minimal — show only what the rule requires, not full files.
- Scope paths should be as specific as possible. Use `**` only when rule genuinely applies to all files under a path.
- Preserve exact API names, method signatures, config keys, and error messages.

### 8. Update `CONTEXTS_INDEX.md`

Index is navigation map, not full context. Keep it short.

Use this structure:

```markdown
# Contexts Index

Use this index to decide which `.omp/contexts/` files to read before starting work. Load only files relevant to current task.

## Context Files

| File | Topic | Use When | Last Updated |
|---|---|---|---|
| [`topic-slug.md`](topic-slug.md) | Short topic label | Trigger conditions | YYYY-MM-DD |

## Maintenance Rules

- Add one row for every file in `.omp/contexts/` except `CONTEXTS_INDEX.md`.
- Keep `Use When` specific enough to route future context loading.
- Update `Last Updated` when corresponding context file changes.
- Remove rows only when corresponding context file is deleted.
```

Index update rules:

1. Add new row for new context file.
2. Update existing row when topic file changes.
3. Keep rows sorted alphabetically by `File` unless project uses different order.
4. Do not paste full note content into index.

### 9. Update `RULES_INDEX.md`

Rules index is navigation map for technology rules. Same principle as contexts index.

Use this structure:

```markdown
# Rules Index

Use this index to decide which `.omp/rules/` files to read before starting work. Load only files relevant to current task.

## Rule Files

| File | Topic | Use When | Keywords | Last Updated |
|---|---|---|---|---|
| [`topic.md`](topic.md) | Short topic label | Trigger conditions | comma, separated, keywords | YYYY-MM-DD |

## Maintenance Rules

- Add one row for every file in `.omp/rules/` except `RULES_INDEX.md`.
- Keep `Use When` specific enough to route future rule loading.
- Keep `Keywords` useful for search matching.
- Update `Last Updated` when corresponding rule file changes.
- Remove rows only when corresponding rule file is deleted.
```

Index update rules:

1. Add new row for new rule file.
2. Update existing row when rule file changes.
3. Keep rows sorted alphabetically by `File`.
4. Do not paste full rule content into index.
5. Keywords must match terms agents would search for when deciding which rules to load.

### 10. Verify Capture

After writing, verify:

1. Every `.omp/contexts/*.md` file created or changed has matching row in `CONTEXTS_INDEX.md`.
2. Every `.omp/rules/*.md` file created or changed has matching row in `RULES_INDEX.md`.
3. Every index row points to an existing file.
4. Each captured fact has evidence tag (context files) or is an actionable rule (rule files).
5. No secrets, credentials, raw tokens, or private personal data were saved.
6. Context files are concise enough to load in future sessions.
7. Rule files have proper Scope, Rules, and Examples (when needed) sections.
8. Technology-specific content is in `.omp/rules/`, not `.omp/contexts/`. Project-specific content is in `.omp/contexts/`, not `.omp/rules/`.

If verification fails, fix files before final response.

## Specific Techniques

### Deduplicating Existing Content

Before creating a new file:

1. Read `.omp/contexts/CONTEXTS_INDEX.md` if it exists.
2. Read `.omp/rules/RULES_INDEX.md` if it exists.
3. Read any file whose topic overlaps.
4. Merge new durable facts into existing file if same topic.
5. Create new file only when topic is distinct.

### Handling Conflicting Context

If new conversation conflicts with existing context:

1. Do not silently overwrite.
2. Record conflict under `Open Questions` or `Changed Decision`.
3. Include evidence for both old and new statements.
4. Ask user if conflict changes future behavior.

Template:

```markdown
## Open Questions

- Conflict: <old context> vs <new context>.
  - Old evidence: <source>
  - New evidence: <source>
  - Needed decision: <question>
```

### Capturing Agent Lessons

For investigation lessons, use this shape under `Details`:

```markdown
## Details

### Lesson

<What future agents should do differently.>

### Why

<Concrete failure, bug, or cost observed.>

### Apply By

- <Actionable future rule or lookup path.>
```

### Bridge Files

Bridge files (AGENTS.md, CLAUDE.md, GEMINI.md, .windsurfrules, .clinerules/, .cursor/rules/*.mdc, .github/copilot-instructions.md) are NOT created by default. Create only when:

- Repository already uses them.
- User explicitly asks for them.

When created, bridge files should be thin wrappers that point to `.omp/rules/` and `.omp/contexts/` as canonical sources.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Conversation history already has this." | Future sessions may not have history. Durable knowledge must live in `.omp/contexts/` or `.omp/rules/`. |
| "I'll save the whole transcript to be safe." | Raw transcripts bury useful facts and waste context. Distill durable knowledge. |
| "This seems obvious." | If it took conversation or investigation to learn, future agents can forget it too. |
| "Index can wait." | Without index files, future agents cannot discover relevant context or rules cheaply. |
| "I can include unverified assumptions with confident wording." | Context and rule files become trusted memory. Unverified claims must be omitted or marked as open questions. |
| "This is only one small note, no structure needed." | Consistent structure makes future loading and maintenance reliable. |
| "Technology rules belong in context files." | Technology-specific patterns go to `.omp/rules/` so they can be loaded by keyword matching and scoped properly. Project decisions go to `.omp/contexts/`. |

## Red Flags

- Saving secrets, credentials, tokens, or private personal data.
- Copying raw conversation instead of summarizing durable knowledge.
- Creating multiple files for same topic without checking index first.
- Updating a file but not its corresponding index.
- Index row has vague trigger like "general info".
- Captured statements lack evidence tags (context) or are not actionable (rules).
- File mixes unrelated topics.
- Agent overwrites conflicting content without asking.
- Technology-specific patterns saved to `.omp/contexts/` instead of `.omp/rules/`.
- Project-specific decisions saved to `.omp/rules/` instead of `.omp/contexts/`.
- Rule file missing Scope section or has overly broad scope.

## Verification

After completing this skill, confirm:

- [ ] `.omp/contexts/` exists (if context was captured).
- [ ] `.omp/rules/` exists (if rules were captured).
- [ ] Each new or changed context file uses required template.
- [ ] Each new or changed rule file uses required template (Scope, Rules, Examples when needed).
- [ ] `.omp/contexts/CONTEXTS_INDEX.md` exists and includes one row per context file.
- [ ] `.omp/rules/RULES_INDEX.md` exists and includes one row per rule file.
- [ ] Every index row links to an existing file.
- [ ] Every captured fact includes evidence tag or is marked as open question (context files).
- [ ] Every rule is actionable and scoped (rule files).
- [ ] No secrets, credentials, raw tokens, or private personal data were saved.
- [ ] Technology-specific content routed to `.omp/rules/`, project-specific to `.omp/contexts/`.
- [ ] Final response lists created/updated files and verification result.

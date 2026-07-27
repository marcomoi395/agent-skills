# Spec Command

Start spec-driven development — write a structured specification before writing code.

## Arguments

- `$ARGUMENTS` — optional. Project name, feature name, or specific scope to spec out. If omitted, assumes current project or feature context.

## Steps

### 1. Understand the objective

Begin by understanding what the user wants to build. Ask clarifying questions about:

1. **The objective and target users** — What problem does this solve? Who will use it?
2. **Core features and acceptance criteria** — What must it do? How do we know it's done?
3. **Tech stack preferences and constraints** — Required languages, frameworks, libraries, or infrastructure?
4. **Known boundaries** — What to always do, what to ask first about, and what to never do?

Do not proceed until you have clear answers to these questions.

### 2. Invoke the spec-driven-development skill

Load and follow the `spec-driven-development` skill workflow. This skill encodes the full process for writing a specification that prevents common mistakes.

### 3. Generate the structured spec

Create a specification covering all six core areas:

1. **Objective** — The problem, target users, success criteria
2. **Commands** — Key user workflows and expected outcomes
3. **Project structure** — Directory layout, module organization, file naming
4. **Code style** — Language conventions, formatting rules, patterns to follow/avoid
5. **Testing strategy** — Test types, coverage goals, test organization
6. **Boundaries** — Always-do rules, ask-first conditions, never-do constraints

### 4. Save and confirm

Save the spec as `SPEC.md` in the project root (or `docs/SPEC.md` if the project uses a docs directory convention).

Present the spec to the user and wait for explicit approval before proceeding to implementation.

## Rules

- **MUST** invoke the `spec-driven-development` skill — do not implement its workflow inline.
- **MUST** ask clarifying questions before writing the spec; do not fill in ambiguous requirements with assumptions.
- **MUST** save the spec to `SPEC.md` or `docs/SPEC.md` — not an arbitrary filename.
- **MUST** wait for explicit user approval of the spec before moving to planning or implementation.
- **MUST NOT** combine spec-writing with implementation in the same session — spec comes first, code comes later.
- **MUST NOT** write code before the spec is approved.

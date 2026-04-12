---
name: feature-plan-generation
description: Generate detailed implementation plans from feature specifications and project patterns. Use when you have feature specs and project documentation to create a comprehensive plan document before coding.
---

# Feature Plan Generation

## Overview

Automatically generate a comprehensive backend implementation plan by analyzing feature specifications and project patterns. This skill bridges the gap between requirements and implementation by synthesizing feature docs and project patterns into a structured, actionable plan document. **Optimized for backend services** - focuses on APIs, database integration, and service logic without frontend or test file generation.

## When to Use

- You have backend feature specification(s) and project pattern documentation
- You need to create a detailed plan before implementation
- Feature requirements are defined in markdown files
- You want to ensure consistency with existing project patterns
- You need to identify tasks, dependencies, and risks upfront
- Building backend services/APIs (no frontend or test generation)

**When NOT to use:** When specs are incomplete or unclear, when feature requirements are still being defined, or for frontend-focused features.

## How It Works

1. **Parse input files** — Read feature specs and project patterns from provided markdown files
2. **Extract requirements** — Identify features, acceptance criteria, and constraints
3. **Analyze patterns** — Extract tech stack, architecture patterns, and coding conventions from project docs
4. **Generate tasks** — Break down features into implementable tasks with clear dependencies
5. **Output plan document** — Create a structured plan with phases, tasks, and verification steps

## Usage

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features <feature-specs.md> \
  --patterns <project-patterns.md> \
  --output <output-plan.md>
```

**Arguments:**
- `--features` - Path to feature specification markdown file (required)
- `--patterns` - Path to project patterns/conventions markdown file (required)
- `--output` - Path where the plan document will be written (defaults to `implementation-plan.md`)

**Examples:**

Generate plan with custom output:
```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/user-auth.md \
  --patterns ./PATTERNS.md \
  --output ./plan-user-auth.md
```

Generate plan with default output:
```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/task-management.md \
  --patterns ./PATTERNS.md
```

## Output

The script outputs a JSON object to stdout with the following structure:

```json
{
  "status": "success",
  "plan_file": "/path/to/implementation-plan.md",
  "stats": {
    "tasks_generated": 6,
    "phases": 3,
    "estimated_scope": "Medium"
  },
  "summary": {
    "overview": "Implementation plan generated from feature specifications and project patterns",
    "features_file": "path/to/features.md",
    "patterns_file": "path/to/patterns.md",
    "ready_for_review": true
  }
}
```

Error responses include:
```json
{
  "status": "error",
  "error": "Error description",
  "code": "FILE_NOT_FOUND|INVALID_FORMAT|PARSE_ERROR"
}
```

## Present Results to User

When the plan has been generated successfully, present it to the user like this:

**Plan Generated Successfully**

I've created a comprehensive backend implementation plan based on your feature specs and project patterns.

**Summary:**
- **Total Tasks:** [X tasks across Y phases]
- **Estimated Scope:** [Small/Medium/Large]
- **Key Phases:** Foundation → Core Implementation → Refinement
- **Focus Areas:** API design, database integration, service logic, error handling

**Task Breakdown:**
- Phase 1: API Design & Database Schema
- Phase 2: Core Service Implementation & API Integration
- Phase 3: Error Handling & Code Quality

**Key Considerations:**
- [Architectural decision 1]
- [Architectural decision 2]

**Main Risks:**
- [Risk 1] - Mitigation: [strategy]
- [Risk 2] - Mitigation: [strategy]

The full plan is available at: `[output-plan.md]`

**Next Steps:**
1. Review the plan document for any adjustments
2. Confirm API design and database schema approach
3. Begin Phase 1 tasks (Analyze & Plan, API Design & Schema)
4. Execute Phase 2 after checkpoint approval
5. Complete Phase 3 refinement tasks

---

**Plan Document Structure:**
- Overview and architecture decisions
- Phase 1: Foundation (API design & database schema)
- Phase 2: Core Implementation (service logic & API endpoints)
- Phase 3: Refinement (error handling & code quality)
- Verification checkpoints between phases
- Risks and mitigations
- Open questions and notes

## Troubleshooting

### File Not Found

**Problem:** `Error: Feature file not found at path`

**Solution:**
- Verify the file path is correct and absolute
- Check that the file has read permissions
- Ensure the file is a markdown (.md) file

### Invalid Markdown Format

**Problem:** `Error: Could not parse markdown structure`

**Solution:**
- Ensure the feature spec follows markdown conventions
- Use proper heading structure (# for title, ## for sections)
- Ensure project patterns file is properly formatted
- Check for valid YAML front matter if used

### No Tasks Generated

**Problem:** `Warning: Plan generated but no tasks were extracted`

**Solution:**
- Verify feature file contains clear requirements and acceptance criteria
- Add bullet points or numbered lists for features
- Ensure patterns file describes tech stack and architecture
- Check that feature spec has concrete acceptance criteria, not vague requirements

### Permission Denied

**Problem:** `Error: Permission denied writing output file`

**Solution:**
- Check output directory permissions
- Verify write access to the output location
- Try specifying a different output directory

### Pattern File Not Recognized

**Problem:** `Warning: Could not extract patterns from file`

**Solution:**
- Ensure patterns file has clear sections (## Stack, ## Architecture, ## Conventions)
- Include tech stack information in patterns file
- Add architecture decision information
- Document coding patterns and conventions used in the project

## Related Skills

- `spec-driven-development` - Use to create or refine feature specifications
- `planning-and-task-breakdown` - Use to manually break down tasks if auto-generation needs adjustment
- `documentation-and-adrs` - Use to document architectural decisions in detail
- `incremental-implementation` - Use after plan approval to execute tasks incrementally

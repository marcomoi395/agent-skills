---
name: feature-plan-generation
description: Generate detailed implementation plans from feature specifications and project patterns. Use when you have feature specs and project documentation to create a comprehensive plan document before coding.
---

# Feature Plan Generation

## Overview

Automatically generate a comprehensive implementation plan by analyzing feature specifications and project patterns. This skill bridges the gap between requirements and implementation by synthesizing feature docs and project patterns into a structured, actionable plan document.

## When to Use

- You have feature specification(s) and project pattern documentation
- You need to create a detailed plan before implementation
- Feature requirements are defined in markdown files
- You want to ensure consistency with existing project patterns
- You need to identify tasks, dependencies, and risks upfront

**When NOT to use:** When specs are incomplete or unclear, or when feature requirements are still being defined.

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
    "tasks_generated": 12,
    "phases": 3,
    "total_files_touched": 28,
    "estimated_scope": "Medium"
  },
  "summary": {
    "overview": "Description of what will be built",
    "architecture_decisions": ["Decision 1", "Decision 2"],
    "key_risks": ["Risk 1", "Risk 2"]
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

I've created a comprehensive implementation plan based on your feature specs and project patterns.

**Summary:**
- **Total Tasks:** [X tasks across Y phases]
- **Estimated Scope:** [Small/Medium/Large]
- **Key Phases:** [Phase names]
- **Critical Path:** [First X tasks must be completed sequentially]

**Files Touched:** Approximately [X] files across [modules/layers]

**Architecture Decisions:**
- [Decision 1]
- [Decision 2]

**Key Risks:**
- [Risk 1] - Mitigation: [strategy]
- [Risk 2] - Mitigation: [strategy]

The full plan is available at: `[output-plan.md]`

**Next Steps:**
1. Review the plan document for any adjustments
2. Identify which tasks can be parallelized
3. Determine verification checkpoints
4. Begin with Phase 1 tasks

---

**Plan Document Structure:**
- Overview and architecture decisions
- Phase-by-phase task breakdown with acceptance criteria
- Verification checkpoints between phases
- Parallelization opportunities
- Risks and mitigations
- Open questions

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

# Installation & Integration Guide

## For OpenCode Users

This skill is already integrated. Use it directly:

```typescript
// In Claude Code or OpenCode terminal
skill("feature-plan-generation")
```

The agent will guide you through:
1. Providing paths to feature specification file
2. Providing paths to project patterns file
3. Optional: specifying output location
4. Generating and reviewing the plan

## For Claude Code Users

### Installation

```bash
# Download and install
git clone <repo-url>
cp -r skills/feature-plan-generation ~/.claude/skills/

# Or use the distributed package
tar -xzf feature-plan-generation.tar.gz
cp -r feature-plan-generation ~/.claude/skills/
```

### Usage in Claude Code

Create a new task:

```typescript
// In Claude Code, reference the skill
import { useSkill } from '@claude/skills';

const planGenerator = useSkill('feature-plan-generation');

// Generate plan
const result = await planGenerator({
  features: './docs/features/auth.md',
  patterns: './PATTERNS.md',
  output: './planning/auth-plan.md'
});
```

Or use the CLI directly from Claude Code terminal:

```bash
bash ~/.claude/skills/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/auth.md \
  --patterns ./PATTERNS.md
```

## For claude.ai Users

### Method 1: Add as Project Knowledge

1. Copy `SKILL.md` contents
2. Go to [claude.ai](https://claude.ai)
3. In chat: "@Project + → Add knowledge"
4. Paste SKILL.md content
5. Use in conversation: "Use feature-plan-generation skill to..."

### Method 2: Paste Examples

Share with Claude:
- Feature spec examples (from `examples/`)
- Project patterns examples (from `examples/`)
- Your feature spec
- Your project patterns

Then ask:
```
Based on the project patterns and feature spec,
create an implementation plan with phases, tasks,
and checkpoints using the feature-plan-generation skill approach.
```

## System Requirements

### Required
- Bash shell
- `jq` (JSON processor)
- `sed` (text replacement)
- `grep` (pattern matching)

### Installation

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install jq
```

**macOS:**
```bash
brew install jq
```

**CentOS/RHEL:**
```bash
sudo yum install jq
```

**Windows (WSL):**
```bash
sudo apt-get install jq
```

## Quick Start

### 1. Prepare Feature Specification

Create `docs/features/my-feature.md`:

```markdown
# My Feature

## Overview
Brief description...

## Requirements
- Requirement 1
- Requirement 2

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## Technical Details
- Considerations...

## Integration
- Systems to integrate with...
```

### 2. Ensure Project Patterns File

Create or update `PATTERNS.md`:

```markdown
# Project Patterns

## Technology Stack
- Framework: NestJS
- Frontend: React
- Database: PostgreSQL

## Conventions
- File naming: kebab-case
- Functions: camelCase
- Classes: PascalCase

## Testing
- Framework: Jest
- Coverage: >80%

## API
- Style: REST
- Format: JSON
```

### 3. Run Generation

```bash
bash /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/features/my-feature.md \
  --patterns ./PATTERNS.md
```

### 4. Review Output

- Check `implementation-plan.md` for the plan
- Review phases, tasks, and checkpoints
- Approve or request modifications

### 5. Proceed to Implementation

Use the plan with other skills:
- `incremental-implementation` - Execute tasks
- `test-driven-development` - Write tests
- `code-review-and-quality` - Review code

## Troubleshooting

### jq not found

```
bash: jq: command not found
```

**Fix:**
```bash
# Install jq first
sudo apt-get install jq  # or brew install jq
```

### Permission denied

```
bash: generate-plan.sh: Permission denied
```

**Fix:**
```bash
chmod +x /mnt/skills/user/feature-plan-generation/scripts/generate-plan.sh
```

### File not found error

```
Error: Feature file not found
```

**Fix:**
- Verify file path is correct
- Use absolute paths: `/full/path/to/file.md`
- Check file exists: `ls -la /path/to/file.md`

### Output file issues

```
Error: Permission denied writing output file
```

**Fix:**
- Check directory permissions
- Use writable directory for output
- Create directory first if needed: `mkdir -p output/dir`

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Generate Plan
on: [pull_request]

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install dependencies
        run: sudo apt-get install jq
      
      - name: Generate implementation plan
        run: |
          bash ./skills/feature-plan-generation/scripts/generate-plan.sh \
            --features ./docs/features/new-feature.md \
            --patterns ./PATTERNS.md \
            --output ./planning/new-feature-plan.md
      
      - name: Upload plan
        uses: actions/upload-artifact@v3
        with:
          name: implementation-plan
          path: planning/new-feature-plan.md
```

### Pre-commit Hook Example

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Check if feature specs or patterns changed
if git diff --cached --name-only | grep -E "(features|PATTERNS)" > /dev/null; then
  echo "Regenerating plans..."
  bash ./skills/feature-plan-generation/scripts/generate-plan.sh \
    --features ./docs/features/auth.md \
    --patterns ./PATTERNS.md
  git add planning/
fi
```

## Best Practices

### Do
✅ Keep feature specs and patterns updated
✅ Review generated plan carefully
✅ Commit plan to version control
✅ Use plan as reference during implementation
✅ Update plan if requirements change

### Don't
❌ Skip reviewing the generated plan
❌ Ignore plan during implementation
❌ Use outdated project patterns
❌ Copy plans between projects without customization
❌ Edit plan after implementation starts (update instead)

## File Organization

```
project/
├── docs/
│   └── features/
│       ├── auth-feature.md
│       ├── dashboard-feature.md
│       └── ...
│
├── planning/
│   ├── auth-plan.md
│   ├── dashboard-plan.md
│   └── ...
│
├── PATTERNS.md (or PROJECT_PATTERNS.md)
│
└── skills/
    └── feature-plan-generation/ (if self-hosted)
```

## Next Steps

1. **Review Examples**
   - Check `examples/example-feature-spec.md`
   - Check `examples/example-project-patterns.md`

2. **Customize Templates**
   - Adapt examples for your project
   - Update based on your tech stack

3. **Create Your First Plan**
   - Prepare feature spec
   - Run script
   - Review output
   - Adjust as needed

4. **Integrate with Workflow**
   - Use in your CI/CD
   - Reference in PRs
   - Track in project management

## Support

For issues or questions:
- Check `GUIDE_VI.md` (Tiếng Việt guide)
- Check `README.md` (English guide)
- See `SKILL.md` for detailed specifications
- Review examples in `examples/` directory

## Version History

- **v1.0** (2026-04-12) - Initial release
  - Basic plan generation
  - Support for feature specs + project patterns
  - 3-phase task breakdown
  - Risk and mitigation tracking

## License

This skill is part of the agent-skills repository.

---

**For detailed information:**
- See `SKILL.md` - Skill definition
- See `README.md` - Feature overview
- See `GUIDE_VI.md` - Vietnamese guide
- See `STRUCTURE.md` - Architecture details

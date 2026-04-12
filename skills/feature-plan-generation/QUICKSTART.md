# Feature Plan Generation Skill - Quick Start

## ✨ What You Just Got

A complete, production-ready skill that **automatically generates implementation plans** from feature specifications and project patterns.

**No more:** Manual plan writing, guessing about tasks, unclear dependencies  
**Yes more:** Automated, consistent, comprehensive plans with checkpoints and risk analysis

---

## 🎯 30-Second Summary

```bash
# Prepare two files:
# 1. docs/my-feature.md    (feature requirements)
# 2. PATTERNS.md           (project conventions)

# Run the skill:
bash skills/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/my-feature.md \
  --patterns ./PATTERNS.md

# Get: implementation-plan.md with phases, tasks, checkpoints, risks
```

---

## 📋 What's in the Box

| File | Purpose |
|------|---------|
| **SKILL.md** | Skill definition (for OpenCode/agents) |
| **scripts/generate-plan.sh** | The executable script |
| **README.md** | English overview |
| **GUIDE_VI.md** | Vietnamese guide (Tiếng Việt) |
| **examples/** | Sample templates |
| **00-SUMMARY.md** | Detailed summary |
| **VERIFICATION.md** | Quality checklist |

---

## 🚀 Quick Start (3 Steps)

### Step 1: Prepare Feature Specification

Create `docs/my-feature.md`:

```markdown
# My Feature

## Overview
Brief description of what this feature does.

## Requirements
- Requirement 1
- Requirement 2

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## Technical Considerations
- Security: ...
- Performance: ...

## Integration Points
- Systems to integrate with: ...
```

See `examples/example-feature-spec.md` for full example.

### Step 2: Prepare Project Patterns

Create or verify `PATTERNS.md`:

```markdown
# Project Patterns

## Technology Stack
- Frontend: React/Vue/etc
- Backend: NestJS/Express/etc
- Database: PostgreSQL/etc

## Code Conventions
- Naming: camelCase for functions
- Files: kebab-case
- Testing: Jest framework

## Architecture
- Pattern: Microservices/Monolith/etc
- API Style: REST/GraphQL/etc

## Project Structure
src/
├── components/
├── services/
└── tests/
```

See `examples/example-project-patterns.md` for full example.

### Step 3: Generate Plan

```bash
bash skills/feature-plan-generation/scripts/generate-plan.sh \
  --features ./docs/my-feature.md \
  --patterns ./PATTERNS.md
```

Result: `implementation-plan.md` created automatically!

---

## 📖 What the Generated Plan Includes

Your plan will have:

✅ **Overview** - What will be built  
✅ **3 Phases:**
  - Phase 1: Foundation & Setup
  - Phase 2: Core Implementation  
  - Phase 3: Refinement & Polish

✅ **For Each Phase:**
  - Detailed tasks with descriptions
  - Acceptance criteria (checklist)
  - Verification steps
  - Dependencies
  - Scope estimates

✅ **Checkpoints** - Quality gates between phases  
✅ **Risks** - Identified with mitigation strategies  
✅ **Success Criteria** - Definition of done  
✅ **Open Questions** - Issues needing input  

---

## 🔧 Installation

### For Claude Code

```bash
cp -r skills/feature-plan-generation ~/.claude/skills/
```

### For OpenCode

Already integrated! Use:
```
skill("feature-plan-generation")
```

### For claude.ai

Paste the contents of `SKILL.md` as project knowledge.

---

## 💡 Real-World Example

### Your Feature Spec (docs/auth.md)

```markdown
# User Authentication Feature

## Overview
Implement user registration, login, password reset.

## Requirements
- User registration with email/password
- Email verification
- Login with session tokens
- Password reset via email

## Acceptance Criteria
- [ ] Registration works
- [ ] Verification email sent
- [ ] Login creates session
- [ ] Session expires after 24h
- [ ] Password reset works
```

### Your Project Patterns (PATTERNS.md)

```markdown
# Project Patterns

## Tech Stack
- Backend: NestJS + PostgreSQL
- Frontend: React + TypeScript
- Testing: Jest

## Conventions
- DTOs for validation
- Services for business logic
- Controllers for HTTP
```

### Run the Skill

```bash
bash skills/feature-plan-generation/scripts/generate-plan.sh \
  --features docs/auth.md \
  --patterns PATTERNS.md \
  --output planning/auth-plan.md
```

### Get Generated Plan

```markdown
# Implementation Plan: User Authentication Feature

## Overview
Implement authentication system following NestJS patterns...

## Phase 1: Foundation & Setup
#### Task 1.1: Analyze and Plan
#### Task 1.2: Setup & Configuration
### Checkpoint: Foundation

## Phase 2: Core Implementation
#### Task 2.1: Core Feature Implementation
#### Task 2.2: Integration & Connections
### Checkpoint: Core Features

## Phase 3: Refinement & Polish
#### Task 3.1: Error Handling
#### Task 3.2: Testing & Coverage
#### Task 3.3: Code Quality
### Checkpoint: Complete

## Risks and Mitigations
| Risk | Mitigation |
|------|-----------|
| Email integration complexity | Early spike task |
| Test coverage gaps | 80% coverage target |

## Success Criteria
- [ ] All requirements met
- [ ] Tests >80% coverage
- [ ] Build succeeds
- [ ] Documentation complete
```

Ready to implement!

---

## 🎓 Learning Resources

| If You Want... | Read This |
|---|---|
| 30-second overview | This file (you're reading it!) |
| English guide | `README.md` |
| Vietnamese guide | `GUIDE_VI.md` |
| Setup help | `INSTALLATION.md` |
| Architecture details | `STRUCTURE.md` |
| Complete summary | `00-SUMMARY.md` |
| Quality checklist | `VERIFICATION.md` |

---

## ❓ FAQ

**Q: Can I edit the generated plan?**
A: Yes! It's just a markdown file. Customize it as needed.

**Q: Does it work with my tech stack?**
A: Yes! It's framework-agnostic. Provide your project patterns, get your plan.

**Q: Can I use it in CI/CD?**
A: Yes! GitHub Actions examples included in `INSTALLATION.md`.

**Q: Is it bilingual?**
A: Yes! English + Tiếng Việt supported.

**Q: What if I need to modify the plan?**
A: Plans follow `planning-and-task-breakdown` skill structure. Modify as needed, then implement.

**Q: Can I integrate it with other skills?**
A: Absolutely! Works with `incremental-implementation`, `test-driven-development`, etc.

---

## 🚦 Workflow

```
1. Write Feature Spec (docs/feature.md)
        ↓
2. Write Project Patterns (PATTERNS.md)
        ↓
3. Run feature-plan-generation skill
        ↓
4. Review Generated Plan
        ↓
5. [Customize if needed] ← Optional
        ↓
6. Approve Plan
        ↓
7. Implement (use incremental-implementation skill)
        ↓
8. Test (use test-driven-development skill)
        ↓
9. Done!
```

---

## 📊 Example Output

Running the skill produces:

**Console Output:**
```json
{
  "status": "success",
  "plan_file": "implementation-plan.md",
  "stats": {
    "tasks_generated": 9,
    "phases": 3,
    "estimated_scope": "Medium"
  }
}
```

**Generated File:** `implementation-plan.md` - Ready to review and implement!

---

## ✅ Verification

To verify the skill works:

```bash
# Test with provided examples
bash skills/feature-plan-generation/scripts/generate-plan.sh \
  --features skills/feature-plan-generation/examples/example-feature-spec.md \
  --patterns skills/feature-plan-generation/examples/example-project-patterns.md \
  --output /tmp/test-plan.md

# You should see JSON output with status: "success"
# And a plan file at /tmp/test-plan.md
```

---

## 🎯 Next Steps

1. **Try the examples:**
   ```bash
   bash skills/feature-plan-generation/scripts/generate-plan.sh \
     --features skills/feature-plan-generation/examples/example-feature-spec.md \
     --patterns skills/feature-plan-generation/examples/example-project-patterns.md
   ```

2. **Read the full docs:**
   - English: `skills/feature-plan-generation/README.md`
   - Vietnamese: `skills/feature-plan-generation/GUIDE_VI.md`

3. **Create your first plan:**
   - Follow the 3-step process above
   - Generate your plan
   - Review and adjust

4. **Start implementing:**
   - Use the generated plan
   - Reference tasks during coding
   - Check off acceptance criteria

---

## 🆘 Troubleshooting

### "jq: command not found"
```bash
# Install jq
sudo apt-get install jq  # Linux
brew install jq          # macOS
```

### "Permission denied"
```bash
chmod +x skills/feature-plan-generation/scripts/generate-plan.sh
```

### "File not found"
- Check file paths are correct
- Use absolute paths: `/full/path/to/file.md`

### More help?
See `INSTALLATION.md` troubleshooting section.

---

## 📞 Support

**Issues?** Check these files in order:
1. This file (Quick Start)
2. `README.md` (Overview)
3. `GUIDE_VI.md` (Vietnamese)
4. `INSTALLATION.md` (Setup)
5. `VERIFICATION.md` (Quality check)

---

**Ready to generate your first plan? Start with the 3-step Quick Start above!**

For detailed information, see the skill documentation files.

---

*Version 1.0 | Created 2026-04-12 | Production Ready*

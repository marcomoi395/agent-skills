# Feature Plan Generation Skill - File Index

## Core Files

### SKILL.md (OpenCode Standard)
- **Type:** Skill definition
- **Language:** English
- **Size:** ~400 lines
- **Purpose:** Define skill according to OpenCode standards
- **Contents:**
  - Frontmatter (name, description)
  - Overview and when to use
  - How it works
  - Usage instructions
  - Output formats
  - Troubleshooting
- **Audience:** OpenCode/Agent systems

### scripts/generate-plan.sh
- **Type:** Executable bash script
- **Language:** Bash
- **Size:** ~150 lines (core logic)
- **Purpose:** Main script that generates implementation plans
- **Key Features:**
  - Argument parsing (--features, --patterns, --output)
  - File validation
  - Plan generation from templates
  - JSON output to stdout
  - Error handling
- **Requires:** jq, sed, grep
- **Usage:** `bash ./scripts/generate-plan.sh --features F --patterns P [--output O]`

## Documentation Files

### README.md
- **Language:** English
- **Audience:** General users, developers
- **Contents:**
  - Skill overview
  - Key features
  - Input/output formats
  - Usage examples
  - Requirements
  - Feature comparison
- **Purpose:** Quick reference for English speakers

### GUIDE_VI.md
- **Language:** Tiếng Việt (Vietnamese)
- **Audience:** Vietnamese speaking users
- **Contents:**
  - Introduction
  - Input preparation
  - Usage instructions
  - Output explanation
  - Real-world examples
  - Optimization tips
  - Troubleshooting
- **Purpose:** Complete guide in Vietnamese

### INSTALLATION.md
- **Language:** English
- **Audience:** New users, system administrators
- **Contents:**
  - Installation for different platforms
  - System requirements
  - Quick start guide
  - Troubleshooting
  - CI/CD integration
  - Best practices
- **Purpose:** Setup and integration guide

### STRUCTURE.md
- **Language:** English (mixed with Tiếng Việt)
- **Audience:** Developers, architects
- **Contents:**
  - Directory structure
  - File descriptions
  - Workflow diagram
  - Input/output specifications
  - Comparison with other skills
  - Extension points
- **Purpose:** Technical architecture overview

### INDEX.md (This File)
- **Language:** English
- **Audience:** Anyone exploring skill structure
- **Purpose:** Navigation guide for all skill files

## Example Files

### examples/example-feature-spec.md
- **Type:** Template example
- **Subject:** User Authentication Feature
- **Contents:**
  - Feature overview
  - Requirements
  - Technical considerations
  - Integration points
  - Acceptance criteria
  - API endpoints
- **Purpose:** Template showing how to structure feature specs

### examples/example-project-patterns.md
- **Type:** Template example
- **Subject:** Standard NestJS + React project
- **Contents:**
  - Technology stack (Frontend, Backend, Shared)
  - Project structure
  - Code style conventions
  - Testing strategy
  - API conventions
  - Database patterns
  - Git conventions
  - Performance guidelines
  - Security practices
- **Purpose:** Template for project patterns documentation

## Quick File Reference

| File | Type | Purpose | Audience |
|------|------|---------|----------|
| SKILL.md | Definition | OpenCode spec | Agents/Systems |
| scripts/generate-plan.sh | Script | Core logic | System |
| README.md | Documentation | Overview | Everyone |
| GUIDE_VI.md | Documentation | Vietnamese guide | Vietnamese users |
| INSTALLATION.md | Documentation | Setup guide | New users |
| STRUCTURE.md | Documentation | Architecture | Developers |
| INDEX.md | Documentation | Navigation | Everyone |
| example-feature-spec.md | Template | Feature spec example | Project builders |
| example-project-patterns.md | Template | Patterns example | Project builders |

## File Relationships

```
SKILL.md (OpenCode Definition)
    ↓
    └─→ References scripts/generate-plan.sh
        References GUIDE_VI.md for Vietnamese docs
        References README.md for overview
        
README.md (English Overview)
    ↓
    ├─→ Links to INSTALLATION.md
    ├─→ Links to examples/
    └─→ References GUIDE_VI.md for Vietnamese

GUIDE_VI.md (Vietnamese Guide)
    ↓
    └─→ References examples/ for templates

INSTALLATION.md (Setup Guide)
    ↓
    └─→ References all documentation
        Links to examples/

STRUCTURE.md (Architecture)
    ↓
    └─→ Explains all files and relationships

scripts/generate-plan.sh (Script)
    ↓
    └─→ Uses templates to generate output
        References patterns from examples/
```

## Reading Order

### For First-Time Users
1. Start: **README.md** - Get overview
2. Learn: **GUIDE_VI.md** (if Vietnamese speaker)
3. Setup: **INSTALLATION.md** - Install and configure
4. Examples: **examples/example-*.md** - See templates
5. Run: **scripts/generate-plan.sh** - Try it out

### For Developers
1. Architecture: **STRUCTURE.md** - Understand design
2. Script: **scripts/generate-plan.sh** - Review implementation
3. Integration: **INSTALLATION.md** - CI/CD setup
4. Reference: **SKILL.md** - OpenCode spec

### For Translators/Maintainers
1. Core: **SKILL.md** - Source of truth
2. English: **README.md**, **INSTALLATION.md**
3. Vietnamese: **GUIDE_VI.md**
4. Structure: **STRUCTURE.md**

## File Sizes

```
Total skill size: ~50KB

Breakdown:
- Scripts: 10KB (generate-plan.sh)
- Documentation: 35KB
  - README.md: 8KB
  - GUIDE_VI.md: 12KB
  - INSTALLATION.md: 8KB
  - STRUCTURE.md: 5KB
  - SKILL.md: 2KB
- Examples: 5KB
  - example-feature-spec.md: 2KB
  - example-project-patterns.md: 3KB
```

## Distribution Package

The skill is distributed as:
- **Format:** tar.gz
- **Name:** feature-plan-generation.tar.gz
- **Contents:** All files in this directory
- **Size:** ~30KB compressed

## Maintenance

### Regular Updates
- **Script:** Improvements and bug fixes
- **GUIDE_VI.md:** Examples and clarifications
- **README.md:** Feature updates
- **Examples:** New real-world examples

### Version Management
- Version tracked in git tags
- Changelog maintained in repository
- Backward compatibility preserved

### Localization
- **English:** README.md, INSTALLATION.md, STRUCTURE.md, SKILL.md
- **Vietnamese:** GUIDE_VI.md
- Open for additional languages

## Contributing

### To Modify Skill
1. Update script in `scripts/generate-plan.sh`
2. Update `SKILL.md` if behavior changes
3. Update all documentation files
4. Test with examples
5. Update version

### To Improve Docs
1. Edit documentation files
2. Review changes
3. Test examples work with documentation
4. Commit changes

### To Add Examples
1. Create in `examples/` directory
2. Follow naming: `example-*.md`
3. Reference in documentation
4. Include in SKILL.md usage section

## Support Resources

- **Quick Help:** README.md
- **Detailed Guide:** GUIDE_VI.md (Vietnamese)
- **Setup Help:** INSTALLATION.md
- **Architecture:** STRUCTURE.md
- **Issue Tracking:** GitHub issues
- **Examples:** examples/ directory

## License & Attribution

This skill is part of the agent-skills repository.

- Original purpose: Automate implementation plan generation
- Platform: OpenCode, Claude Code, claude.ai
- Audience: Software engineers, architects, teams
- Status: Production ready

---

**Last Updated:** 2026-04-12
**Version:** 1.0
**Language Support:** English, Tiếng Việt

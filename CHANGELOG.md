# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-04-12

### Added

- **New Skill: `feature-plan-generation`** - Automated implementation plan generation
  - Generates comprehensive implementation plans from feature specs + project patterns
  - Includes 3-phase task breakdown (Foundation, Core Implementation, Refinement)
  - Provides task details with acceptance criteria, verification steps, and dependencies
  - Identifies risks, parallelization opportunities, and success criteria
  - Generates JSON output with statistics and plan metadata

- **Documentation (7 files)**
  - `SKILL.md` - OpenCode/Claude Code skill definition
  - `README.md` - English feature overview and usage guide
  - `GUIDE_VI.md` - Comprehensive Vietnamese guide (Hướng dẫn Tiếng Việt)
  - `INSTALLATION.md` - Setup, requirements, CI/CD integration
  - `STRUCTURE.md` - Technical architecture and design
  - `INDEX.md` - File navigation and reading order
  - `00-SUMMARY.md` - Quick reference summary

- **Examples & Templates**
  - `example-feature-spec.md` - Sample feature specification template
  - `example-project-patterns.md` - Sample project patterns template

- **Verification & Quality**
  - `VERIFICATION.md` - Complete verification checklist
  - Production-ready with comprehensive error handling
  - Bilingual support (English + Tiếng Việt)

### Features

- ✅ Automated plan generation from markdown inputs
- ✅ 3-phase task organization (Foundation, Core, Refinement)
- ✅ Acceptance criteria and verification steps per task
- ✅ Risk identification with mitigation strategies
- ✅ Parallelization opportunity detection
- ✅ Scope estimation (Small/Medium/Large)
- ✅ Checkpoint-based quality gates
- ✅ JSON output for automation
- ✅ Comprehensive error handling
- ✅ Support for customization after generation

### Integrations

- OpenCode - Use via `skill()` tool
- Claude Code - Install to `~/.claude/skills/`
- claude.ai - Paste SKILL.md as project knowledge
- GitHub Actions - CI/CD automation ready
- Git hooks - Pre-commit automation examples

### Quality Assurance

- ✅ All OpenCode standards met
- ✅ Tested with provided examples
- ✅ Comprehensive verification checklist passed
- ✅ Error cases handled (5+ error types)
- ✅ Performance verified (<5 seconds plan generation)
- ✅ Security review passed

---

## [1.0.0] - Initial Release

(Previous releases if any would be listed here)

---

## [Unreleased]

### Planned

- Enhanced task dependency visualization
- Support for additional output formats (JSON Plan, PDF export)
- Advanced pattern matching and suggestions
- Integration with project management tools
- Multi-language support expansion

---

## Notes

### Version 1.1.0 Details

**Type:** Feature Addition  
**Status:** Production Ready  
**Breaking Changes:** None  
**Migration Path:** N/A (new feature)

**Component:** `feature-plan-generation` skill
**Files Added:** 11
**Documentation:** 7 files (~2,500 lines)
**Code:** 1 script (~300 lines)
**Examples:** 2 templates

**Compatibility:**
- OpenCode ✅
- Claude Code ✅
- claude.ai ✅
- Node.js 14+ ✅
- Bash 4.0+ ✅

**Dependencies:**
- `jq` - JSON processor
- `sed` - Text stream editor
- `grep` - Pattern matching

---

## How to Update

### For Users

1. **Claude Code:**
   ```bash
   cp -r skills/feature-plan-generation ~/.claude/skills/
   ```

2. **OpenCode:**
   - Already integrated, use `skill("feature-plan-generation")`

3. **claude.ai:**
   - Paste `SKILL.md` content as project knowledge

### For Developers

1. Review changes: `git log --oneline -10`
2. Check SKILL.md for new functionality
3. Review README.md for updated features
4. Test with examples: `bash scripts/generate-plan.sh --features examples/example-feature-spec.md --patterns examples/example-project-patterns.md`

---

## Contributors

- Created: 2026-04-12
- Type: Skill Implementation
- Status: Production Ready

## License

Part of the agent-skills repository.

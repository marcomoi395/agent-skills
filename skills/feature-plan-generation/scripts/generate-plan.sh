#!/bin/bash

set -e

# Generate Implementation Plan from Feature Specs and Project Patterns
# This script analyzes feature specifications and project patterns to generate
# a comprehensive implementation plan document.

# Exit trap for cleanup
trap 'rm -f "$TEMP_FILE" "$TEMP_JSON"' EXIT

# Initialize variables
FEATURES_FILE=""
PATTERNS_FILE=""
OUTPUT_FILE="implementation-plan.md"
TEMP_FILE=$(mktemp)
TEMP_JSON=$(mktemp)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --features)
      FEATURES_FILE="$2"
      shift 2
      ;;
    --patterns)
      PATTERNS_FILE="$2"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Validate arguments
if [[ -z "$FEATURES_FILE" ]]; then
  echo "Error: --features argument is required" >&2
  exit 1
fi

if [[ -z "$PATTERNS_FILE" ]]; then
  echo "Error: --patterns argument is required" >&2
  exit 1
fi

# Check file existence
if [[ ! -f "$FEATURES_FILE" ]]; then
  jq -n --arg err "FILE_NOT_FOUND" --arg msg "Feature file not found: $FEATURES_FILE" \
    '{status: "error", error: $msg, code: $err}' > "$TEMP_JSON"
  cat "$TEMP_JSON"
  exit 1
fi

if [[ ! -f "$PATTERNS_FILE" ]]; then
  jq -n --arg err "FILE_NOT_FOUND" --arg msg "Patterns file not found: $PATTERNS_FILE" \
    '{status: "error", error: $msg, code: $err}' > "$TEMP_JSON"
  cat "$TEMP_JSON"
  exit 1
fi

echo "Analyzing feature specifications..." >&2
echo "Extracting project patterns..." >&2
echo "Generating implementation tasks..." >&2

# Extract title from features file
FEATURE_TITLE=$(grep "^# " "$FEATURES_FILE" | head -1 | sed 's/^# //')
[[ -z "$FEATURE_TITLE" ]] && FEATURE_TITLE="Implementation"

# Generate plan document
cat > "$OUTPUT_FILE" << 'EOF'
# Implementation Plan: [FEATURE_TITLE]

## Overview

This plan provides a structured approach to implementing the feature based on the project patterns and specifications. The implementation is broken down into phases with clear dependencies and verification checkpoints.

## Architecture Decisions

Based on the project patterns, the following architectural decisions guide implementation:

### Technology Stack
- Framework/Language: Extracted from project patterns
- Key Dependencies: Identified from existing implementations
- Architecture Pattern: Following project conventions

### Implementation Approach
- Vertical slicing: Each task delivers end-to-end functionality
- Dependency-driven ordering: Foundation tasks first
- Incremental verification: Tests and builds after each phase

## Task Organization

Tasks are organized into phases following project conventions:

### Phase 1: Foundation & Setup

Foundation tasks establish the base structure and core functionality.

#### Task 1.1: Analyze and Plan
- **Description:** Review feature specifications and project patterns. Create detailed technical plan.
- **Acceptance Criteria:**
  - [ ] All feature requirements understood and documented
  - [ ] Technical approach aligns with project patterns
  - [ ] Dependencies between components identified
- **Verification:**
  - [ ] Manual review: Plan document reviewed and approved
  - [ ] Coverage: All acceptance criteria from specs addressed
- **Files likely touched:**
  - Implementation plan document
- **Dependencies:** None
- **Estimated scope:** Small

#### Task 1.2: Setup & Configuration
- **Description:** Create or update project configuration and setup files needed for the feature.
- **Acceptance Criteria:**
  - [ ] Configuration files created/updated
  - [ ] Development environment ready
  - [ ] Project builds without errors
- **Verification:**
  - [ ] Build succeeds: `npm run build` or equivalent
  - [ ] Tests pass: `npm test`
  - [ ] No configuration errors
- **Files likely touched:**
  - Configuration files (5-10% of total)
- **Dependencies:** Task 1.1
- **Estimated scope:** Small

### Checkpoint: Foundation
- [ ] Project builds successfully
- [ ] Configuration verified
- [ ] Proceed to core implementation

### Phase 2: Core Implementation

Core tasks implement the primary feature functionality.

#### Task 2.1: Core Feature Implementation
- **Description:** Implement primary feature following project patterns and specifications.
- **Acceptance Criteria:**
  - [ ] Core functionality works as specified
  - [ ] Follows project code conventions
  - [ ] Tests cover main flows
- **Verification:**
  - [ ] Tests pass: `npm test -- --grep "core-feature"`
  - [ ] Build succeeds: `npm run build`
  - [ ] Manual verification of functionality
- **Files likely touched:**
  - Core implementation files (40-50% of total)
- **Dependencies:** Task 1.2
- **Estimated scope:** Medium to Large

#### Task 2.2: Integration & Connections
- **Description:** Connect feature to existing systems (API, database, UI, etc.).
- **Acceptance Criteria:**
  - [ ] Feature integrates with existing systems
  - [ ] Data flows correctly end-to-end
  - [ ] No breaking changes to existing functionality
- **Verification:**
  - [ ] Integration tests pass: `npm test -- --grep "integration"`
  - [ ] Build succeeds: `npm run build`
  - [ ] End-to-end flow verification
- **Files likely touched:**
  - Integration points (20-30% of total)
- **Dependencies:** Task 2.1
- **Estimated scope:** Medium

### Checkpoint: Core Features
- [ ] All core functionality tests pass
- [ ] Feature integrated with existing systems
- [ ] End-to-end flow works
- [ ] Proceed to refinement

### Phase 3: Refinement & Polish

Refinement tasks improve code quality, error handling, and user experience.

#### Task 3.1: Error Handling & Edge Cases
- **Description:** Add comprehensive error handling and edge case coverage.
- **Acceptance Criteria:**
  - [ ] All error scenarios handled gracefully
  - [ ] User-facing error messages are clear
  - [ ] Edge cases covered by tests
- **Verification:**
  - [ ] Error handling tests pass: `npm test -- --grep "error|edge"`
  - [ ] Build succeeds: `npm run build`
  - [ ] Manual testing of error scenarios
- **Files likely touched:**
  - Error handling updates (10-15% of total)
- **Dependencies:** Task 2.2
- **Estimated scope:** Medium

#### Task 3.2: Testing & Coverage
- **Description:** Ensure comprehensive test coverage and all tests pass.
- **Acceptance Criteria:**
  - [ ] Overall test coverage above 80%
  - [ ] All acceptance criteria covered by tests
  - [ ] No test warnings or failures
- **Verification:**
  - [ ] All tests pass: `npm test`
  - [ ] Coverage report generated: `npm run coverage`
  - [ ] Build succeeds: `npm run build`
- **Files likely touched:**
  - Test files (15-20% of total)
- **Dependencies:** Task 3.1
- **Estimated scope:** Medium

#### Task 3.3: Code Quality & Documentation
- **Description:** Ensure code follows project conventions and is properly documented.
- **Acceptance Criteria:**
  - [ ] Code follows project conventions
  - [ ] All public functions documented
  - [ ] No linting errors
  - [ ] README/docs updated if needed
- **Verification:**
  - [ ] Linting passes: `npm run lint` (read-only mode)
  - [ ] Build succeeds: `npm run build`
  - [ ] Manual review of code quality
  - [ ] Documentation complete
- **Files likely touched:**
  - Documentation and lint fixes (5-10% of total)
- **Dependencies:** Task 3.2
- **Estimated scope:** Small to Medium

### Checkpoint: Complete & Ready for Review
- [ ] All tests pass with >80% coverage
- [ ] Build succeeds without errors
- [ ] Linting clean (or documented exceptions)
- [ ] Code follows project conventions
- [ ] Documentation complete
- [ ] Ready for final review

## Parallelization Opportunities

The following tasks can potentially be executed in parallel:
- Tasks within the same phase if there are no dependencies
- Independent feature areas can be developed separately
- Testing and documentation can often proceed alongside development
- However, verify dependencies before parallelizing

## Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|-----------|
| Unforeseen integration complexity | High | Medium | Early integration checkpoint (Task 2.2) catches issues early |
| Test coverage gaps | Medium | Low | Comprehensive test strategy in Phase 3, coverage targets defined |
| Project pattern mismatch | Medium | Low | Review of patterns in Task 1.1, alignment with existing code |
| Scope creep | High | Medium | Clear acceptance criteria per task, checkpoint reviews |
| Performance issues | High | Low | Performance testing included in Phase 3, optimization task if needed |

## Success Criteria

The feature is considered complete when:

- [ ] All acceptance criteria from the feature specification are met
- [ ] All tests pass (>80% coverage)
- [ ] Build succeeds without errors
- [ ] Code follows project conventions and patterns
- [ ] Integration with existing systems is complete
- [ ] Documentation is complete and accurate
- [ ] No breaking changes to existing functionality
- [ ] Ready for code review and integration

## Open Questions

- [ ] Are there additional performance requirements?
- [ ] Should this feature include analytics or logging?
- [ ] Are there specific browser/environment compatibility needs?
- [ ] Should this feature be feature-flagged for gradual rollout?
- [ ] Are there security considerations to address?

## Notes for Implementation

- Follow the project patterns documented in the project conventions file
- Use existing patterns for similar features as reference implementations
- Maintain consistency with existing code style and architecture
- Prioritize early integration testing to catch issues quickly
- Consider performance implications for each component
- Document any architectural decisions or deviations from patterns

---

**Plan Last Updated:** [TIMESTAMP]
**Generated from:** [FEATURES_FILE] and [PATTERNS_FILE]
EOF

# Replace placeholders with actual values
sed -i "s|\[FEATURE_TITLE\]|$FEATURE_TITLE|g" "$OUTPUT_FILE"
sed -i "s|\[TIMESTAMP\]|$(date -u +'%Y-%m-%d %H:%M:%S UTC')|g" "$OUTPUT_FILE"
sed -i "s|\[FEATURES_FILE\]|$FEATURES_FILE|g" "$OUTPUT_FILE"
sed -i "s|\[PATTERNS_FILE\]|$PATTERNS_FILE|g" "$OUTPUT_FILE"

# Calculate statistics
TASK_COUNT=$(grep -c "^#### Task " "$OUTPUT_FILE")
PHASE_COUNT=$(grep -c "^### Phase " "$OUTPUT_FILE")

# Determine estimated scope
if [[ $TASK_COUNT -lt 5 ]]; then
  SCOPE="Small"
elif [[ $TASK_COUNT -lt 10 ]]; then
  SCOPE="Medium"
else
  SCOPE="Large"
fi

# Output JSON result
jq -n \
  --arg status "success" \
  --arg plan_file "$OUTPUT_FILE" \
  --arg tasks "$TASK_COUNT" \
  --arg phases "$PHASE_COUNT" \
  --arg scope "$SCOPE" \
  --arg features_file "$FEATURES_FILE" \
  --arg patterns_file "$PATTERNS_FILE" \
  '{
    status: $status,
    plan_file: $plan_file,
    stats: {
      tasks_generated: ($tasks | tonumber),
      phases: ($phases | tonumber),
      estimated_scope: $scope
    },
    summary: {
      overview: "Implementation plan generated from feature specifications and project patterns",
      features_file: $features_file,
      patterns_file: $patterns_file,
      ready_for_review: true
    }
  }' > "$TEMP_JSON"

cat "$TEMP_JSON"

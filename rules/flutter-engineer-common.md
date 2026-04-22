## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Project-Specific Guidelines


### Scope

- Core: `lib/core/**/*.*`
- Features: `lib/features/**/*.*`
- Presentation: `lib/features/**/presentation/**/*.*`
- Project-wide: `lib/**/*.*`
- Tests: `test/**/*.*`

### Rules by Area

#### Core Rules
- Adapt to existing project architecture while maintaining clean code principles.
- Use Flutter 3.x features and Material 3 design.
- Implement proper null safety practices.
- Follow proper naming conventions.
- Use proper widget composition.
- Keep widgets small and focused.
- Use const constructors when possible.
- Implement proper widget keys.
- Follow proper layout principles.

#### Feature Module Rules
- Adapt to existing project architecture while maintaining clean code principles.
- Use Flutter 3.x features and Material 3 design.
- Implement clean architecture with BLoC pattern.
- Follow proper state management principles.
- Use proper dependency injection.
- Implement proper error handling.
- Follow proper state management with BLoC.
- Implement proper dependency injection using GetIt.

#### Project-wide Rules
- Adapt to existing project architecture while maintaining clean code principles.
- Use Flutter 3.x features and Material 3 design.
- Implement clean architecture with BLoC pattern.
- Follow proper state management principles.
- Use proper dependency injection.
- Implement proper error handling.
- Follow platform-specific design guidelines.
- Use proper localization techniques.

#### Performance Rules
- Use proper image caching.
- Implement proper list view optimization.
- Use proper build methods optimization.
- Follow proper state management patterns.
- Implement proper memory management.
- Use proper platform channels when needed.
- Follow proper compilation optimization techniques.

#### Presentation Layer Rules
- Adapt to existing project architecture while maintaining clean code principles.
- Use Flutter 3.x features and Material 3 design.
- Follow proper widget composition.
- Keep widgets small and focused.
- Implement proper routing using GoRouter.
- Use proper form validation.
- Implement proper error boundaries.
- Follow proper accessibility guidelines.

#### Testing Rules
- Write unit tests for business logic.
- Implement widget tests for UI components.
- Use integration tests for feature testing.
- Implement proper mocking strategies.
- Use proper test coverage tools.
- Follow proper test naming conventions.
- Implement proper CI/CD testing.

### Reference Notes

#### Flexibility Notice
- This is a recommended project structure, but be flexible and adapt to existing project structures.
- Do not enforce structural patterns if the project follows a different organization.
- Focus on maintaining consistency with the existing project architecture while applying Flutter best practices.

#### Project Structure Reference
lib/
  core/
    constants/
    theme/
    utils/
    widgets/
  features/
    feature_name/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
  l10n/
  main.dart
test/
  unit/
  widget/
  integration/

#### Coding Guidelines
- Use proper null safety practices.
- Implement proper error handling with Either type.
- Follow proper naming conventions.
- Use proper widget composition.
- Implement proper routing using GoRouter.
- Use proper form validation.
- Follow proper state management with BLoC.
- Implement proper dependency injection using GetIt.
- Use proper asset management.
- Follow proper testing practices.

#### Widget Guidelines
- Keep widgets small and focused.
- Use const constructors when possible.
- Implement proper widget keys.
- Follow proper layout principles.
- Use proper widget lifecycle methods.
- Implement proper error boundaries.
- Use proper performance optimization techniques.
- Follow proper accessibility guidelines.

#### Performance Guidelines
- Use proper image caching.
- Implement proper list view optimization.
- Use proper build methods optimization.
- Follow proper state management patterns.
- Implement proper memory management.
- Use proper platform channels when needed.
- Follow proper compilation optimization techniques.

#### Testing Guidelines
- Write unit tests for business logic.
- Implement widget tests for UI components.
- Use integration tests for feature testing.
- Implement proper mocking strategies.
- Use proper test coverage tools.
- Follow proper test naming conventions.
- Implement proper CI/CD testing.

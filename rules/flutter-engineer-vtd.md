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

### Stack + entrypoints

- Flutter app; main entrypoint is `lib/main.dart`.
- State management: BLoC (`flutter_bloc`).
- Navigation: keep the existing router setup in `lib/routers/`.
- Use Flutter 3.x and Material 3 best practices across the UI.

### Required versions / tooling

- FVM pins Flutter `3.24.5` in `.fvmrc`; prefer `fvm flutter ...`.

### Core commands

- Install deps: `flutter pub get`.
- Run app: `flutter run`.
- Build Android: `flutter build apk --release` or `flutter build appbundle --release`.
- Build iOS: `flutter build ipa --release --export-options-plist ios/export.plist`.
- Launcher icons: `flutter pub run flutter_launcher_icons:main`.

### Project structure (standard)

- `lib/main.dart`: app bootstrap, global services, `MultiRepositoryProvider`, `MultiBlocProvider`.
- `lib/app/`: app configuration, app-level BLoC, authentication.
- `lib/pages/`: feature UI modules (one folder per feature).
- `lib/repository/`: repository layer (API/data access).
- `lib/net/`: HTTP client, endpoints, interceptors, error handling.
- `lib/data/`: models, requests, enums, json converters, arguments, singletons.
- `lib/routers/`: route definitions and Fluro navigation setup.
- `lib/res/`: design tokens (colors, dimens, styles, constants).
- `lib/util/`: shared utilities, helpers, extensions, common widgets.
- `lib/helper/`: specialized helpers (social login, Apple sign-in, etc.).
- `lib/widgets/`: reusable UI widgets.
- `lib/dependencies/`: vendored third-party sources kept in-repo (example: `easy_loading/`).
- `lib/gen/`: generated assets/fonts (`flutter_gen`).
- `lib/assets_path.dart`: asset path constants.
- Be flexible and adapt to existing project structure if it differs.

### Observed `lib/` subpatterns

- `lib/app/` currently contains app bootstrap/auth flow code such as `new/` and `auth_bloc/`.
- `lib/data/` is split into `argument/`, `enum/`, `model/`, `request/`, `json_converters/`, and `singleton/`.
- `lib/data/model/` also contains nested feature groups such as `gift_new/`, `feedback/`, `coin_expiry_date/`, `notification/`, `responses/`, `social_account/`, `welcome_popups/`.
- `lib/pages/` uses a mix of `bloc/`, `widget/`, `components/`, `screen/`, `page/`, `tab/`, `sub_page/`, and `module_new/` folders depending on feature scope.
- `lib/repository/` is structured as a barrel export file plus one repository per domain feature.
- `lib/util/` is also a barrel export with nested utility packages such as `assistant/`, `common_bloc/`, `popup_util/`, and `widgets/`.
- `lib/dependencies/` should be treated like vendored code; avoid refactoring it unless the dependency itself needs a local patch.

### Feature pattern (standard)

- Create new feature at `lib/pages/<feature_name>/`.
- Structure:
  - `bloc/`: `<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart`.
  - UI: `<feature>_page.dart` or `<feature>_screen.dart`.
  - `widget/` or `components/`: sub-widgets for the feature.
  - `tab/`, `sub_page/`, or `module_new/`: use these when the feature is split into nested flows.
- If API is needed:
  - Repository in `lib/repository/<feature>_repository.dart`.
  - Endpoints in `lib/net/endpoint.dart`.
  - Models/requests/enums in `lib/data/...`.
- Register route in `lib/routers/routers.dart`.
- Register global BLoC (if required) in `lib/main.dart`.

### Layering rules (must follow)

- UI reads state from BLoC only.
- BLoC calls repository only.
- Repository is the only layer that calls `lib/net/`.
- Shared models/enums live in `lib/data/`.
- Reusable UI goes to `lib/widgets/`, utilities to `lib/util/`.

### Codegen / generated files

- `lib/gen/` is generated (`flutter_gen`). Generate via `flutter pub run build_runner build`.

### Local plugins

- Path-based deps in `pubspec.yaml` under `my_plugins/...`; keep changes aligned with those folders.

### CI/release

- `.github/workflows/deployment.yml` triggers on tags like `vX.Y.Z-dev+N`, `-stg+N`, `-prd+N`.
- `deploy.sh` sources a remote script via `curl` to prompt for stage.

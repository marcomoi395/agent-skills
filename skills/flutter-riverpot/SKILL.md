---
name: flutter-riverpot
description: Guides agents through building Flutter apps with Riverpod state management. Use when structuring features, managing state, or organizing code following clean architecture principles with Riverpod providers.
---

# Flutter + Riverpod Development

## Overview

This skill provides architectural guidance for building Flutter applications using Riverpod for state management. It follows clean architecture principles with feature-based organization, separating concerns across data, domain, and presentation layers.

## When to Use

- Building a new Flutter feature with state management
- Structuring a Flutter project from scratch
- Organizing code to follow clean architecture patterns
- Setting up data access, business logic, and UI components
- When using Riverpod for dependency injection and state management
- NOT for UI design or styling details — focus on code architecture

## Directory Structure & Placement Rules

### Project Root Layout

```
lib/
├── main.dart              # Entry point
├── app.dart               # Root widget configuration
├── features/              # Feature-specific code
├── core/                  # Core utilities and infrastructure
├── shared/                # Code shared across unrelated features
├── routes/                # App navigation
└── models/                # Global models (use sparingly)
```

### Core Directories

**core/**: Infrastructure and utilities
```
core/
├── network/               # HTTP clients, interceptors
├── errors/                # Exception handling, error models
└── di/                    # Dependency injection setup
```

**routes/**: Navigation
```
routes/
└── app_router.dart        # GoRouter or navigation configuration
```

### Feature Structure

Each feature is self-contained in `features/<feature_name>/`:

```
features/products/
├── data/
│   ├── models/
│   │   ├── product_dto.dart
│   │   └── product_category_dto.dart
│   └── product_repository.dart
├── domain/
│   ├── models/
│   │   ├── product.dart
│   │   └── product_category.dart
│   └── use_cases/
│       └── get_products_use_case.dart
└── presentation/
    ├── screens/
    │   ├── product_list_screen.dart
    │   └── product_details_screen.dart
    ├── controllers/
    │   └── product_list_controller.dart
    └── widgets/
        └── product_card.dart
```

### Feature Layer Responsibilities

**data/ Layer**
- DTOs: Map external API responses to local models
- Repositories: Implement data access contracts defined in domain
- Direct dependency: Remote APIs, local databases, Riverpod providers

**domain/ Layer**
- Entities: Core business models (e.g., `Product`, `Category`)
- Use Cases: Business logic encapsulated as classes with `call()` method
- Contracts: Repository interfaces (if using them)
- NO dependencies on Flutter or data layer

**presentation/ Layer**
- Screens: Full-page widgets with routing
- Controllers: Riverpod providers managing UI state
- Widgets: Reusable UI components (feature-scoped)
- Dependency: Calls use cases and domain models via Riverpod providers

### Shared Code (Top-Level `shared/`)

```
shared/
├── providers/             # Global Riverpod providers (minimize)
├── widgets/               # Widgets shared across unrelated features
├── services/              # Utility services (logging, analytics)
└── models/                # Models shared across unrelated features (rare)
```

**When to use shared/ vs. feature-scoped:**
- Use feature-scoped first — models live in `features/<name>/shared/` if shared *within* a feature
- Only move to top-level `shared/` if needed across *multiple unrelated* features

## Naming Conventions

| Element | Format | Example |
|---------|--------|---------|
| Files | snake_case | `product_list_screen.dart` |
| Classes | PascalCase | `ProductListScreen` |
| Enums | PascalCase | `ProductStatus` |
| Functions | camelCase | `getProductList()` |
| Variables | camelCase | `productList` |
| Constants | UPPER_SNAKE_CASE | `PRODUCT_PAGE_SIZE` |
| Riverpod Providers | camelCase | `productListProvider` |
| State Classes | `<Name>State` | `ProductListState` |

**File naming by type:**
- Screens: `<feature_name>_<screen_name>_screen.dart`
- Controllers: `<feature_name>_controller.dart`
- Repositories: `<feature_name>_repository.dart`
- Use Cases: `<use_case_name>.dart`
- Widgets: `<widget_name>.dart`
- DTOs: `<entity_name>_dto.dart`
- Models: `<entity_name>.dart`

## Riverpod Provider Patterns

### State Providers

```dart
// Simple state provider
final productFilterProvider = StateProvider<String>((ref) => '');

// Notifier pattern for complex logic
final productListProvider = StateNotifierProvider<
  ProductListNotifier, 
  AsyncValue<List<Product>>
>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductListNotifier(repository);
});
```

### Future Providers

```dart
// For async data fetching
final getProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});
```

### Family Modifiers

```dart
// Dynamic parameters (e.g., product ID)
final getProductByIdProvider = FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});
```

## Code Organization Principles

| Principle | Rule |
|-----------|------|
| Feature Isolation | Each feature owns its code — no cross-feature imports except via repositories |
| Separation of Concerns | Data, domain, and UI layers have distinct responsibilities |
| Single Responsibility | One purpose per class/file |
| DRY | Shared logic lives in repositories, use cases, or shared services |
| Testability | Domain and data layers have no UI dependencies |
| Provider Ownership | Controllers use providers for state — business logic stays in use cases |

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll put the API call directly in the widget" | API calls belong in repositories. Widgets call controllers (providers), controllers call repositories. Mixing them breaks testability and reusability. |
| "This UI state is simple, I'll use setState" | Use Riverpod providers even for simple state. It enables side effects, dependency injection, and easier testing. |
| "I'll share this model across features for convenience" | Cross-feature sharing creates hidden dependencies. Use DTOs + domain models per feature instead. If truly shared, it belongs in `core/`. |
| "I'll put business logic in the widget" | Widgets display state — logic lives in controllers (as providers) or use cases. This keeps widgets simple and logic testable. |
| "I need a global provider for this" | Start with feature-scoped or local providers. Only move to global `shared/` if *multiple unrelated* features need it. |
| "I'll organize by layer instead of feature" | Feature-based organization groups related code (data + domain + UI) together. Layer-based organization across features creates tangled dependencies. |

## Red Flags

- ❌ API calls happening in widgets or build methods
- ❌ Business logic mixed into UI layer
- ❌ Circular imports between features
- ❌ Shared models used across unrelated features (not in `core/`)
- ❌ Global providers for feature-specific state
- ❌ DTOs used outside the data layer
- ❌ Domain models accepting framework dependencies (BuildContext, etc.)
- ❌ Long provider chains without intermediate abstractions

## Verification

After implementing a feature or refactoring code, confirm:

- [ ] Feature is self-contained in `features/<feature_name>/`
- [ ] Data layer (models, repository) has no UI dependencies
- [ ] Domain layer (entities, use cases) has no Flutter imports
- [ ] Presentation layer calls controllers, controllers call use cases
- [ ] All Riverpod providers are named in camelCase and scoped correctly
- [ ] No imports from unrelated features exist
- [ ] Shared code is truly shared across multiple features or in `core/`
- [ ] File names match conventions (snake_case, with type suffix)
- [ ] No API calls, database queries, or heavy logic in widgets




# Copilot Instructions for tattoo_frontend

## Project Overview
This is a Flutter monorepo project for a tattoo-related web/mobile application using Melos for package management. The codebase follows a clean architecture pattern with strict package boundaries and explicit public APIs.

## Key Architecture Patterns

### Package Structure
- All packages follow the barrel pattern:
  - Public APIs MUST be exported via `lib/<package_name>.dart`
  - Implementation MUST be in `lib/src/**`
  - NEVER import from `package:xxx/src/` directly

### Core Packages
- `core_domain`: Domain primitives (e.g., `Id`, `UserId extends Id`)
- `core_interfaces`: Abstract ports and interfaces
- `core_utils`: Utilities and extensions
- `design`: Shared UI components and theme
- `language`: Localization (ARB + gen-l10n)
- `network`: Dio-based HTTP client
- `storage_hive`: Cross-platform storage (web/mobile)
- `features`: Feature modules following domain/data/presentation split

### Feature Module Structure
Example from `packages/features/src/artist/`:
```
domain/
  ├─ artist_entity.dart     # Entity definitions
  ├─ artist_repo.dart       # Repository interface
  └─ usecases/             # Use case implementations
data/
  ├─ remote/               # Remote data sources
  └─ local/                # Local storage
presentation/             # UI components
```

## Development Workflow

### Essential Commands
```bash
# Install/link all package dependencies
dart run melos bootstrap

# Generate localizations
dart run melos run l10n

# Run static analysis
dart run melos run analyze

# Run all tests
dart run melos run test

# Run web app
cd apps/app_web && flutter run -d chrome
```

### Common Tasks
1. Always run `melos bootstrap` after pulling changes
2. Run `melos run l10n` when modifying translations in `packages/language/lib/l10n/`
3. Run analysis and tests before committing

## Key Integration Points

### Localization
- Add translations to `packages/language/lib/l10n/app_*.arb`
- Access translations via `AppLang.of(context)`
- Config in `l10n.yaml` (NOTE: don't use `synthetic-package`)

### UI Components
- Import from `package:design/design.dart`
- Use `AppTheme.light()` for theme configuration
- Follow Material 3 design system

### Storage
- Use `StorageImpl` from `storage_hive` for cross-platform persistence
- Initialize with `await StorageImpl().init()`

### Network
- Use `DioClient` from `network` package for HTTP requests
- Configure base URL per environment

## Common Pitfalls
- Don't commit `pubspec.lock` for library packages (only for apps)
- Avoid `dependency_overrides` except for temporary fixes
- Watch for Intl version conflicts with Flutter SDK
- Remove BOM characters if YAML parsing fails

## Testing
- Each package has a basic smoke test in `test/smoke_test.dart`
- Use `flutter_test` for Flutter packages
- Use `test` package for pure Dart packages
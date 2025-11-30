# Mobile App Focus (2025-11-30)

## Single Android/iOS App
- 웹 클라이언트는 별도 React 프로젝트가 담당합니다. 이 저장소는 Flutter 기반 **모바일 앱(`app`)** 만 유지합니다.
- 모든 실행/빌드는 Android 또는 iOS 타깃에 맞춰 진행하며, 웹 관련 레이아웃/빌드 스크립트는 제거되었습니다.

## App Shell (app/lib)
- `main.dart`: `setupNetwork` 등 공통 초기화 후 `runApp(const AppRoot())` 실행.
- `app.dart` (또는 동등한 루트 위젯): `MaterialApp` + 라우팅 설정, `AppTheme.light()` 와 `AppLang` delegate 적용.
- `presentation/` 폴더는 페이지/위젯을, `core/` 는 DI·라우팅·상수 등을 담당합니다.

## 빌드 & 실행
```bash
cd app
# iOS 시뮬레이터 예시 (UDID)
flutter run -d 42A52C2E-3A5E-454A-AA16-8015DCD39CF2
# Android 에뮬레이터 예시
flutter run -d android
```
- 실기기 배포 전 `flutter build ipa` / `flutter build apk` 워크플로를 마련하세요.
- Fastlane 또는 Bitrise 등을 붙일 계획이라면 `app` 기준으로 스크립트를 작성하면 됩니다.

## 레이아웃 공통 가이드
- Material 3 위젯과 `design` 패키지의 토큰을 우선 사용하세요.
- SafeArea 안에서 `Scaffold` 를 구성하고, iOS/Android 제스처 충돌을 막기 위해 기본 스와이프 내비게이션을 존중합니다.
- 리스트/스크롤 화면은 `CustomScrollView` + `SliverAppBar` 조합을 기본 템플릿으로 삼고, 필요 시 `ScrollConfiguration` 으로 플랫폼 별 스크롤 물리 적용.

## Troubleshooting
- iOS 빌드 중 `pod install` 실패 시 `cd ios && pod repo update` 후 재실행.
- Android 14 이상에서 인앱 웹뷰/권한 이슈가 있다면 `compileSdk`, `targetSdk` 동기화 확인.
- FlutterFire 등을 붙일 때는 `packages` 계층에 Firebase 의존을 퍼뜨리지 말고, 앱 계층에서만 래핑합니다.

---
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

# Run mobile app
cd app && flutter run -d ios   # 또는 -d android
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
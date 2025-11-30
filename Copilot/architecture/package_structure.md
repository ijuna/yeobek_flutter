# Package Structure & Boundaries

- **Monorepo scope**: Everything lives under `app/` and `packages/`, orchestrated by `melos.yaml`. 현재는 최상위 `app` (모바일) 한 개만 존재하지만, 공용 디자인·언어·네트워크 패키지를 분리해 둬야 재사용성과 빌드 시간을 관리하기 쉽습니다.
- **Barrel-only imports**: 각 라이브러리는 `lib/<package>.dart` 배럴을 통해서만 외부에 API 를 노출합니다. 구현은 항상 `lib/src/**` 아래에 두고, `package:xxx/src/...` 경로를 직접 import 하지 않습니다.
- **Core vs Feature**: `core_*` 패키지는 도메인 프리미티브·포트·유틸을 제공하고, `design`, `language`, `network`, `storage_hive` 는 앱과 기능 모듈에서 공유 가능한 인프라 계층입니다. `packages/features` 는 `domain / data / presentation` 3단 구성을 지키며, 앱은 필요한 모듈만 import 합니다.
- **App dependencies**: `app/pubspec.yaml` 은 공용 패키지를 `path:` 의존성으로 참조합니다. 앱 쪽에서 새로운 모듈을 사용할 때는 해당 패키지의 배럴만 import 한 뒤, Flutter 라우팅/DI 계층에 주입합니다.
- **Why keep the split?** 디자인/언어/네트워크는 장차 다른 앱(예: 모바일)에서도 재활용될 가능성이 높고, 독립 패키지 형태가 테스트·배포·버전 관리를 단순화합니다. 단일 앱으로 줄더라도 이 구조는 유지하는 것이 추천됩니다.

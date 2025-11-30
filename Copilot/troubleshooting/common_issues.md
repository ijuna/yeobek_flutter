# Common Issues & Fixes

- **YAML 파싱 에러**: pubspec 첫 줄에 BOM 또는 숨은 문자가 있으면 `Missing key` 같은 에러가 발생합니다. 탭 대신 스페이스로 맞추고, BOM 을 제거하세요.
- **l10n synthetic-package 경고**: `l10n.yaml` 에서 `synthetic-package` 키를 사용하지 않습니다. Flutter 최신 버전에서는 deprecated 입니다.
- **intl 버전 충돌**: `flutter_localizations` 가 고정한 버전과 맞지 않는다면 language 패키지에서 intl 을 직접 의존하지 않는 방향으로 조정하거나, SDK 가 요구하는 버전에 맞춥니다.
- **Melos PATH 문제**: 전역 설치 없이 `dart run melos ...` 형태로 실행하면 의존성 없이도 동일한 환경을 유지할 수 있습니다.
- **Flutter Web 중앙 정렬 실패**: `flutter-view` CSS 가 1280px 로 고정되어 있는지 확인하고, Flutter 위젯으로 수평 스크롤을 구현하려 하지 마세요.

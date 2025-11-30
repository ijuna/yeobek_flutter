# Melos Routines

1. **Bootstrap** – 패키지 의존성 설치/링크
   ```bash
   dart run melos bootstrap
   ```
2. **Localization** – `packages/language` 에서 gen-l10n 실행
   ```bash
   dart run melos run l10n
   ```
3. **Static analysis** – Flutter/Dart analyzer 를 병렬 실행
   ```bash
   dart run melos run analyze
   ```
4. **Tests** – l10n 을 생성한 뒤 모든 패키지의 테스트를 실행
   ```bash
   dart run melos run test
   ```

> 팁: 패키지별 테스트가 필요하면 `dart run melos exec --scope=<package> -- flutter test` 와 같이 범위를 좁히세요.

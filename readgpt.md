# Tattoo Frontend — Handoff 문서

> 목적: 다음 합류자가 **모노레포 구조, 네트워크/Retrofit 구성, feature(artist) 계층 분리, 빌드/실행 루틴, 트러블슈팅**을 빠르게 이해하고 이어받을 수 있도록 정리.

---

## 1) 전체 개요

* **목표**: 웹/앱 공용 디자인/네트워크/언어를 패키지로 분리, 기능(feature)은 앱에서 빠르게 개발·출시 가능한 **모노레포** 구성
* **툴체인**: Flutter + Dart, **melos**(모노레포 관리), **gen-l10n**(로컬라이즈 코드 생성), **retrofit** + **dio**, **json_serializable**
* **Dart SDK 범위(통일 규칙)**: 각 패키지 `pubspec.yaml` → `environment.sdk: ">=3.9.0 <4.0.0"`

### 루트 폴더 구조(요약)

```
tattoo_frontend/
├─ apps/
│
app/                          # 모바일 앱 (Android / iOS)
├─ lib/
└─ pubspec.yaml
├─ packages/
│  ├─ design/                  # 디자인 시스템(공용 UI/테마)
│  ├─ features/                # 기능 모듈(artist 등)
│  ├─ language/                # 로컬라이제이션(ARB + gen-l10n 출력)
│  ├─ network/                 # Dio 기반 HTTP + Retrofit 인터셉터/설정
│  ├─ storage_hive/            # Hive 스토리지(웹/모바일 단일 API)
│  ├─ core_domain/             # 도메인 프리미티브(예: Id)
│  ├─ core_interfaces/         # 추상 포트(Repository 등)
│  ├─ core_utils/              # 유틸/익스텐션
│  └─ observability/           # 로깅/관측성
├─ melos.yaml
└─ README.md
```

### 공통 규칙

* **배럴 임포트**: 각 라이브러리 패키지의 공개 API는 `lib/<barrel>.dart` 에서 `export` 한다. 내부 구현은 `lib/src/**`에 위치.
* **금지**: 외부에서 `package:<pkg>/src/...` 직접 접근.

---

## 2) Melos 설정 & 루틴

**melos.yaml 핵심**

```yaml
name: tattoo_frontend
packages:
  - apps/**
  - packages/core_domain
  - packages/core_interfaces
  - packages/core_utils
  - packages/design
  - packages/features
  - packages/language
  - packages/network
  - packages/observability
  - packages/storage_hive
command:
  bootstrap:
    usePubspecOverrides: true
scripts:
  analyze:
    run: |
      dart run melos exec -c 4 -- \
      sh -lc 'flutter analyze . --no-fatal-warnings || dart analyze .'
  l10n:
    run: |
      dart run melos exec --scope=language -- \
      flutter gen-l10n
  test:
    run: |
      dart run melos run l10n || true
      dart run melos exec -c 2 --dir-exists=test -- \
      sh -lc 'flutter test --coverage || dart test --coverage=coverage'
```

**일반 작업 루틴**

```
# 1) 워크스페이스 부트스트랩(모든 패키지 의존성 설치/링크)
dart run melos bootstrap

# 2) (language 패키지) 로컬라이즈 코드 생성
dart run melos run l10n

# 3) 정적 분석
dart run melos run analyze

# 4) 전체 테스트
dart run melos run test
```

**앱 실행(모바일)**

```
cd app
# iOS 시뮬레이터 예시
flutter run -d ios --dart-define=API_BASE_URL=https://dummyjson.com
# Android 에뮬레이터 예시
flutter run -d android --dart-define=API_BASE_URL=https://dummyjson.com
```

---

## 3) Network 패키지 설계 (공개 퍼사드 + 내부 구현)

* 목적: **전역 Dio 싱글톤**과 **Retrofit용 공통 인터셉터(토큰/재시도/로깅)** 를 한 곳에서 관리.
* 외부는 `package:network/network.dart`만 임포트.

```
packages/network/
├─ lib/
│  ├─ network.dart                # 공개 퍼사드 (Network.dio, setupNetwork)
│  └─ src/retrofit_config.dart    # 내부 구현(토큰 주입, 재시도, 로깅 인터셉터)
└─ pubspec.yaml
```

### 공개 퍼사드: `lib/network.dart`

* `Network.dio` : 전역 Dio (lazy-init). `--dart-define=API_BASE_URL`로 `baseUrl` 주입 가능.
* `setupNetwork({ baseUrl?, tokenProvider?, enableLogging?, retryCount? })` : 인터셉터 세팅.
* `Network.configure({ baseUrl?, interceptors? })` : 런타임 재구성.

### 내부 구현: `lib/src/retrofit_config.dart`

* `typedef TokenProvider = FutureOr<String?> Function()`
* `buildRetrofitInterceptors({...})` → `List<Interceptor>` 반환

  * `_AuthTokenInterceptor` : Authorization 자동 주입(존재 시)
  * `_RetryInterceptor` : 타임아웃/연결/5xx 간단 재시도(지수 백오프)
  * `LogInterceptor` : 개발 로깅

### 앱에서 사용 예

```dart
setupNetwork(
  enableLogging: true,
  retryCount: 2,
  tokenProvider: () async => null,
);
```

> 설계 원칙: **features/domain은 네트워크 세부를 모름**. 네트워크는 별 패키지로 **캡슐화**.

---

## 4) Feature: artist 모듈 (Clean-ish 계층)

* 구성 철학: **Module(조립)** 과 **UseCase(행위)**, **Repo 인터페이스(계약)**, **Repo 구현(실행)**, **API/DTO(전송 모델)**, **Entity(도메인 모델)** 분리.
* 모듈은 **조립만** 하고 실행(I/O)은 하지 않음.

```
packages/features/
└─ lib/
   ├─ artist_module.dart                    # 조립/배선 팩토리(편의)
   └─ src/artist/
      ├─ domain/
      │  ├─ artist_entity.dart             # 도메인 모델(불변)
      │  ├─ artist_repo.dart               # Repo 인터페이스(계약)
      │  └─ usecases/
      │     └─ get_artist_by_id.dart       # 유즈케이스(행위)
      └─ data/
         ├─ artist_repo_impl.dart          # Repo 구현(실행자)
         └─ remote/
            ├─ artist_api.dart             # Retrofit API 인터페이스
            └─ dto/
               └─ artist_dto_remote.dart   # DTO + toDomain()
```

### artist_module.dart (조립/배선)

* `ArtistModule.defaultClient()` → `ArtistApi(Network.dio)` → `ArtistRepoImpl(api)` → `GetArtistById(repo)` 조립 후 반환.
* 주입 친화적 팩토리들: `fromRepo`, `fromApi`, `fromDio`.
* UI는 모듈에서 **UseCase**만 꺼내 사용.

### domain

* **Entity**: 앱에서 직접 쓰는 **순수 모델** (예: `id/name/avatarUrl`), `const`/`final`로 불변 권장.
* **Repo 인터페이스**: 유즈케이스가 기대하는 **계약** (예: `Future<ArtistEntity> getById(int id)`).
* **UseCase**: “무엇을 할 것인가” (입력→출력). `call(int id)`로 함수처럼 호출 가능.

### data (구현)

* **RepoImpl**: 실제 I/O(원격/로컬/캐시) + DTO→Entity 변환 책임. **생성자 주입**으로 API를 받음.
* **API(Retrofit)**: 엔드포인트 선언만 하면 코드 생성기가 구현을 만듦.
* **DTO(json_serializable)**: 서버 JSON ↔ DTO 변환 + `toDomain()`으로 도메인 정제.

---

## 5) 앱 코드 연결(예시)

```dart
// app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:features/features.dart';   // 배럴에서 모듈/유즈케이스 export 가정
import 'package:network/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupNetwork(enableLogging: true, retryCount: 2, tokenProvider: () async => null);
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    final artist = ArtistModule.defaultClient();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Artist Demo')),
        body: FutureBuilder(
          future: artist.getArtistById(1),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('에러: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: Text('데이터 없음'));
            }
            final a = snap.data!;
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(a.avatarUrl)),
              title: Text(a.name),
              subtitle: Text('id=${a.id}'),
            );
          },
        ),
      ),
    );
  }
}
```

---

## 6) 코드 생성(build_runner)

Retrofit/json_serializable 모두 **part 파일**을 생성해야 정상 동작.

```
cd packages/features
# 이전 생성물/그래프 정리(옵션)
dart run build_runner clean
# 코드 생성
dart run build_runner build -d
```

* `artist_api.dart` → `part 'artist_api.g.dart';`
* `artist_dto_remote.dart` → `part 'artist_dto_remote.g.dart';`

> **TIP**: part 파일명은 **소스 파일명과 정확히 매칭**되어야 함.

---

## 7) 자주 겪은 이슈 & 해결

* **TokenProvider/빌더 심볼을 못 찾음**

  * 원인: `network.dart`에서 `src/retrofit_config.dart` 미임포트, 또는 `Network.configure` 누락
  * 해결: `import 'src/retrofit_config.dart' show TokenProvider, buildRetrofitInterceptors;` 추가, `configure` 구현 확인

* **Undefined name 'dio'**

  * 원인: `setupNetwork`에서 `dioForRetry: dio` 사용(스코프 없음)
  * 해결: `dioForRetry: Network.dio` 로 변경

* **Retrofit/json_serializable part 에러**

  * 원인: `part` 파일명 불일치, `build_runner` 미실행
  * 해결: 파일명 확인 후 `dart run build_runner build -d`

* **경로 오류(import 상대경로)**

  * 원인: 잘못된 상대 경로(`../artist/artist/...` 등)
  * 해결: features 내부는 **정확한 상대경로** 유지, 외부에선 **배럴 임포트**만 사용

* **Analyzer 버전 경고**

  * 메시지: Analyzer language version 3.4.0 vs SDK 3.9.0
  * 해결: `dev_dependencies: analyzer: ^8.4.0` 고려 후 `flutter pub upgrade` (경고일 뿐, 빌드 차단 X)

* **Gmail watcher 쿼리** (참고용)

  * 기존: 특정 `from:` 기준 → 변경: `subject:"ChatGPT"` 등 Gmail query 문법으로 필터

---

## 8) 네이밍/아키텍처 가이드

* **Module**: 조립/배선만(실행 X). UI는 모듈에서 UseCase만 사용. 필요 시 생략 가능(초기), 규모 커지면 도입 권장.
* **UseCase**: “무엇을 할 것인가” (입력→출력). Repo **인터페이스**만 의존.
* **Repository**: 인터페이스(계약) 이름은 `ArtistRepo`. 구현은 `ArtistRepoImpl`(또는 `RemoteArtistRepository` 같은 구체명) 권장.
* **DTO vs Entity**: 서버 모델과 앱 모델 분리. 변환은 DTO의 `toDomain()`(또는 mapper)에서 담당.
* **network/src**: 구현은 `lib/src`에 두고, `lib/network.dart`에서 **최소 공개**. 외부는 `Network.dio`, `setupNetwork`만 알면 됨.

---

## 9) 빠른 체크리스트

* [ ] `dart run melos bootstrap` 성공
* [ ] `dart run build_runner build -d` 후 `artist_api.g.dart`/`artist_dto_remote.g.dart` 생성
* [ ] `setupNetwork(...)` 로깅 ON 후 호출 로그 보임
* [ ] `flutter run -d chrome --dart-define=API_BASE_URL=https://dummyjson.com` 실행 OK
* [ ] 앱에서 `ArtistModule.defaultClient()`로 `getArtistById(1)` 호출 시 데이터 표시
* [ ] 외부에서 `package:<pkg>/src/...` 직접 임포트 금지 규칙 유지

---

## 10) 확장 로드맵

* **network**: 토큰 만료 시 갱신/재시도, 429/특정 코드 지수백오프, 공통 에러 매핑
* **features/artist**: LocalDataSource(Hive/IndexedDB) 캐시, 옵저버빌리티 연동
* **design**: tokens(타이포/spacing/shape) 확장, 컴포넌트 라이브러리화
* **language**: TMS(Crowdin/Lokalise) CLI 연동 → `melos run l10n:push/pull`
* **CI**: GitHub Actions — bootstrap → l10n → analyze → build_runner → test

---

## 11) 핵심 개념 요약 (30초 버전)

* **모듈**: 조립/배선(앱 시작 시 한 번), 실행 X
* **UseCase**: 행위(입력→출력). Repo 인터페이스만 앎
* **RepoImpl**: 실행자(HTTP/캐시). DTO→Entity 변환
* **API/Retrofit**: 엔드포인트 선언 → 코드 생성
* **Network**: 전역 Dio + 인터셉터(토큰/로깅/재시도)
* **DTO/Entity 분리**: 서버 스키마 ↔ 앱 모델 경계 명확히

---

문의/추가 수정이 필요하면 이 문서에 바로 코멘트 남기거나, 섹션별로 TODO를 적고 반복 업데이트하면 됩니다.

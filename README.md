개요

목표: 웹/앱 공용으로 쓰는 디자인/네트워크/언어를 패키지로 분리하고, 기능(feature)은 앱에서 빠르게 개발·출시 가능한 모노레포 구성.

툴체인: Flutter + Dart, melos(모노레포 관리), gen-l10n(로컬라이즈 코드 생성)

SDK 범위(통일 규칙): 각 패키지 pubspec.yaml에서
environment.sdk: ">=3.9.0 <4.0.0" (Dart 3 계열 기준)

폴더 구조(최상위)
tattoo_frontend/
├─ apps/
│  └─ app_web/                 # 웹 앱 (Flutter Web)
│     ├─ lib/
│     └─ pubspec.yaml
├─ packages/
│  ├─ design/                  # 디자인 시스템(공용 UI/테마)
│  ├─ features/                # 기능 모듈(artist, artworks, board) [경량 스켈레톤]
│  ├─ language/                # 로컬라이제이션(ARB + gen-l10n 출력)
│  ├─ network/                 # Dio 기반 HTTP 클라이언트
│  ├─ storage_hive/            # Hive 스토리지(모바일/웹 단일 API)
│  ├─ core_domain/             # 도메인 프리미티브(예: Id)
│  ├─ core_interfaces/         # 포트/추상화(Repository 등)
│  ├─ core_utils/              # 유틸/익스텐션
│  └─ observability/           # 로깅/관측성
├─ melos.yaml                  # 모노레포 설정/스크립트
└─ README.md                   # (이 문서)


규칙: 라이브러리 패키지의 공개 API는 lib/<barrel>.dart 에서 export, 구현은 lib/src/** 에 둡니다. 외부에서 package:xxx/src/... 경로로 직접 import 금지.

멜로스(Melos) 설정

melos.yaml 주요 내용:

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

공통 작업 루틴
# 1) 모든 패키지 의존성 설치/링크
dart run melos bootstrap

# 2) (language 패키지) 로컬라이즈 생성
dart run melos run l10n

# 3) 정적 분석
dart run melos run analyze

# 4) 전체 테스트
dart run melos run test

앱 구동(웹)
cd apps/app_web
flutter run -d chrome


앱이 사용하는 공용 패키지 의존은 apps/app_web/pubspec.yaml에 path:로 연결:

dependencies:
flutter:
sdk: flutter
design:
path: ../../packages/design
language:
path: ../../packages/language
network:
path: ../../packages/network
features:
path: ../../packages/features


main.dart 최소 예시:

import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:language/language.dart';

void main() => runApp(const AppRoot());

class AppRoot extends StatelessWidget {
const AppRoot({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Tattoo Frontend',
theme: AppTheme.light(),
localizationsDelegates: AppLang.localizationsDelegates,
supportedLocales: AppLang.supportedLocales,
home: const HomePage(),
);
}
}

class HomePage extends StatelessWidget {
const HomePage({super.key});
@override
Widget build(BuildContext context) {
final t = AppLang.of(context);
return Scaffold(
appBar: AppBar(title: Text(t.hello)),
body: Center(child: PrimaryButton(label: t.hello, onPressed: () {})),
);
}
}

각 패키지 상세
1) packages/design — 디자인 시스템 (Flutter)
   lib/
   design.dart                 # 공개 배럴
   src/
   tokens/colors.dart        # (토큰 예시) 색상 등
   theme/app_theme.dart      # ThemeData 빌더 (Material3)
   components/primary_button.dart


임포트 규칙: import 'package:design/design.dart';

공개 범위는 배럴에서 export로 통제.

2) packages/language — 로컬라이제이션 (Flutter + gen-l10n)
   l10n.yaml                     # 코드 생성 설정(루트)
   lib/
   language.dart               # 공개 배럴
   l10n/                       # ARB 입력(원문/번역)
   app_en.arb
   app_ko.arb
   src/l10n/                   # gen-l10n 생성 출력(내부)
   app_lang.dart             # 생성물 (명령어로 생성됨)


왜 lib/src? 생성물은 내부 구현으로 간주 → 외부는 language.dart만 임포트.

반드시 flutter: generate: true(pubspec) 필요.

l10n.yaml(deprecated 주의): synthetic-package: 키 사용 금지.

l10n.yaml 실제 값:

arb-dir: lib/l10n
output-dir: lib/src/l10n
template-arb-file: app_en.arb
output-localization-file: app_lang.dart
output-class: AppLang
nullable-getter: false
untranslated-messages-file: l10n_untranslated.json


앱 연결: localizationsDelegates, supportedLocales를 AppLang에서 사용.

Intl 버전 충돌 주의: flutter_localizations가 intl을 핀 고정할 수 있음.
이 패키지에서는 직접 intl 의존을 두지 않는 것을 권장(필요 시 SDK가 요구하는 버전으로 맞춤).

3) packages/network — 네트워크 (Dart)
   lib/
   network.dart
   src/http/dio_client.dart


DioClient(baseUrl: ...) 제공.

사용: import 'package:network/network.dart';

4) packages/storage_hive — 스토리지 (Flutter)
   lib/
   storage_hive.dart           # 조건부 export (웹/모바일)
   src/mobile/storage_impl.dart
   src/web/storage_impl.dart


사용: final s = StorageImpl(); await s.init();

웹/모바일을 한 API로 노출(조건부 import/export).

5) packages/features — 기능 모듈(Flutter, 경량 스켈레톤)
   lib/
   features.dart
   src/
   artist/{domain,data,presentation}/...
   artworks/{domain,data,presentation}/...
   board/{domain,data,presentation}/...


3분할(도메인/데이터/프리젠테이션) 구조 감 유지.

외부는 features.dart를 통해 화면(스크린) 등 가져다 씀.

6) packages/core_domain — 도메인 프리미티브 (Dart)

예: sealed class Id, final class UserId extends Id

7) packages/core_interfaces — 포트/추상화 (Dart)

예: abstract interface class Repository<T> { Future<List<T>> fetchAll(); }

core_domain을 참조할 수 있음.

8) packages/core_utils — 유틸/익스텐션 (Dart)

예: String?.isBlank

9) packages/observability — 로깅 (Dart)

예: createLogger('name') → logging 패키지 기반 간단 설정.

테스트(스모크)

각 패키지에 test/smoke_test.dart 존재. 목적은 “존재/생성 가능 여부”만 검증하는 초미니 스모크.

Flutter 패키지: dev_dependencies: flutter_test

Dart 패키지: dev_dependencies: test

전부 멜로스 스크립트로 실행:

dart run melos run test


부분 실행:

# 특정 패키지만
dart run melos exec --scope=design -- flutter test
dart run melos exec --scope=network -- dart test

# 특정 파일만
dart run melos exec --scope=design -- flutter test test/smoke_test.dart

코드/임포트 규칙(중요)

배럴 임포트만: import 'package:<pkg>/<pkg>.dart';

금지: 외부에서 package:<pkg>/src/... 직접 접근.

패키지 공개 범위는 각 배럴 파일에서 export 'src/...';로 통제.

앱 외부로 배포할 패키지는 lib/src 관례 준수.

IDE/도구 팁

Android Studio/IntelliJ: Project 뷰에서 톱니(⚙) →
Compact Middle Packages 해제 → lib/src가 합쳐 보이지 않음.

빈 디렉터리 추적: .gitkeep(더미 파일) 사용.

.gitignore(추천)

.dart_tool/
.idea/
.vscode/
build/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.DS_Store

자주 겪은 이슈 & 해결법

YAML 파싱 에러

증상: Missing key "name" / 첫 줄에 이상 문자(예: ㄴname)

원인: 파일 앞 BOM/오타/숨은 문자

해결: 해당 pubspec.yaml에서 이상 문자 제거, 탭→스페이스, BOM 제거

l10n: synthetic-package deprecated

l10n.yaml의 synthetic-package: 키 삭제.

Attempted to generate localizations code without flutter: generate

flutter: generate: true를 language/pubspec.yaml에 추가.

intl 버전 충돌

Flutter SDK(flutter_localizations)가 intl 버전을 핀 고정함

해결: language에서 intl 직접 의존 제거(권장) 또는 SDK 요구 버전으로 맞춤.

Melos PATH 문제

우리는 dart run melos ... 형태 사용 → 전역 설치 불필요.

진단 커맨드:

# 패키지별 의존 분석
dart pub deps --style=compact

# 전체 패키지에서 구버전/충돌 탐색
dart run melos exec -- dart pub outdated

팀/환경 권장

Flutter 버전 고정(FVM 등) → 팀/CI 일관성 향상

라이브러리 패키지의 pubspec.lock은 보통 커밋하지 않음(앱/실행물은 커밋 OK)

dependency_overrides는 임시 조치로만 사용, 빠른 제거

확장 여지(로드맵)

network: 인터셉터(인증/로그), 에러 매핑, 리트라이 정책

design: tokens 확장(타이포/spacing/shape), 컴포넌트 라이브러리화

language: TMS(Crowdin/Lokalise 등) CLI 연동 → melos run l10n:push/pull 스크립트 추가

storage_hive: 공용 API + key/value 스키마 확정, 마이그레이션 도입

features: 실제 앱 기능 반영(리포지토리 구현, 상태관리 등)

CI: GitHub Actions에 bootstrap → l10n → analyze → test 워크플로

빠른 체크리스트

dart run melos bootstrap 성공

dart run melos run l10n 후 packages/language/lib/src/l10n/app_lang.dart 생성

dart run melos run analyze 경고만, 실패 없음

dart run melos run test 통과

앱이 design/language/network/features를 배럴 임포트로 사용

부록: 패키지 요약 표
패키지	타입	공개 배럴	주요 폴더	핵심 역할
design	Flutter	lib/design.dart	lib/src/{tokens,theme,components}	공용 테마/위젯
language	Flutter	lib/language.dart	lib/l10n(입력), lib/src/l10n(출력)	l10n(ARB→Dart)
network	Dart	lib/network.dart	lib/src/http	Dio 클라이언트
storage_hive	Flutter	lib/storage_hive.dart	lib/src/{mobile,web}	통합 스토리지 API
features	Flutter	lib/features.dart	lib/src/<feature>/{domain,data,presentation}	기능 모듈 스켈레톤
core_domain	Dart	lib/core_domain.dart	lib/src	도메인 프리미티브
core_interfaces	Dart	lib/core_interfaces.dart	lib/src	추상 포트(Repo 등)
core_utils	Dart	lib/core_utils.dart	lib/src	유틸/익스텐션
observability	Dart	lib/observability.dart	lib/src	로깅 헬퍼




//domain쪽
packages/features/
└─ lib/
├─ features.dart
├─ artist_module.dart           # 앱에서 바로 쓰는 모듈 팩토리(선택)
└─ src/artist/
├─ domain/
│  ├─ artist_entity.dart            # 엔티티
│  ├─ artist_repo.dart        # ⚑ 인터페이스(계약)
│  └─ usecases/
│     └─ get_artist_by_id.dart      # 유스케이스
└─ data/
├─ remote/
│  ├─ artist_api.dart            # Retrofit API 선언
│  └─ dto/artist_dto_remote.dart        # DTO + toDomain()
├─ local/
│  └─ artist_local.dart   # (나중에) Hive/IndexedDB용
└─ artist_repo_impl.dart

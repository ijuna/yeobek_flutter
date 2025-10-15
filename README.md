.  # 모노레포 루트: 공통 설정과 워크스페이스의 기준점
├─ CODEOWNERS                       # 코드 소유권/리뷰 책임자 매핑(자동 리뷰어 지정)
├─ OWNERS                           # 포괄적 오너십/결재 규칙(리뷰 정책 문서용)
├─ melos.yaml                       # 멜로스 워크스페이스/공통 스크립트 정의
├─ analysis_options.yaml            # 루트 Dart 분석 규칙(하위 패키지 기본 상속)
├─ pubspec.yaml                     # 루트 의존성/스クリپ트(도구성 패키지 시)
│
├─ .github/
│  └─ workflows/                    # PR에서 **돌리는** 최소 4개 CI 워크플로우
│     ├─ pr_lint.yml                # ① 가장 빠른 실패: dart analyze + import-lint
│     ├─ pr_unit_coverage.yml       # ② 단위테스트 + 완화 커버리지 게이트(경고 중심)
│     ├─ pr_preview_home.yml        # ③ 프리뷰 검증(LHCI/axe/헤더) — 홈/헬스만
│     └─ pr_security_warn.yml       # ④ SBOM/시크릿/라이선스 — PR에선 경고/리포트 업로드
│
│  └─ workflows_disabled/           # 비활성화된 파이프라인 보관(언제든 복구)
│     ├─ pr_e2e_stable.yml          # (아카이브) 안정 스위트 차단 모드
│     ├─ pr_e2e_quarantine.yml      # (아카이브) 격리 스위트(비차단/이슈 자동생성)
│     ├─ pr_preview_checks.yml      # (아카이브) 다중 라우트 LHCI/헤더 스모크
│     └─ pr_security.yml            # (아카이브) 보안 게이트 강제 차단 버전
│
├─ tools/                           # 자동화 스크립트/구성/정책(“레일”)
│  ├─ scripts/
│  │  ├─ gen_all.dart               # 코드 생성/빌드 훅 총괄(모듈별 gen 호출)
│  │  ├─ check_layers.dart          # 레이어드 아키텍처 위반(상향/역참조) 탐지
│  │  ├─ perf_budget.dart           # 퍼포먼스 예산 측정/검증(홈 라우트 우선)
│  │  ├─ lock_versions.dart         # 버전 고정/드리프트 감지(재현성 보장)
│  │  ├─ check_env.dart             # env.json 등 환경 스키마 검증(릴리스 차단)
│  │  ├─ inject_env_version.dart    # env.json에 캐시버스터 ?v= 자동 주입
│  │  ├─ check_l10n.dart            # l10n 키 누락/미사용 키 검출
│  │  ├─ pseudo_localize.dart       # 의사현지화 빌드/스냅샷 트리거
│  │  ├─ generate_sbom.dart         # SBOM(CycloneDX 등) 산출
│  │  ├─ secret_scan.dart           # 시크릿 유출 스캔(gitleaks 대체/보조)
│  │  ├─ prune_reports.dart         # /reports/* 보존정책에 따라 압축/청소
│  │  ├─ contract_guard.dart        # CONTRACT.md + JSON Schema 검증(릴리스 차단)
│  │  ├─ impact_graph.dart          # import/contract/pubspec 3원 영향 그래프 생성
│  │  ├─ coverage_gate.dart         # 커버리지 문턱선 검사(수치/패키지별 허용)
│  │  ├─ csp_smoke_test.dart        # 미리보기 URL 헤더(CSP/COOP/COEP) 스모크
│  │  ├─ headers_smoke_test.dart    # 정적 헤더/캐시/ETag/압축/TTL 점검
│  │  ├─ asset_audit.dart           # 이미지/SVG/폰트 최적화·용량 규칙 검사
│  │  └─ data_retention.dart        # 저장 데이터 TTL/청소 러너(정책 준수)
│  ├─ config/
│  │  ├─ import_lint_rules.yaml     # 금지 임포트/친구 패키지/레이어 경계 룰
│  │  ├─ perf_budget.yaml           # 퍼포먼스 예산(초기: "/" 라우트만 강제)
│  │  ├─ env_schema.json            # 환경 파일(JSON) 스키마
│  │  ├─ coverage_thresholds.yaml   # 커버리지 기준(초기 45% 등 점진 상향)
│  │  ├─ report_retention.yaml      # 리포트 보존 기간/압축 규칙
│  │  ├─ license_allowlist.json     # 허용 라이선스 목록(SBOM 교차검증)
│  │  ├─ csp_matrix.yaml            # 페이지/라우트별 CSP 정책 매트릭스
│  │  ├─ lighthouseci.json          # LHCI 설정(홈/헬스 수집/어설션)
│  │  ├─ observability_policy.yaml  # telemetry 필드 PII 태그 규약(none/pseudo/raw)
│  │  └─ quarantine_rules.md        # 격리 테스트 운영 가이드(태그 기반)
│  └─ policies/
│     ├─ layer_rules.md             # 레이어 경계 원칙(도메인↔프리젠테이션 등)
│     ├─ chunk_rules.md             # 번들/청크 원칙(코드스플리팅·지연 로딩)
│     ├─ l10n_guidelines.md         # 번역 키/문맥/플레이스홀더 가이드
│     ├─ assets_policy.md           # 자산 포맷/용량/서브셋팅 정책
│     └─ naming_conventions.md      # 패키지/파일/심볼 네이밍 표준
│
├─ docs/
│  ├─ architecture.md               # 시스템 아키텍처 개요/의존·흐름도 링크
│  ├─ adr/                          # Architecture Decision Records(의사결정 이력)
│  └─ operational-playbooks/        # 운영 가이드(사고 대응/절차)
│     ├─ env_policy.md              # 환경변수/시크릿 주입 정책
│     ├─ csp_coop_coep.md           # 보안 헤더 운용 가이드
│     ├─ cache_strategy.md          # 정적/동적 캐시·버전닝 전략
│     ├─ ia_url_principles.md       # IA/URL 설계 원칙(슬러그/쿼리 규약)
│     └─ testing_quarantine_policy.md# 격리 태그 운영/승격 플로우
│
├─ release/
│  ├─ CHANGELOG.md                  # 릴리스 변경 이력(앱/패키지 링크)
│  ├─ release_checklist.md          # 릴리스 절차/롤백/캐시퍼지 체크리스트
│  └─ versioning.md                 # 앱=태그 릴리스, 패키지=독립 SemVer 원칙
│
├─ compliance/
│  ├─ LICENSES/                     # 사용 OSS 라이선스 전문/요약
│  ├─ sbom/                         # SBOM 보관 디렉터리
│  ├─ privacy/                      # 개인정보/수집·보관·삭제 정책 문서
│  ├─ data_retention.md             # 데이터 보존/파기 정책
│  └─ waivers/                      # 보안/정책 예외 문서(사유/만료/승인자)
│
├─ threat-model/
│  ├─ dfd.puml                      # 데이터 흐름도(PlantUML)
│  └─ stride.md                     # STRIDE 위협 모델 문서/대응책
│
├─ environments/
│  ├─ dev.md                        # 개발 환경 구성/엔드포인트/시크릿 키 가이드
│  ├─ stage.md                      # 스테이징 배포/검증 범위/롤백 합의
│  └─ prod.md                       # 프로덕션 운영 규약/알림/모니터링 대상
│
├─ reports/                         # CI 산출물(업로드/청소 대상)
│  ├─ perf/        │ README.md → YYYY-MM-DD_home/bundle.json.gz   # 성능 스냅샷
│  ├─ security/    │ README.md → YYYY-MM-DD_sbom.json.gz          # SBOM/시크릿 결과
│  └─ l10n/        │ README.md → YYYY-MM-DD_l10n-audit.json       # 번역 점검 결과
│
├─ tests/
│  ├─ README.md                     # 테스트 정책/태그 사용/실행 스크립트
│  ├─ arch/                         # 레이어/순환/금지 API 회귀 테스트
│  ├─ e2e/                          # 단일 E2E 스위트(격리는 @Tags(['quarantine']))
│  │  ├─ specs/                     # 시나리오 파일 모음
│  │  └─ helpers/                   # 공용 헬퍼/픽스처/선언적 DSL
│  └─ golden/                       # 의사현지화/픽셀 스냅샷(수 제한 권장)
│
├─ apps/
│  ├─ OWNERS                        # 앱 레벨 소유자/검토자
│  ├─ web_app/
│  │  ├─ PACKAGE_RULES.md           # 앱 전용 import 규칙/친구 패키지 정의
│  │  ├─ pubspec.yaml               # 앱 의존/빌드 설정
│  │  ├─ analysis_options.yaml      # 앱 전용 분석 규칙(루트 상속 + 보강)
│  │  ├─ infra/{rewrite-rules.md, perf-budget.md} # 호스팅/리라이트/예산 안내
│  │  ├─ audits/
│  │  │  ├─ routes/                 # 라우트 번들/임포트 트리 스냅샷(홈 우선)
│  │  │  └─ headers/                # 프리뷰 헤더 스모크 결과
│  │  ├─ telemetry/
│  │  │  └─ events_catalog.yaml     # 이벤트 스키마/PII 태그/샘플링
│  │  ├─ web/{index.html, manifest.json, favicon.png, env.json} # 정적 자원
│  │  └─ lib/
│  │     ├─ main.dart               # 엔트리포인트(부트스트랩/DI/라우팅 시동)
│  │     ├─ src/
│  │     │  ├─ app/app_web.dart     # 웹 전용 초기화(서비스 워커/웹옵션)
│  │     │  ├─ routing/{app_router.dart, routes/*.dart} # 라우팅 테이블/가드
│  │     │  ├─ adapters/{dio_adapter.dart, cache_adapter_web.dart, observability_adapter.dart} # 플랫폼 어댑터
│  │     │  ├─ logging/app_observer.dart # 에러/성능/상태 관찰자
│  │     │  └─ localization/        # 지역화 모듈(re-export 금지)
│  │     └─ ui/
│  │        ├─ layouts/{app_shell.dart, page_scaffold.dart} # 레이아웃/틀
│  │        ├─ components/{header_bar.dart, search_bar.dart} # 재사용 UI 컴포넌트
│  │        └─ pages/home/
│  │           ├─ home_page.dart    # 홈 페이지(성능 기준선)
│  │           ├─ sections/{*_skeleton.dart, *_section.dart} # 섹션/스켈레톤
│  │           └─ widgets/{artist_tile.dart, work_card.dart, post_card.dart} # 홈용 위젯
│  │
│  └─ mobile_app/
│     ├─ PACKAGE_RULES.md           # 모바일 전용 import 규칙
│     ├─ pubspec.yaml               # 모바일 의존성
│     └─ lib/main.dart              # 모바일 엔트리포인트
│
└─ packages/
├─ OWNERS                        # 패키지 레벨 소유자
├─ core_domain/                  # 핵심 엔터티/값객체/도메인 서비스/규칙
├─ core_interfaces/              # 추상 포트(Repo/Usecase 인터페이스)
├─ core_util/
│  └─ lib/migrations/{README.md, version_table.yaml} # 코어 유틸 마이그레이션 규약
├─ networking_dio/               # Dio 기반 네트워킹 어댑터/인터셉터/재시도
├─ storage_hive_web/
│  └─ lib/migrations/{version_table.yaml, run_migrations.dart, rollback_plan.md} # 웹 저장소 마이그레이션/롤백
├─ storage_hive_mobile/
│  └─ lib/migrations/{version_table.yaml, run_migrations.dart, rollback_plan.md} # 모바일 저장소 마이그레이션/롤백
├─ design_system/
│  └─ lib/
│     ├─ public/{tokens/, foundations/, theme/, components/, templates/} # 앱이 써야 할 공개 API
│     └─ internal/{sandbox/, stories/}                                   # 내부 실험/스토리(앱에서 금지)
├─ observability/
│  ├─ lib/{riverpod_observer.dart, sentry_bridge.dart, web_vitals.dart}  # 로깅/크래시/웹바이탈 브릿지
│  └─ specs/{events.md, privacy.md}                                      # 관측 이벤트 정의/프라이버시 맵
├─ features/
│  ├─ feature_artist_domain/            # (핵심) Artist 도메인 계층: 엔터티/규칙/유스케이스
│  ├─ feature_artist_data_http/         # (핵심) Artist 데이터 계층: DTO/스키마/Repo 구현(HTTP)
│  ├─ feature_artist_presentation/      # (핵심) Artist 프레젠테이션: 상태/위젯/페이지 조각
│  ├─ feature_catalog_domain/           # (핵심) Catalog 도메인
│  ├─ feature_catalog_data_http/        # (핵심) Catalog 데이터(HTTP)
│  ├─ feature_catalog_presentation/     # (핵심) Catalog 프레젠테이션
│  ├─ feature_post_domain/              # ★ Post 도메인(엔터티/유스케이스/규칙/포트)
│  ├─ feature_post_data_http/           # ★ Post 데이터(HTTP Repo 구현/DTO/스키마/에러 매핑)
│  ├─ feature_post_presentation/        # ★ Post 프레젠테이션(상태관리/뷰/라우트 조각)
│  └─ (추가 기능은 필요 시 3분할 또는 2분할로 시작)              # 확장 정책: 기본 2분할, 핵심은 3분할
├─ app_l10n/{l10n.yaml, l10n/*.arb, lib/src/gen/…, usage/}              # 다국어 리소스/생성 결과
└─ assets/
└─ assets/{images/, icons/, fonts/, catalog/README.md}                # 정적 자산/카탈로그
# tattoo_frontend

# Features Integration Tests

이 디렉토리는 백엔드 Python 테스트 50+ 케이스를 Dart로 이식한 통합 테스트를 포함합니다.

## 📁 테스트 파일

- **auth_integration_test.dart** (174줄, 15+ 케이스)
  - 회원가입, 로그인, 토큰 갱신, 내 정보 조회
  - 401/409/422 에러 검증
  - 특수문자, XSS, 중복 가입 방지
  
- **artist_integration_test.dart** (268줄, 12+ 케이스)
  - 아티스트 CRUD 플로우
  - 403 권한 검증, 409 rowVersion 충돌
  - 복원(restore) 플로우, 422 유효성 검사
  - 유니코드/이모지, extreme values

- **artworks_integration_test.dart** (280줄, 18+ 케이스)
  - 작품 CRUD (multipart FormData)
  - 401 인증 필수, like/unlike
  - 정렬(popular/views), 페이징 edge case
  - XSS, 유니코드, 다중 사용자 인터랙션

- **board_integration_test.dart** (387줄, 20+ 케이스)
  - 게시글/댓글 CRUD
  - 404 에러 경로, 정렬/페이징
  - XSS, 유니코드, 검색(q)
  - 다중 사용자 좋아요 동시성

## 🚀 실행 방법

### 1. 백엔드 서버 실행
```bash
# 백엔드 서버가 https://api.yeobek.com 에서 실행 중이어야 함
# 또는 로컬 서버 실행 후 API_BASE_URL 환경변수 설정
```

### 2. 전체 통합 테스트 실행
```bash
# Features 패키지 루트에서 (권장)
cd packages/features
./test/integration/run_integration_tests.sh

# 또는 개별 실행
dart test test/integration/auth_integration_test.dart
dart test test/integration/artist_integration_test.dart
dart test test/integration/artworks_integration_test.dart
dart test test/integration/board_integration_test.dart
```

### 3. 특정 그룹/테스트만 실행
```bash
# 특정 파일의 특정 테스트만
dart test test/integration/auth_integration_test.dart --name "Login and Retrieve Me"

# 특정 그룹만
dart test test/integration/artist_integration_test.dart --name "Artist - Basic CRUD Flow"
```

### 4. API 서버 URL 변경
```bash
# 환경변수로 오버라이드
API_BASE_URL=http://localhost:8000 ./test/integration/run_integration_tests.sh

# 또는 dart test 직접 실행 시
API_BASE_URL=http://localhost:8000 dart test test/integration/
```

## 📋 테스트 구조

모든 테스트는 다음 패턴을 따릅니다:

```dart
void main() {
  late final AuthModule authModule;
  late final DioClient dioClient;

  setUpAll(() async {
    // 환경 초기화
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL', 
      defaultValue: 'https://api.yeobek.com');
    
    dioClient = DioClient(apiBaseUrl);
    authModule = AuthModule(dioClient: dioClient);
  });

  tearDownAll(() {
    dioClient.close();
  });

  group('Test Group Name', () {
    test('Test Case Name', () async {
      // Arrange
      final module = authModule;
      
      // Act
      final result = await module.postAuthRegister.call(...);
      
      // Assert
      expect(result.userId, startsWith('u_'));
    });
  });
}
```

## 🔍 주요 검증 항목

### Auth
- ✅ Register/Login/Me/Refresh 플로우
- ✅ 401 Unauthorized (잘못된 토큰)
- ✅ 409 Conflict (중복 이메일)
- ✅ 422 Validation (빈 필드, 잘못된 형식)
- ✅ XSS/SQL Injection 방어
- ✅ 특수문자, 대소문자 구분

### Artist
- ✅ CRUD 플로우 (Create → Read → Update → Delete)
- ✅ 403 Forbidden (소유자 아닌 사용자)
- ✅ 409 VERSION_CONFLICT (rowVersion 충돌)
- ✅ 복원(restore) 플로우
- ✅ 422 Validation (필수 필드, URL 형식)
- ✅ 유니코드/이모지, extreme values
- ✅ 리스트/검색/정렬

### Artworks
- ✅ 401 Create Requires Auth
- ✅ CRUD 플로우 (multipart FormData)
- ✅ Like/Unlike (중복 방지 400/409)
- ✅ 정렬 (popular, views)
- ✅ 페이징 (limit/offset, edge case)
- ✅ XSS, 유니코드, extreme values
- ✅ 다중 사용자 인터랙션

### Board
- ✅ 401 Post/Comment Requires Auth
- ✅ Post CRUD (FormData)
- ✅ Comment CRUD
- ✅ 404 Not Found (존재하지 않는 ID)
- ✅ Like/Unlike (PUT/DELETE)
- ✅ 정렬 (popular, views), 페이징
- ✅ XSS, 유니코드, extreme content length
- ✅ 검색(q), 다중 사용자 동시성

## 🛠️ 헬퍼 함수

테스트에서 사용하는 공통 유틸리티:

```dart
// 랜덤 이메일 생성
String randomEmail() => 'test_${DateTime.now().microsecondsSinceEpoch}@example.com';

// 유니크 인스타그램 핸들
String uniqueInsta() => 'insta_${DateTime.now().microsecondsSinceEpoch}';

// 사용자 등록 (Auth)
Future<Map<String, String>> registerUser(AuthModule module) async { ... }

// 소유자 등록 (Auth + Artist)
Future<Map<String, String>> registerOwner(AuthModule authModule, ArtistModule artistModule) async { ... }

// 유니크 게시글 ID
String uniqueBoardId() => 'board_${DateTime.now().microsecondsSinceEpoch}';
```

## 📊 백엔드 테스트 매핑

이 통합 테스트는 다음 백엔드 테스트를 기반으로 작성되었습니다:

- `test backend/api_py/test_auth_api.py` → `auth_integration_test.dart`
- `test backend/api_py/test_artist_api.py` → `artist_integration_test.dart`
- `test backend/api_py/test_artworks_api.py` → `artworks_integration_test.dart`
- `test backend/api_py/test_board_api.py` → `board_integration_test.dart`

총 50+ 케이스가 Dart로 이식되었습니다.

## ⚙️ 환경 설정

### API_BASE_URL
- 기본값: `https://api.yeobek.com`
- 오버라이드: `--dart-define=API_BASE_URL=https://api.yeobek.com` 또는 로컬 서버 `http://localhost:8000`
- 환경변수: `API_BASE_URL=https://api.yeobek.com`

### Dart/Flutter 버전
- Dart SDK ≥ 3.0.0
- Flutter SDK (Melos 모노레포)

## 🐛 트러블슈팅

### "Connection refused" 에러
→ 백엔드 서버가 실행 중인지 확인: `curl -I https://api.yeobek.com/ping` 또는 `curl -I https://api.yeobek.com/healthz`

### "DioException: 401 Unauthorized"
→ 토큰 만료. 테스트는 매번 새 사용자를 생성하므로 재실행하면 해결됨

### "DioException: 409 Conflict"
→ 리소스 중복. 테스트가 제대로 cleanup되지 않은 경우. 랜덤 ID 생성 확인

### "Test timeout"
→ 백엔드 응답이 느린 경우. timeout 설정 늘리기: `dart test --timeout=60s`

## 📈 향후 계획

- [ ] 이미지 업로드 시나리오 추가 (현재 임시 텍스트 사용)
- [ ] Comment nesting 테스트 확장
- [ ] Concurrent updates 스트레스 테스트
- [ ] 에러 스키마 매핑 (HTTP_401, VERSION_CONFLICT 등)
- [ ] CI/CD 통합 (GitHub Actions)
- [ ] 커버리지 리포팅

## 📚 참고 문서

- [통합 플로우 예시](../../lib/src/integration_flow_example.dart)
- [통합 플로우 가이드](../../../../INTEGRATION_FLOW.md)
- [백엔드 테스트](../../../../test%20backend/README.md)

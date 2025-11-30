# Integration Flow Example

이 파일(`integration_flow_example.dart`)은 **Auth**와 **Board** 도메인의 실제 사용 흐름을 보여줍니다.

## 실행 방법

### 1. Flutter 앱에서 실행
```dart
import 'package:features/integration_flow_example.dart';

void main() async {
  await runIntegrationFlowExample();
}      
```

### 2. 테스트 환경에서 실행
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:features/integration_flow_example.dart';

void main() {
  test('Integration flow example', () async {
    await runIntegrationFlowExample();
  });
}
```

## 실행 전 체크리스트
- ✅ 백엔드 API 서버가 실행 중인지 확인 (기본: https://api.yeobek.com)
- ✅ `API_BASE_URL` 환경변수가 올바른지 확인 (`dart-define` 또는 기본값)
- ✅ 네트워크 연결 가능 여부 확인

## 플로우 단계
1. **회원가입** (`POST /auth/register`)
2. **로그인** (`POST /auth/login`) → accessToken, refreshToken 획득
3. **사용자 정보 조회** (`GET /auth/me`)
4. **게시글 생성** (`POST /board/post`)
5. **게시글 좋아요** (`PUT /board/post/{postId}/like`)
6. **댓글 추가** (`POST /board/comment`)
7. **댓글 수정** (`PATCH /board/comment/{commentId}`)
8. **게시글 목록 조회** (`GET /board/post?boardId=...&sort=...`)
9. **게시글 상세 조회** (`GET /board/post/{postId}`)
10. **댓글 목록 조회** (`GET /board/comment?postId=...`)
11. **게시글 좋아요 취소** (`DELETE /board/post/{postId}/like?userId=...`)
12. **댓글 삭제** (`DELETE /board/comment/{commentId}`)
13. **게시글 삭제** (`DELETE /board/post/{postId}`)
14. **토큰 갱신** (`POST /auth/refresh`)

## 주요 특징
- 모든 UseCase를 Module 팩토리로 초기화
- Bearer 토큰 자동 헤더 주입
- 정적 타입 체크 및 Record 타입 활용
- 실제 백엔드 스크립트 계약과 1:1 일치

## 에러 처리
현재는 성공 케이스만 구현. 에러 발생 시 Dio의 `DioException`이 던져집니다.  
필요시 try-catch로 감싸서 HTTP 상태 코드별 처리를 추가하세요:
```dart
try {
  await authModule.postAuthLogin(email: email, password: password);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    print('Invalid credentials');
  } else if (e.response?.statusCode == 409) {
    print('Email already exists');
  }
}
```

## 확장 포인트
- Artist/Artworks 도메인도 동일 패턴으로 통합 가능
- UI 프레젠테이션 레이어에서 UseCase를 Riverpod/Provider로 주입하여 사용
- 에러 타입(`HTTP_401`, `HTTP_409` 등)을 sealed class나 enum으로 매핑하여 타입 세이프 처리

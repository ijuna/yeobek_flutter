# Flutter Mobile UI 가이드

## 기본 원칙
- **플랫폼 존중**: iOS 는 Cupertino 내비게이션 제스처, Android 는 Material 3 컴포넌트 동작을 해치지 않도록 합니다.
- **SafeArea 우선**: 최상단 위젯은 항상 `SafeArea` + `Scaffold` 로 감싸 노치·홈 인디케이터를 보호합니다.
- **design 패키지**: 색상/타이포/간격은 `design` 패키지 토큰을 우선 사용하고, 직접 색상을 새로 정의하지 않습니다.

## 레이아웃 패턴
- **홈/목록 화면**: `CustomScrollView` + `SliverAppBar` 조합을 기본으로 두고, iOS 느낌이 필요한 경우 `ScrollConfiguration` 으로 `BouncingScrollPhysics` 를 적용합니다.
- **폼/입력 화면**: `SingleChildScrollView` + `Padding` + `KeyboardAvoider` 패턴으로 키보드 오버레이를 방지합니다.
- **상태 표시**: 로딩에는 `PrimaryLoader`(design), 오류에는 공용 에러 위젯을 사용해 일관성을 맞춥니다.

## 내비게이션
- `app.dart` 에서 `GoRouter` 또는 `Navigator 2.0` 설정을 통합 관리하고, 화면 전환 애니메이션은 플랫폼 기본 값을 유지합니다.
- 딥링크/푸시 알림 진입이 필요한 경우, `core/router` 계층에서 라우트 이름을 상수로 정의해 재사용합니다.

## 실무 팁
- `MediaQuery.of(context).padding` 을 활용해 하단 버튼 영역을 안전하게 확보합니다.
- Android 14 이상은 `compileSdkVersion 34` 이상을 맞춰야 인앱 권한 다이얼로그가 정상 동작합니다.
- iOS 빌드 시 `pod install` 오류가 나면 `cd ios && pod repo update` 를 먼저 실행하세요.

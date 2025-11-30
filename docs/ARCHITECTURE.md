# Tattoo Frontend Architecture

## 📐 전체 구조 개요

```
app/
└── lib/
    ├── main.dart                          # 앱 진입점 + setupNetwork
    ├── app.dart                           # MaterialApp + 라우팅 설정
    │
    ├── core/
    │   ├── router/
    │   │   ├── app_router.dart            # 라우팅 정의 (GoRouter or Named Routes)
    │   │   └── route_names.dart           # 라우트 상수
    │   ├── di/
    │   │   └── injection.dart             # DI 컨테이너 (옵션)
    │   └── constants/
    │       └── app_constants.dart         # 앱 전역 상수
    │
    ├── ui/
    │   ├── layouts/
    │   │   ├── main_layout.dart           # 공통 레이아웃 (헤더 + 바디)
    │   │   ├── auth_layout.dart           # 로그인/회원가입용 레이아웃
    │   │   └── widgets/
    │   │       ├── app_header.dart        # 상단 고정 헤더
    │   │       ├── app_nav_bar.dart       # 네비게이션 바 (Black/아티스트/작품/커뮤니티)
    │   │       └── user_info_widget.dart  # 우측 상단 사용자 정보
    │   │
    │   ├── pages/
    │   │   ├── home/                      # 🏠 메인 홈페이지 (이미지 1)
    │   │   │   ├── home_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── popular_artists_panel.dart      # 좌측: 인기 타투이스트 1-12
    │   │   │       ├── artworks_masonry_grid.dart      # 우측: 핀터레스트식 작품 그리드 (4:5)
    │   │   │       └── popular_posts_section.dart      # 하단: 인기 게시글 (Board)
    │   │   │
    │   │   ├── artist/                    # 👤 타투이스트 관련
    │   │   │   ├── artist_list_page.dart          # 아티스트 검색/리스트
    │   │   │   ├── artist_profile_page.dart       # 아티스트 프로필 (이미지 7)
    │   │   │   └── widgets/
    │   │   │       ├── artist_card.dart           # 아티스트 카드
    │   │   │       ├── artist_info_panel.dart     # 프로필 좌측 정보
    │   │   │       ├── artist_stats_panel.dart    # 경로/평점/리뷰
    │   │   │       └── artist_gallery.dart        # 4x3 작품 그리드
    │   │   │
    │   │   ├── artworks/                  # 🎨 작품 게시판 (이미지 5)
    │   │   │   ├── artworks_page.dart
    │   │   │   ├── artwork_detail_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── artwork_tabs.dart          # 작품/추천/북의/태그 탭
    │   │   │       ├── top_random_list.dart       # Top 10 Random
    │   │   │       └── latest_artworks_grid.dart  # 최신 5개
    │   │   │
    │   │   ├── board/                     # 💬 게시판 (이미지 6)
    │   │   │   ├── board_list_page.dart           # 작가 게시판 리스트
    │   │   │   ├── board_detail_page.dart
    │   │   │   ├── board_create_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── board_list_item.dart
    │   │   │       └── board_filter_bar.dart
    │   │   │
    │   │   ├── wiki/                      # 📚 Wiki (이미지 2)
    │   │   │   ├── wiki_page.dart
    │   │   │   ├── wiki_edit_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── wiki_toc.dart              # 좌측 목차
    │   │   │       ├── wiki_content.dart          # 중앙 본문
    │   │   │       └── wiki_recent_edits.dart     # 우측 최근 편집
    │   │   │
    │   │   ├── info/                      # ℹ️ 정보 페이지
    │   │   │   ├── developer_page.dart            # 개발자 API/피드백 (이미지 3)
    │   │   │   ├── notice_list_page.dart          # 공지사항 리스트 (이미지 4)
    │   │   │   ├── notice_detail_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── feedback_form.dart
    │   │   │       └── notice_card.dart
    │   │   │
    │   │   └── auth/                      # 🔐 인증 페이지
    │   │       ├── login_page.dart
    │   │       ├── register_page.dart
    │   │       └── widgets/
    │   │           ├── login_form.dart
    │   │           └── register_form.dart
    │   │
    │   ├── shared/                        # 공통 위젯 (재사용)
    │   │   ├── buttons/
    │   │   │   ├── primary_button.dart
    │   │   │   └── icon_button.dart
    │   │   ├── cards/
    │   │   │   ├── image_card.dart
    │   │   │   └── info_card.dart
    │   │   ├── inputs/
    │   │   │   ├── search_bar.dart
    │   │   │   └── text_field.dart
    │   │   └── loading/
    │   │       ├── skeleton_loader.dart
    │   │       └── spinner.dart
    │   │
    │   └── theme/                         # 테마 확장 (앱 전용)
    │       ├── app_colors.dart            # design 패키지 확장
    │       └── app_text_styles.dart
    │
    └── utils/
        ├── extensions/
        │   ├── context_extensions.dart
        │   └── string_extensions.dart
        └── helpers/
            └── url_helper.dart
```

---

## 📦 packages/ 활용 (이미 존재하는 패키지)

```
packages/
├── features/                    # 도메인 로직 (백엔드 API 연동)
│   └── lib/src/
│       ├── artist/              # Artist 도메인
│       │   ├── domain/
│       │   │   ├── artist_entity.dart
│       │   │   ├── artist_repo.dart
│       │   │   └── usecases/
│       │   │       ├── get_artist_list.dart
│       │   │       ├── get_artist_by_id.dart
│       │   │       └── search_artists.dart
│       │   ├── data/
│       │   │   ├── remote/artist_api.dart
│       │   │   └── artist_repo_impl.dart
│       │   └── presentation/
│       │       └── artist_screen.dart      # (옵션, 앱에서 사용 안 할 수도)
│       │
│       ├── artworks/            # Artworks 도메인
│       │   ├── domain/
│       │   ├── data/
│       │   └── presentation/
│       │
│       ├── board/               # Board 도메인
│       │   ├── domain/
│       │   ├── data/
│       │   └── presentation/
│       │
│       ├── auth/                # Auth 도메인
│       │   ├── domain/
│       │   ├── data/
│       │   └── presentation/
│       │
│       └── wiki/                # Wiki 도메인 (신규 추가 필요)
│           ├── domain/
│           ├── data/
│           └── presentation/
│
├── design/                      # 디자인 시스템 (공통 UI)
│   └── lib/src/
│       ├── theme/
│       ├── tokens/
│       └── components/
│
├── network/                     # Dio 기반 HTTP 클라이언트
├── storage_hive/                # 로컬 스토리지
├── language/                    # 다국어 지원
└── core_*/                      # 공통 유틸리티
```

---

## 🔀 라우팅 구조

### 라우트 정의 (GoRouter 사용 권장)

```dart
// core/router/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // 메인 레이아웃 적용 라우트
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: RouteNames.home,
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/artists',
          name: RouteNames.artistList,
          builder: (context, state) => ArtistListPage(),
        ),
        GoRoute(
          path: '/artists/:id',
          name: RouteNames.artistProfile,
          builder: (context, state) => ArtistProfilePage(
            artistId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/artworks',
          name: RouteNames.artworks,
          builder: (context, state) => ArtworksPage(),
        ),
        GoRoute(
          path: '/board',
          name: RouteNames.board,
          builder: (context, state) => BoardListPage(),
        ),
        GoRoute(
          path: '/wiki',
          name: RouteNames.wiki,
          builder: (context, state) => WikiPage(),
        ),
        GoRoute(
          path: '/info/developer',
          name: RouteNames.developer,
          builder: (context, state) => DeveloperPage(),
        ),
        GoRoute(
          path: '/info/notice',
          name: RouteNames.notice,
          builder: (context, state) => NoticeListPage(),
        ),
      ],
    ),
    
    // 별도 레이아웃 (로그인/회원가입)
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: RouteNames.register,
      builder: (context, state) => RegisterPage(),
    ),
  ],
);
```

---

## 🎨 UI 레이어 원칙

### 1. Presentation Layer (app/lib/ui/)
- **페이지**: 라우트와 1:1 매칭, Scaffold 포함
- **위젯**: 재사용 가능한 UI 컴포넌트
- **레이아웃**: 공통 구조 (헤더, 사이드바 등)

### 2. Domain Layer (packages/features/lib/src/*/domain/)
- **Entity**: 비즈니스 모델
- **UseCase**: 비즈니스 로직 (1개 행위 = 1개 유즈케이스)
- **Repository Interface**: 데이터 계약

### 3. Data Layer (packages/features/lib/src/*/data/)
- **API**: Retrofit 기반 HTTP 호출
- **Repository Impl**: 인터페이스 구현
- **DTO**: 서버 응답 모델 → Entity 변환

---

## 📱 페이지별 책임 분리

### 🏠 HomePage 상세 레이아웃 (이미지 1)

```dart
// home_page.dart 구조
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 메인 콘텐츠 영역 (좌우 분할)
          Expanded(
            child: Row(
              children: [
                // 📌 좌측: 인기 타투이스트 리스트 (고정 너비)
                SizedBox(
                  width: 300, // 예시
                  child: PopularArtistsPanel(
                    // Artist 도메인에서 인기순 1-12명 가져오기
                    // GetPopularArtists usecase 사용
                  ),
                ),
                
                // 📌 우측: 작품 Masonry 그리드 (나머지 영역)
                Expanded(
                  child: ArtworksMasonryGrid(
                    // Artworks 도메인에서 인기 작품 가져오기
                    // GetPopularArtworks usecase 사용
                    // 각 이미지: AspectRatio(4:5) 고정
                    // flutter_staggered_grid_view 패키지 사용 추천
                  ),
                ),
              ],
            ),
          ),
          
          // 📌 하단: 인기 게시글 섹션
          SizedBox(
            height: 300, // 예시
            child: PopularPostsSection(
              // Board 도메인에서 인기 게시글 가져오기
              // GetPopularPosts usecase 사용
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 위젯별 책임

1. **PopularArtistsPanel** (좌측)
   ```dart
   // 기능:
   - 인기 타투이스트 1-12명 표시
   - 순위 번호 (1, 2, 3, ...)
   - 아티스트 이름 + 간단 정보
   - 클릭 시 ArtistProfilePage로 이동
   
   // 데이터 소스:
   - Artist 도메인
   - GetPopularArtists() usecase
   - 정렬: 인기순 (팔로워, 좋아요 등)
   ```

2. **ArtworksMasonryGrid** (우측)
   ```dart
   // 기능:
   - 핀터레스트 스타일 폭포수 레이아웃
   - 각 이미지 AspectRatio 4:5 고정
   - 무한 스크롤 or 페이지네이션
   - 클릭 시 ArtworkDetailPage로 이동
   
   // 데이터 소스:
   - Artworks 도메인
   - GetPopularArtworks() usecase
   - 정렬: 인기순 (좋아요, 조회수 등)
   
   // 기술:
   - flutter_staggered_grid_view 패키지
   - 또는 CustomScrollView + SliverMasonryGrid
   ```

3. **PopularPostsSection** (하단)
   ```dart
   // 기능:
   - 인기 게시글 목록 (가로 스크롤 or 그리드)
   - 게시글 썸네일 + 제목 + 작성자
   - 클릭 시 BoardDetailPage로 이동
   
   // 데이터 소스:
   - Board 도메인
   - GetPopularPosts() usecase
   - 정렬: 인기순 (댓글, 좋아요 등)
   ```

---

## 📦 필요한 UseCase 추가

### Artist 도메인
```dart
// packages/features/lib/src/artist/domain/usecases/get_popular_artists.dart
class GetPopularArtists {
  final ArtistRepo _repo;
  
  Future<List<ArtistEntity>> call({
    int limit = 12,
    String sortBy = 'followers_desc', // or 'likes_desc'
  }) => _repo.getPopularArtists(limit: limit, sortBy: sortBy);
}
```

### Artworks 도메인
```dart
// packages/features/lib/src/artworks/domain/usecases/get_popular_artworks.dart
class GetPopularArtworks {
  final ArtworksRepo _repo;
  
  Future<List<ArtworkEntity>> call({
    int page = 1,
    int pageSize = 20,
    String sortBy = 'likes_desc', // or 'views_desc'
  }) => _repo.getPopularArtworks(
    page: page, 
    pageSize: pageSize, 
    sortBy: sortBy,
  );
}
```

### Board 도메인
```dart
// packages/features/lib/src/board/domain/usecases/get_popular_posts.dart
class GetPopularPosts {
  final BoardRepo _repo;
  
  Future<List<PostEntity>> call({
    int limit = 10,
    String sortBy = 'comments_desc', // or 'likes_desc'
  }) => _repo.getPopularPosts(limit: limit, sortBy: sortBy);
}
```

---

## 🎨 4:5 비율 이미지 처리

```dart
// artworks_masonry_grid.dart 내부
class ArtworkCard extends StatelessWidget {
  final ArtworkEntity artwork;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/artworks/${artwork.id}'),
      child: AspectRatio(
        aspectRatio: 4 / 5, // 🔥 4:5 비율 고정
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            artwork.imageUrl,
            fit: BoxFit.cover, // 비율 유지하며 채우기
          ),
        ),
      ),
    );
  }
}
```

---

## 📐 Masonry 레이아웃 구현

### 옵션 1: flutter_staggered_grid_view (추천)
```yaml
# pubspec.yaml
dependencies:
  flutter_staggered_grid_view: ^0.7.0
```

```dart
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ArtworksMasonryGrid extends StatelessWidget {
  final List<ArtworkEntity> artworks;
  
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 3, // 3열 그리드
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: artworks.length,
      itemBuilder: (context, index) {
        return AspectRatio(
          aspectRatio: 4 / 5,
          child: ArtworkCard(artwork: artworks[index]),
        );
      },
    );
  }
}
```

### 옵션 2: CustomScrollView (네이티브)
```dart
class ArtworksMasonryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4 / 5, // 🔥 4:5 비율
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArtworkCard(artwork: artworks[index]),
            childCount: artworks.length,
          ),
        ),
      ],
    );
  }
}
```

---

## 📱 페이지별 책임 분리

| 페이지 | 경로 | 주요 기능 | 사용 도메인 |
|--------|------|-----------|-------------|
| **HomePage** | `/home` | 타투이스트 리스트 + 이미지 갤러리 | Artist, Artworks |
| **ArtistListPage** | `/artists` | 아티스트 검색/필터 | Artist |
| **ArtistProfilePage** | `/artists/:id` | 아티스트 상세 프로필 | Artist, Artworks |
| **ArtworksPage** | `/artworks` | 작품 게시판 (탭 4개) | Artworks |
| **BoardListPage** | `/board` | 게시판 리스트 | Board |
| **WikiPage** | `/wiki` | Wiki 본문 + 목차 | Wiki (신규) |
| **DeveloperPage** | `/info/developer` | 개발자 문의/피드백 | - (폼만) |
| **NoticeListPage** | `/info/notice` | 공지사항 리스트 | Notice (신규) |
| **LoginPage** | `/login` | 로그인 | Auth |
| **RegisterPage** | `/register` | 회원가입 | Auth |

---

## 🔧 신규 도메인 추가 필요

현재 `packages/features/`에 없는 도메인:

1. **Wiki** (이미지 2)
   - `packages/features/lib/src/wiki/`
   - Entity: WikiPage, WikiRevision
   - UseCase: GetWikiPage, UpdateWikiPage, GetRecentEdits

2. **Notice** (이미지 4)
   - `packages/features/lib/src/notice/`
   - Entity: Notice
   - UseCase: GetNoticeList, GetNoticeById

3. **Feedback** (이미지 3)
   - `packages/features/lib/src/feedback/`
   - Entity: Feedback
   - UseCase: SubmitFeedback

---

## 🎯 다음 단계

1. ✅ 아키텍처 문서화 (이 파일)
2. 📁 `app/lib/` 폴더 구조 생성
3. 🎨 MainLayout + AppHeader 구현
4. 🔀 GoRouter 설정
5. 📄 각 페이지 스켈레톤 생성
6. 🔌 도메인 연동 (UseCase 호출)
7. 🎨 디자인 시스템 확장

---

## 💡 핵심 원칙

### ✅ DO
- UI(앱)는 **UseCase만 호출**, API/Repo 직접 호출 금지
- 페이지는 **상태 관리**(Provider/Riverpod/Bloc) 사용
- 공통 위젯은 `ui/shared/`에 모아두기
- 라우팅은 **타입 안전**하게 (GoRouter 권장)

### ❌ DON'T
- `package:features/src/...` 직접 import 금지
- 페이지에서 비즈니스 로직 작성 금지
- 중복 위젯 만들기 (shared 먼저 확인)
- 하드코딩된 문자열 (language 패키지 사용)

---

## 📚 참고 자료

- [Go Router 문서](https://pub.dev/packages/go_router)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture/)
- [프로젝트 Copilot Instructions](/.github/copilot-instructions.md)

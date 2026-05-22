# English Practice — App Flow Document

> Tài liệu mô tả toàn bộ luồng hoạt động của app: navigation, data flow, màn hình, và user journey.
> Cập nhật lần cuối: 2026-05-22

---

## 1. Kiến Trúc Tổng Quan

```
┌─────────────────────────────────────────────────────┐
│                    main.dart                        │
│  Firebase init → Hive init → DI setup → App()       │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│                    app.dart                         │
│  MaterialApp.router                                 │
│  BlocConsumer<SettingsBloc>  → đổi theme real-time  │
│  MultiBlocProvider (global BLoCs):                  │
│    - SettingsBloc  (factory)                        │
│    - AuthCubit     (factory)                        │
│    - IapBloc       (lazySingleton)                  │
│    - TranslateCubit(factory)                        │
└────────────────────┬────────────────────────────────┘
                     │
              GoRouter (app_router.dart)
```

---

## 2. Navigation Flow (GoRouter)

### 2.1 Sơ đồ tổng thể

```
GoRouter
├── /onboarding          ← Màn hình khởi đầu (chỉ hiện 1 lần)
│
└── StatefulShellRoute   ← BottomNavigationBar (5 tabs)
    ├── [0] /vocabulary        → VocabularyScreen
    │        /word_details     → WordDetailsScreen
    │
    ├── [1] /review            → ReviewScreen         ← (SẼ ĐỔI → AI tab)
    │        /flashcards       → FlashCardScreen
    │
    ├── [2] /ai_lesson         → AiLessonScreen       ← (SẼ ĐỔI → Progress tab)
    │
    ├── [3] /grammar           → GrammarScreen
    │        /category         → CategoryScreen
    │        /lesson           → LessonScreen
    │
    └── [4] /settings          → SettingsScreen

    (Standalone routes — ngoài Shell)
    /streak                    → StreakScreen
```

### 2.2 Navigation sau Phase 1 (kế hoạch)

```
StatefulShellRoute
├── [0] /vocabulary        → VocabularyScreen  (+ nút Start Review)
│        /word_details     → WordDetailsScreen
│        /flashcards       → FlashCardScreen   ← chuyển vào đây
│
├── [1] /ai_lesson         → AiLessonScreen    ← tab AI dời vào index 1
│
├── [2] /progress          → ProgressScreen    ← tab MỚI
│
├── [3] /grammar           → GrammarScreen
│        /category         → CategoryScreen
│        /lesson           → LessonScreen
│
└── [4] /settings          → SettingsScreen
```

### 2.3 Redirect Logic

```dart
// Khi app khởi động lần đầu (isFirstOpen == true):
redirect: /onboarding

// Sau khi onboarding xong:
redirect: /vocabulary (default)
```

---

## 3. Authentication Flow

```
App khởi động
     │
     ▼
FirebaseAuth.currentUser?
     │
     ├── null → Hiển thị Google Sign-In button (trong SettingsScreen)
     │
     └── có user → AuthCubit.state = authenticated
                        │
                        ▼
               Backend: GET /api/v1/users/me
               (FirebaseTokenFilter tự động tạo user nếu chưa có)
                        │
                        ▼
               User + UserSetting + UserStreak được tạo
               (dailyGoal=10, isNotificationEnabled=true, streak=0)
```

**Token flow:**
- Mỗi request đến backend: `Authorization: Bearer <Firebase ID Token>`
- `AuthInterceptor` (Dio) tự lấy token từ `FirebaseAuth.instance.currentUser.getIdToken()`
- `FirebaseTokenFilter` (Backend) verify token → set Spring Security context

---

## 4. Màn Hình Chi Tiết

### 4.1 OnboardingScreen
- **Hiển thị khi**: `GlobalValues.isFirstOpen == true`
- **Nội dung**: Giới thiệu app, các tính năng chính
- **Kết thúc**: Set `isFirstOpen = false` → navigate `/vocabulary`

---

### 4.2 VocabularyScreen (Tab 0)
**Data flow:**
```
VocabularyBloc
  └── OxfordWordsRepository
        └── AssetsDataImpl (đọc a.json → z.json từ assets)
              + HiveDatabase (Box<Word> — lưu trạng thái local)
```

**UI flow:**
```
VocabularyScreen
├── SearchBox (debounce, filter theo text)
├── Filter Chips (WordPos: noun/verb/adj/...)
├── [PHASE 1] Stats Bar (tổng / starred / mastered)
├── [PHASE 1] Nút "Start Review" (nếu có từ starred)
│
├── BannerAdWidget (sau item thứ 2, ẩn nếu premium)
│
└── ListView<VocabularyItem>
      │
      ├── Tap → /word_details (WordDetailsScreen)
      │
      └── Long press / icon star → toggle WordStatus
            └── VocabularyBloc → HiveDatabase.save()
                              → Backend: POST /vocabularies/sync
```

**WordStatus enum (client):** `unknown` | `star` | `mastered`
**WordStatus enum (backend):** `UNKNOWN` | `LEARNING` | `MASTERED` | `STARRED`

---

### 4.3 WordDetailsScreen
**Data:**
- Nhận `Word` object qua GoRouter `extra`
- Hiển thị: phonetic UK/US, pos (part of speech), definitions, examples

**Actions:**
- **Translate**: `TranslateCubit` → `GoogleTranslateData` (Dio) → popup dialog với 33 ngôn ngữ
- **Star/Unstar**: cập nhật Hive → sync backend
- **User Definition**: nhập định nghĩa riêng → lưu vào Word.userDefinition (Hive)
- **Schedule reminder**: `NotificationsBloc` → tạo `ScheduledNotification` (Hive) → local notification

---

### 4.4 ReviewScreen (Tab 1 hiện tại → sẽ bị xóa tab)
**Data:**
```
ReviewScreen
└── VocabularyBloc (filter words có status == star)
```

**UI flow:**
```
ReviewScreen
├── Danh sách từ đã starred
├── BannerAdWidget (ẩn nếu premium)
├── Nút "Schedule" → ScheduleModal (chọn thời gian nhắc)
│
└── Nút "Start Flashcards"
      │
      ├── Lần đầu trong ngày → /flashcards trực tiếp
      └── Lần thứ 2+ (nếu free) → RewardedAdMixin → xem ad → /flashcards
```

---

### 4.5 FlashCardScreen
```
FlashCardScreen
├── Nhận List<Word> từ starred words
├── SwipeLeft  = don't know → giữ nguyên status
├── SwipeRight = know       → có thể update status
└── Kết thúc → pop về ReviewScreen/VocabularyScreen
              → show InAppReview (nếu đủ điều kiện)
```

---

### 4.6 AiLessonScreen (Tab 2 hiện tại → sẽ là Tab 1)
**Hiện tại:** Màn hình placeholder đơn giản, chỉ có text "No AI lessons" + FAB

**FAB action:** `Navigator.push` → `NewAiLessonScreen`

**Sau Phase 1:**
```
AiLessonScreen (dùng BasePage)
├── Nút "New Lesson" (RoundedButton)
│     └── Navigate → NewAiLessonScreen
│
└── List Recent Lessons (style CategoryItem)
      └── Tap → AiLessonDetailScreen
```

---

### 4.7 NewAiLessonScreen
**2 chế độ:**

**Chế độ 1 — Sample Passage (từ Category):**
```
NewAiLessonScreen
└── Chọn Category (18 options) → SelectTopicScreen
      └── Chọn Level (A1→C2) → SelectLevelScreen
            │
            ▼
      Backend: POST /api/v1/ai/sample-passage
      Body: { category, level, minWords, maxWords }
            │
            ▼ (Vertex AI Gemini 2.5 Flash Lite)
      SampleWordSelectorService → chọn 5-7 từ từ category JSON
      VertexSamplePassageService → sinh đoạn văn chứa các từ đó
            │
            ▼
      Response: { title, passage, selectedWords[] }
            │
            ▼
      AiLessonDetailScreen
```

**Chế độ 2 — Custom Text (user tự nhập):**
```
NewAiLessonScreen
└── User nhập/paste đoạn văn (tối đa 300 từ, 1000 từ nếu premium)
      │
      ▼
Backend: POST /api/v1/ai/generate-lesson
Body: { customText, level }
      │
      ▼ (Vertex AI)
AiService → extract vocabulary từ text
      │
      ▼
Response: { title, passage, vocabulary[{word, meaning(VI), pronunciation, example}] }
      │
      ▼
AiLessonDetailScreen
```

---

### 4.8 AiLessonDetailScreen
```
AiLessonDetailScreen
├── Hiển thị passage (flutter_html)
├── Danh sách vocabulary cards:
│     word | phonetic | meaning(VI) | example
│
├── Nút "Practice Now"
│     └── Tạo List<Word> từ vocabulary → FlashCardScreen
│
└── [PHASE 4] Nút "Save All to Vocabulary"
      └── Gọi POST /vocabularies/sync cho từng từ
```

---

### 4.9 GrammarScreen (Tab 3)
**Data (hardcoded trong code):** 4 categories, 37 lessons tổng

```
GrammarScreen
├── SearchBox (filter theo title/description)
├── [PHASE 2] Language toggle EN/VI
├── BannerAdWidget (sau item thứ 2)
│
└── ListView CategoryData:
    1. Tenses    (13 lessons)
    2. Sentences (8 lessons)
    3. Words     (9 lessons)
    4. Others    (5 lessons: Word Families, Phrasal Verbs, Idioms, Proverbs, Quantifiers)
          │
          ▼
    CategoryScreen
    ├── List<Lesson> trong category
    ├── Checkbox "mark as read" (lưu vào LessonBloc → SharedPrefs)
    ├── Free users: 3 lessons free, sau đó cần xem RewardedAd
    │
    └── Tap lesson → LessonScreen
```

---

### 4.10 LessonScreen
```
LessonScreen
├── Nhận Lesson object (id, title, path)
├── rootBundle.loadString(lesson.path)  ← load file .md từ assets
├── Render bằng flutter_markdown
│
├── [PHASE 2] Load path_vi nếu locale == 'vi'
├── [PHASE 2] Toggle button EN/VI trên AppBar
│
├── Checkbox mark-as-read (AppBar)
│     └── LessonBloc → markLesson(id, true) → SharedPrefs
│
└── Khi scroll hết + navigate back:
      └── InterstitialAdMixin → show interstitial (nếu free user)
```

**Grammar markdown files:** `assets/md/grammar/**/*.md` (37 files)
**Grammar Vietnamese files (Phase 2):** `assets/md/grammar_vi/**/*.md` (37 files)

---

### 4.11 SettingsScreen (Tab 4)
```
SettingsScreen
├── Profile Section
│     ├── Avatar + Display Name + Email
│     ├── Nút Google Sign-In / Sign-Out
│     └── (khi đăng nhập → sync dữ liệu lên backend)
│
├── Appearance Section
│     ├── Theme Mode (System/Light/Dark)
│     │     └── SettingsBloc → SettingsSnapshot.themeMode → Hive → MaterialApp rebuild
│     └── Color Picker (8 preset colors)
│           └── SettingsBloc → SettingsSnapshot.seek → Hive → ColorScheme.fromSeed()
│
├── [PHASE 2] Language Section
│     ├── Tile "Ngôn ngữ / Language" với flag 🇻🇳/🇬🇧
│     └── Tap → chọn VI/EN → SettingsBloc → SettingsSnapshot.locale → Hive → MaterialApp.locale
│
├── [PHASE 6] Daily Goal Section
│     └── Chọn 5/10/15/30 phút → cập nhật Streak threshold
│
├── Notifications Section
│     └── Toggle bật/tắt notifications
│
├── Subscription Section
│     ├── PaywallButton → PaywallDialog
│     └── Restore Purchases
│
└── Contact / Links Section
      ├── App Store URL
      ├── Privacy Policy
      └── Terms of Use
```

---

### 4.12 StreakScreen (Standalone)
- **Truy cập từ**: FAB (StreakButton) trên Tab Vocabulary
- **Không nằm trong** StatefulShellRoute → navigate bằng `context.push('/streak')`

```
StreakScreen
├── Vòng tròn tiến trình (spentTimeToday / timePerDayNeeded)
├── Current streak + Max streak
├── BannerAdWidget
│
└── Nút Share
      ├── Free: chia sẻ → nhận 1 ngày free trial (IapBloc → consumable free)
      └── Premium: chia sẻ ảnh tiến trình
```

**Streak Timer Logic (trong HomeNavigation):**
```
StreakBloc
└── Timer.periodic(1 second)
      └── spentTimeToday++
            └── khi spentTimeToday >= timePerDayNeeded (300s = 5 phút):
                  └── StreakRepository → markTodayStreaked() → SharedPrefs
                        └── Cập nhật currentStreak + lastActivityDate
```

---

## 5. IAP & Ads Flow

### 5.1 Premium Check
```dart
// GlobalValues.boughtNoAdsTime:
null        → Free user
-1          → Permanent premium (PRIMARY product — non-consumable)
int > 0     → Temporary premium đến timestamp đó (SECONDARY product — consumable)

// Cách check (đồng nhất sau Phase 5):
final isPremium = IapBloc.state.boughtNoAdsTime != null;
```

### 5.2 Purchase Flow (hiện tại — client-only)
```
User tap "Go Premium"
      │
      ▼
PaywallDialog (hiển thị 2 gói)
      │
      ▼
IapRepository.buy(product)
      │
      ▼
InAppPurchase stream (PurchaseDetails)
      │
      ▼
IapBloc._processPurchase()
      ├── isPrimary → GlobalValues.setBoughtNoAdsTime(-1)
      └── isSecondary → GlobalValues.setBoughtNoAdsTime(tomorrow.ms)
```

### 5.3 Purchase Flow (Phase 5 — server verification)
```
User tap "Go Premium"
      │
      ▼
PaywallDialog
      │
      ▼
InAppPurchase stream → PurchaseDetails
      │
      ▼
IapBloc._processPurchase()
      │
      ▼
POST /api/v1/purchases/verify
Body: { productId, purchaseToken, platform }
      │
      ├── 200 OK (valid) → set premium bình thường
      ├── 400 (fake/invalid) → reject, show error
      └── network error → tạm set premium, retry sau
```

### 5.4 Ads Placement
| Vị trí | Loại | Điều kiện |
|--------|------|-----------|
| VocabularyScreen | Banner | Free user |
| ReviewScreen | Banner | Free user |
| GrammarScreen | Banner | Free user |
| CategoryScreen | Banner | Free user |
| SettingsScreen | Banner | Free user |
| StreakScreen | Banner | Free user |
| FlashCardScreen (lần 2+/ngày) | Rewarded | Free user |
| LessonScreen (scroll hết) | Interstitial | Free user |
| App foreground | App Open | Free user |

---

## 6. Data Storage Map

```
┌─────────────────────────────────────────────────────────┐
│                   CLIENT DATA STORAGE                   │
│                                                         │
│  Hive Box<Word>          → Từ vựng + WordStatus         │
│  Hive Box<SettingsSnapshot> → Theme color + mode        │
│                             + [Phase 2] locale          │
│  Hive Box<ScheduledNotification> → Reminder schedule    │
│                                                         │
│  SharedPreferences:                                     │
│    boughtNoAds           → Premium status               │
│    streak_YYYY-M-D       → Thời gian học ngày đó        │
│    streaked_YYYY-M-D     → Đã streak ngày đó chưa       │
│    currentStreak         → Streak hiện tại              │
│    maxStreak             → Streak cao nhất              │
│    lesson_marked_{id}    → Grammar lesson đã đọc        │
│    isFirstOpen           → Đã qua onboarding chưa       │
│    isFreeTrialUsed       → Đã dùng free trial chưa      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                   BACKEND DATA (MySQL)                  │
│                                                         │
│  users                   → User profile                 │
│  user_settings           → dailyGoal, notifications     │
│  user_streaks            → currentStreak, maxStreak     │
│  user_vocabularies       → Word + status + sync data    │
│  [Phase 3] study_sessions → Lịch sử thời gian học      │
│  [Phase 5] purchases     → Purchase verification        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                   STATIC ASSETS (bundled)               │
│                                                         │
│  assets/json/oxford_words/a-z.json  → ~6000 Oxford words│
│  assets/md/grammar/**/*.md          → 37 grammar files  │
│  [Phase 2] assets/md/grammar_vi/**  → 37 bản dịch VI   │
│                                                         │
│  SERVER STATIC (Spring Boot classpath):                 │
│  json/oxford_words/a-z.json         → Oxford words      │
│  json/category_words/*.json         → 18 category words │
│    ↑ có field level (A1-C2) và category                 │
└─────────────────────────────────────────────────────────┘
```

---

## 7. BLoC Architecture

### 7.1 Global BLoCs (provided ở App level)

| BLoC | Scope | Mục đích |
|------|-------|---------|
| `SettingsBloc` | Factory (per widget tree) | Theme + locale |
| `AuthCubit` | Factory | Firebase auth state |
| `IapBloc` | LazySingleton | IAP purchase state (toàn app) |
| `TranslateCubit` | Factory | Translation dialog |

### 7.2 Shell BLoCs (provided ở StatefulShellRoute level)

| BLoC | Registration | Mục đích |
|------|-------------|---------|
| `VocabularyBloc` | LazySingleton | Từ vựng user (Hive) |
| `LessonBloc` | Factory | Grammar marked lessons |
| `NotificationsBloc` | Factory | Scheduled notifications |
| `StreakBloc` | Factory | Streak timer + data |

### 7.3 BLoC Events → State Flow

```
VocabularyBloc:
  loadVocabulary → [Hive read] → VocabularyState(words: [...])
  updateWord     → [Hive write + API sync] → updated state
  searchWords    → filtered state (no API call)

SettingsBloc:
  getSettings    → [Hive read] → SettingsState(snapshot)
  saveSettings   → [Hive write] → new SettingsState → MaterialApp rebuild

StreakBloc:
  startTimer     → Timer.periodic(1s) → increment spentTimeToday
  checkStreak    → compare date → update streak
```

---

## 8. Network Layer

```
BackendDio (base: https://rash-boasting-neon.ngrok-free.dev/api/v1)
  ├── AuthInterceptor     → thêm "Authorization: Bearer <token>"
  │                       → thêm "ngrok-skip-browser-warning: true"
  ├── ConnectivityInterceptor → check internet trước mỗi request
  └── LoggingInterceptor  → log request/response (debug mode)

TranslationDio (base: TRANSLATION_BASE_URL env var)
  └── Google Translate undocumented API (/translate_a/single)
```

---

## 9. Phase-by-Phase Flow Changes

### Phase 1: Layout & Flow Update
- Tab "Studying" (index 1) → đổi thành "AI Lessons"
- Tab "AI" (index 2) → đổi thành "Progress"
- `/review` và `/flashcards` → move vào Vocabulary branch
- `VocabularyScreen` có thêm stats bar + nút "Start Review"
- Bug fix: `home_navigation.dart` thống nhất premium check `!= null`

### Phase 2: Vietnamese Localization
- `SettingsSnapshot` thêm field `locale` (HiveField 2)
- `SettingsBloc` quản lý locale → truyền vào `MaterialApp.locale`
- `LessonScreen` load `grammar_vi/` khi locale = 'vi'
- Tất cả hardcoded strings → `AppLocalizations`

### Phase 3: Progress Dashboard
- Tab Progress (index 2) → `ProgressScreen` mới
- Data 100% từ local: VocabularyBloc (Hive) + LessonBloc (SharedPrefs) + StreakBloc
- Backend chỉ có `POST /progress/log-session`

### Phase 4: AI Category Vocabulary
- `CategoryWordsScreen` mới — browse 18 categories
- CEFR filter A1-C2 (dùng data từ `category_words/*.json` có field `level`)
- Nút "Add to My Words" → gọi `/vocabularies/sync` đã có

### Phase 5: IAP Backend
- Backend: `Purchase` entity + verify flow với Google Play API
- Client: `IapBloc` gọi backend verify trước khi set premium
- Graceful degradation khi mất mạng

### Phase 6: New Features
- Word of the Day (widget đầu VocabularyScreen)
- Pronunciation TTS (icon loa trên VocabularyItem)
- Grammar Bookmark (icon heart trên LessonScreen)
- Daily Goal picker (trong Settings, thay vì hardcode 300s)

---

## 10. Error Handling

| Tình huống | Xử lý |
|-----------|-------|
| Mất internet | `ConnectivityInterceptor` throw Failure → UI show snackbar |
| Token expired | Firebase tự refresh → `AuthInterceptor` lấy token mới |
| Backend lỗi 5xx | Repository trả `Left(Failure)` → BLoC handle |
| Hive read error | `GlobalExceptionHandler` log + fallback default |
| Ad load fail | `BannerAdWidget` hide gracefully (không show blank) |
| IAP verify fail | Show error dialog, không block app |

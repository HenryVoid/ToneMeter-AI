# ToneMeter AI MVP 구현 플랜

## 개요
대화 캡처 → OCR → 감정톤 분석 → 미터기 UI 표시를 구현하는 서버리스 SwiftUI + MVVM 기반 iOS 앱 개발. GRDB 로컬 저장, Firebase Analytics/Crashlytics, OpenAI API 연동 포함.

---

## 📋 Todolist 진행 상황

### ✅ 완료
1. **프로젝트 구조 및 의존성 설정**
   - SPM으로 GRDB.swift, Firebase SDK 추가
   - 디렉토리 구조 생성 (Models, Services, ViewModels, Views, Utilities)
   - Info.plist 권한 설정 추가

2. **xcconfig 및 .gitignore 설정**
   - Config.xcconfig 파일 생성 (API 키 관리)
   - .gitignore 업데이트 (Config.xcconfig, GoogleService-Info.plist 제외)

3. **데이터 레이어 구현**
   - EmotionRecord.swift (GRDB 모델)
   - ToneAnalysisResult.swift (API 응답 모델)
   - DatabaseManager.swift (GRDB 초기화 및 마이그레이션)
   - EmotionRecordRepository.swift (CRUD 메서드)
   - CRUD 테스트 완료 (저장/조회/삭제 검증)

### 🔄 진행 중
- 없음

### ⏳ 대기 중
4. **OCR 서비스 구현** (VisionOCRService)
5. **OpenAI API 서비스 구현** (OpenAIService, APIConfiguration)
6. **Firebase 초기화** (AppDelegate, Analytics, Crashlytics)
7. **ViewModels 구현** (Home, Analysis, History, Settings)
8. **Launch & Onboarding Views** (LaunchView, OnboardingView)
9. **Main Tab & Home View** (ToneMeterTabView, HomeView, ToneMeterGauge)
10. **Analysis Flow Views** (ImagePicker, OcrProcessing, AnalysisView)
11. **History Views** (HistoryView, DetailView, EmotionChart)
12. **Settings View** (SettingsView)
13. **UI Components** (ToneMeterGauge, EmotionChart, EmotionCard)
14. **Theme Colors** (Color+Theme extension)
15. **Permissions** (권한 요청 로직)
16. **Firebase Setup Guide** (문서 작성)
17. **README** (프로젝트 문서화)

---

## 1. 프로젝트 구조 및 의존성 설정

### 디렉토리 구조
```
ToneMeter/
├── App/
│   ├── ToneMeterApp.swift (기존)
│   └── AppDelegate.swift (Firebase 초기화)
├── Models/
│   ├── EmotionRecord.swift (데이터 모델)
│   └── ToneAnalysisResult.swift (API 응답 모델)
├── Services/
│   ├── Database/
│   │   ├── DatabaseManager.swift (GRDB 설정)
│   │   └── EmotionRecordRepository.swift (CRUD)
│   ├── OCR/
│   │   └── VisionOCRService.swift
│   └── API/
│       ├── OpenAIService.swift
│       └── APIConfiguration.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── AnalysisViewModel.swift
│   ├── HistoryViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Launch/
│   │   ├── LaunchView.swift
│   │   └── OnboardingView.swift
│   ├── Main/
│   │   ├── ToneMeterTabView.swift
│   │   └── HomeView.swift
│   ├── Analysis/
│   │   ├── ImagePickerView.swift
│   │   ├── OcrProcessingView.swift
│   │   └── AnalysisView.swift
│   ├── History/
│   │   ├── HistoryView.swift
│   │   └── DetailView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       ├── ToneMeterGauge.swift
│       ├── EmotionChart.swift
│       └── EmotionCard.swift
├── Utilities/
│   ├── Extensions/
│   │   ├── Color+Theme.swift
│   │   └── Date+Format.swift
│   └── Constants.swift
└── Resources/
    ├── Assets.xcassets/ (기존)
    ├── Config.xcconfig (API 키 저장, .gitignore 추가)
    └── Firebase-Setup-Guide.md
```

### Package Dependencies (SPM)
- GRDB.swift: 로컬 데이터베이스
- Firebase/Analytics, Firebase/Crashlytics: 분석 및 크래시 리포팅

### xcconfig 설정
`Config.xcconfig` 파일 생성하여 `OPENAI_API_KEY` 관리 (Build Settings에서 User-Defined Setting으로 주입)

## 2. 데이터 레이어 구현

### EmotionRecord 모델 (GRDB)
```swift
struct EmotionRecord: Codable, FetchableRecord, PersistableRecord {
    var id: UUID
    var createdAt: Date
    var imagePath: String
    var ocrText: String
    var toneScore: Double // 0~100
    var toneLabel: String // "Positive", "Neutral", "Negative"
    var toneKeywords: String // JSON array string
    var modelVersion: String
}
```

### DatabaseManager 구현
- GRDB 초기화 (Documents 디렉토리에 DB 파일 생성)
- 테이블 마이그레이션 설정
- EmotionRecordRepository: CRUD 메서드 제공

## 3. 서비스 레이어 구현

### VisionOCRService
- `VNRecognizeTextRequest`를 사용한 텍스트 인식
- 이미지 → 텍스트 변환 비동기 처리
- 인식 정확도 설정 (`.accurate`)

### OpenAIService
- API Configuration에서 xcconfig 키 읽기
- `gpt-4o-mini` 모델로 감정 분석 요청
- Prompt: "다음 대화 텍스트의 감정을 분석하여 0~100 점수, 긍정/중립/부정 레이블, 주요 감정 키워드를 JSON 형식으로 반환하세요."
- 응답 파싱 → `ToneAnalysisResult` 모델

### Firebase 초기화
- `AppDelegate.swift`에서 `FirebaseApp.configure()` 호출
- Analytics 이벤트: `launch_open`, `permission_granted`, `ocr_success`, `analysis_complete`

## 4. ViewModel 구현 (MVVM)

### HomeViewModel
- 오늘의 평균 감정 점수 계산 (최근 분석 데이터 평균)
- 최근 분석 기록 로드
- Published 프로퍼티: `averageToneScore`, `todayRecords`

### AnalysisViewModel
- 이미지 선택 → OCR → API 호출 → DB 저장 플로우 관리
- Published 프로퍼티: `selectedImage`, `ocrText`, `analysisResult`, `isLoading`

### HistoryViewModel
- GRDB에서 전체 기록 로드
- 날짜별/점수별 필터링 및 정렬
- Published 프로퍼티: `records`, `filterOption`

### SettingsViewModel
- 앱 버전 정보, 데이터 초기화 기능

## 5. UI 구현 (SwiftUI)

### LaunchView & OnboardingView
- `LaunchView`: 앱 로고 + 슬로건 애니메이션
- `OnboardingView`: 기능 소개 (1~2 페이지), 권한 요청 (PhotosUI)
- `@AppStorage("isFirstLaunch")` 상태 관리

### ToneMeterTabView (메인 탭)
```swift
TabView {
    HomeView().tabItem { Label("홈", systemImage: "gauge") }
    HistoryView().tabItem { Label("기록", systemImage: "clock") }
    SettingsView().tabItem { Label("설정", systemImage: "gearshape") }
}
```

### HomeView
- 상단: 앱 이름 + 오늘의 평균 감정 톤 표시
- 중앙: `ToneMeterGauge` (SwiftUI Gauge + gradient)
- 하단: "이미지로 분석하기", "분석 기록 보기" 버튼

### ImagePickerView → OcrProcessingView → AnalysisView
1. `PHPickerViewController` / `UIImagePickerController` (카메라/갤러리 선택)
2. OCR 진행 중 ProgressView + 인식된 텍스트 프리뷰
3. 감정 분석 결과 표시: 점수, 레이블, 키워드, 저장/공유 버튼

### HistoryView & DetailView
- `HistoryView`: List로 기록 표시 (썸네일, 날짜, 점수, 요약)
- 필터 버튼 (날짜/점수 정렬)
- `DetailView`: 상세 결과 + OCR 원문 + 감정 분포 차트 (Swift Charts)

### SettingsView
- 앱 버전, Firebase Analytics opt-in
- "데이터 초기화" 버튼
- "문의하기" (메일 링크)

### Components
- `ToneMeterGauge`: Gauge view with gradient colors (0~100 범위)
- `EmotionChart`: Swift Charts로 감정 분포 시각화
- `EmotionCard`: 히스토리 리스트 셀 UI

## 6. 색상 테마 적용

기존 `Assets.xcassets` 컬러셋 활용:
- `accent_positive`, `accent_neutral`, `accent_negative`: 감정 레이블 색상
- `gradient_primary_start`, `gradient_primary_end`: 미터기 그라데이션
- `Color+Theme.swift` extension으로 편리한 접근

## 7. 권한 처리

- `Info.plist`에 권한 설명 추가:
  - `NSPhotoLibraryUsageDescription`
  - `NSCameraUsageDescription`
- 온보딩 화면에서 권한 요청 및 Firebase Analytics 이벤트 기록

## 8. Firebase 설정 가이드

`Firebase-Setup-Guide.md` 작성:
1. Firebase Console에서 iOS 앱 추가
2. `GoogleService-Info.plist` 다운로드 → 프로젝트 루트에 추가
3. Xcode에서 Firebase SDK 설치 확인
4. 빌드 후 Analytics 작동 확인

## 9. .gitignore 업데이트

- `Config.xcconfig` (API 키 보호)
- `GoogleService-Info.plist` (Firebase 설정 파일)
- `*.xcuserstate`, `DerivedData/`

## 10. README 작성

프로젝트 설명, 설치 방법, API 키 설정 가이드, 실행 방법 포함

## 데이터 구조

| 컬럼명          | 타입     | 설명                              |
| ------------ | ------ | ------------------------------- |
| id           | UUID   | PK                              |
| createdAt    | Date   | 분석 일시                           |
| imagePath    | String | 로컬 저장 경로                        |
| ocrText      | String | 인식된 텍스트                         |
| toneScore    | Double | 0~100 지수                        |
| toneLabel    | String | "Positive / Neutral / Negative" |
| toneKeywords | String | 감정 키워드 리스트                      |
| modelVersion | String | OpenAI 모델명                      |

## 기술 스택

| 목적     | 기술                              |
| ------ | ------------------------------- |
| OCR    | Vision (VNRecognizeTextRequest) |
| 감정 분석  | OpenAI API (`gpt-4o-mini`)      |
| 로컬 저장  | GRDB                            |
| UI     | SwiftUI + Gauge + Charts        |
| 분석/통계  | Firebase Analytics              |
| 안정성    | Firebase Crashlytics            |
| 이미지 접근 | PHPicker / Camera               |
| 권한     | PhotosUI.Permission             |
| 공유     | ActivityViewController          |


# UI Components & Theme Colors 사용 가이드

**작성일**: 2025년 11월 12일  
**구현 완료**: Theme Colors + UI Components

---

## ✅ 구현 완료 파일

### 1. Color+Theme.swift
- **위치**: `/ToneMeter/Utilities/Extensions/Color+Theme.swift`
- **역할**: 통일된 색상 팔레트 및 헬퍼 함수

### 2. ToneMeterGauge.swift
- **위치**: `/ToneMeter/Views/Components/ToneMeterGauge.swift`
- **역할**: 재사용 가능한 감정 톤 미터기

### 3. EmotionCard.swift
- **위치**: `/ToneMeter/Views/Components/EmotionCard.swift`
- **역할**: 정보 표시 카드 컴포넌트

### 4. EmotionChart.swift
- **위치**: `/ToneMeter/Views/Components/EmotionChart.swift`
- **역할**: 간단한 막대 차트 컴포넌트

---

## 🎨 Color+Theme 사용법

### 1. 기본 색상

```swift
// Primary Colors
Color.primaryColor        // 앱 메인 컬러 (파란색)
Color.accentColor         // 앱 강조 컬러 (보라색)

// Emotion Colors
Color.emotionPositive     // 긍정적 (초록색)
Color.emotionNeutral      // 중립적 (주황색)
Color.emotionNegative     // 부정적 (빨간색)

// Background Colors
Color.cardBackground      // 카드 배경색
Color.sectionBackground   // 섹션 배경색

// Text Colors
Color.textPrimary         // 기본 텍스트
Color.textSecondary       // 보조 텍스트
Color.textTertiary        // 비활성 텍스트

// Border Colors
Color.borderColor         // 기본 테두리
Color.borderAccent        // 강조 테두리
```

### 2. 감정 색상 헬퍼 함수

#### 점수 기반 색상
```swift
let score = 75.0
let color = Color.emotionColor(for: score)
// score가 70-100: 초록색
// score가 40-69: 주황색
// score가 0-39: 빨간색
```

#### 레이블 기반 색상
```swift
let label = "Positive"
let color = Color.emotionColor(for: label)
// "positive": 초록색
// "neutral": 주황색
// "negative": 빨간색
```

### 3. 그라데이션

#### 메인 그라데이션
```swift
Text("Hello")
    .foregroundStyle(Color.gradientPrimary)
```

#### 감정 톤 그라데이션
```swift
let score = 85.0
Rectangle()
    .fill(Color.emotionGradient(score: score))
```

### 4. 그림자 Modifier

#### 카드 그림자
```swift
VStack {
    // 내용
}
.cardShadow()  // 부드러운 카드 그림자
```

#### 강조 그림자
```swift
Button("중요한 버튼") {
    // 액션
}
.accentShadow()  // 파란색 강조 그림자
```

---

## 🎯 ToneMeterGauge 사용법

### 기본 사용

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        ToneMeterGauge(score: 75)
    }
}
```

### 커스터마이징

```swift
ToneMeterGauge(
    score: 85,              // 점수 (0-100)
    size: 150,              // 크기 (기본: 200)
    lineWidth: 15,          // 선 두께 (기본: 20)
    animated: true          // 애니메이션 (기본: true)
)
```

### 실제 사용 예시

```swift
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("오늘의 감정 톤")
                .font(.headline)
            
            // 미터기
            ToneMeterGauge(score: viewModel.todayAverageScore)
            
            // 레이블
            Text(scoreLabel(viewModel.todayAverageScore))
                .font(.title3)
                .bold()
                .foregroundColor(Color.emotionColor(for: viewModel.todayAverageScore))
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(20)
        .cardShadow()
    }
    
    private func scoreLabel(_ score: Double) -> String {
        switch score {
        case 70...100: return "긍정적 😊"
        case 40..<70: return "중립적 😐"
        default: return "부정적 😢"
        }
    }
}
```

### Preview 확인

Xcode Preview에서 다양한 점수를 테스트할 수 있습니다:

```swift
#Preview("긍정적") {
    ToneMeterGauge(score: 85)
}

#Preview("중립적") {
    ToneMeterGauge(score: 55)
}

#Preview("부정적") {
    ToneMeterGauge(score: 25)
}
```

---

## 📊 EmotionCard 사용법

### 기본 사용

```swift
EmotionCard(
    title: "전체 분석",
    value: "24회",
    icon: "chart.bar.fill",
    accentColor: .blue
)
```

### 다양한 예시

```swift
VStack(spacing: 16) {
    // 전체 분석 횟수
    EmotionCard(
        title: "전체 분석",
        value: "\(viewModel.totalAnalysisCount)회",
        icon: "chart.bar.fill",
        accentColor: .blue
    )
    
    // 평균 점수
    EmotionCard(
        title: "평균 점수",
        value: "\(Int(viewModel.averageScore))점",
        icon: "star.fill",
        accentColor: .orange
    )
    
    // 가장 많은 감정
    EmotionCard(
        title: "가장 많은 감정",
        value: emotionLabel(viewModel.mostFrequentEmotion),
        icon: "face.smiling.fill",
        accentColor: Color.emotionColor(for: viewModel.mostFrequentEmotion)
    )
}
```

### 그리드 레이아웃

```swift
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible())
], spacing: 16) {
    EmotionCard(
        title: "오늘",
        value: "5회",
        icon: "calendar",
        accentColor: .blue
    )
    
    EmotionCard(
        title: "이번 주",
        value: "24회",
        icon: "calendar.badge.clock",
        accentColor: .purple
    )
}
```

---

## 📈 EmotionChart 사용법

### 기본 사용

```swift
EmotionChart(data: [
    EmotionChartData(label: "긍정적", value: 45, color: .emotionPositive),
    EmotionChartData(label: "중립적", value: 30, color: .emotionNeutral),
    EmotionChartData(label: "부정적", value: 15, color: .emotionNegative)
])
```

### 실제 데이터 연동

```swift
struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("감정 분포")
                .font(.title2)
                .bold()
            
            // 차트
            EmotionChart(data: viewModel.emotionDistribution.map { item in
                EmotionChartData(
                    label: item.label,
                    value: Double(item.count),
                    color: Color.emotionColor(for: item.label)
                )
            })
        }
        .padding()
    }
}
```

### 기간별 비교 차트

```swift
EmotionChart(data: [
    EmotionChartData(label: "이번 주", value: 72, color: .blue),
    EmotionChartData(label: "지난 주", value: 68, color: .purple),
    EmotionChartData(label: "2주 전", value: 55, color: .orange)
])
```

---

## 🎨 실제 적용 예시

### HomeView 리팩토링

#### Before (기존 코드)
```swift
private var toneMeterSection: some View {
    VStack(spacing: 16) {
        Text("오늘의 감정 톤")
            .font(.headline)
        
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                .frame(width: 200, height: 200)
            
            Circle()
                .trim(from: 0, to: viewModel.todayAverageScore / 100)
                .stroke(
                    gaugeColor(viewModel.todayAverageScore),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: viewModel.todayAverageScore)
            
            VStack(spacing: 4) {
                Text("\(Int(viewModel.todayAverageScore))")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(gaugeColor(viewModel.todayAverageScore))
                
                Text("/ 100")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        
        Text(scoreLabel(viewModel.todayAverageScore))
            .font(.title3)
            .bold()
            .foregroundColor(gaugeColor(viewModel.todayAverageScore))
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(20)
    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
}
```

#### After (새 컴포넌트 사용)
```swift
private var toneMeterSection: some View {
    VStack(spacing: 16) {
        Text("오늘의 감정 톤")
            .font(.headline)
        
        // 컴포넌트로 교체
        ToneMeterGauge(score: viewModel.todayAverageScore)
        
        Text(scoreLabel(viewModel.todayAverageScore))
            .font(.title3)
            .bold()
            .foregroundColor(Color.emotionColor(for: viewModel.todayAverageScore))
    }
    .padding()
    .background(Color.cardBackground)
    .cornerRadius(20)
    .cardShadow()
}

// 헬퍼 함수도 간소화
private func gaugeColor(_ score: Double) -> Color {
    Color.emotionColor(for: score)  // 기존 switch 문 대체
}
```

---

## 🧪 Preview에서 테스트

### Xcode Preview 활성화

1. 각 컴포넌트 파일 열기
2. Canvas 활성화 (⌥⌘↩)
3. Preview 실행

### ToneMeterGauge Preview

```swift
#Preview("긍정적") {
    ToneMeterGauge(score: 85)
}
```

Canvas에서 실시간으로 확인:
- 다양한 점수 (0-100)
- 다양한 크기 (60-300)
- 애니메이션 효과

### EmotionCard Preview

```swift
#Preview {
    VStack(spacing: 16) {
        EmotionCard(
            title: "전체 분석",
            value: "24회",
            icon: "chart.bar.fill",
            accentColor: .blue
        )
    }
    .padding()
}
```

### EmotionChart Preview

```swift
#Preview {
    EmotionChart(data: [
        EmotionChartData(label: "긍정적", value: 45, color: .emotionPositive),
        EmotionChartData(label: "중립적", value: 30, color: .emotionNeutral),
        EmotionChartData(label: "부정적", value: 15, color: .emotionNegative)
    ])
    .padding()
}
```

---

## 🌓 다크 모드 테스트

### Simulator에서 테스트

1. Settings → Display & Brightness → Dark Mode
2. 또는 Control Center에서 다크 모드 토글

### Preview에서 테스트

```swift
#Preview("라이트 모드") {
    ToneMeterGauge(score: 75)
        .environment(\.colorScheme, .light)
}

#Preview("다크 모드") {
    ToneMeterGauge(score: 75)
        .environment(\.colorScheme, .dark)
}
```

---

## 📋 체크리스트

### 구현 확인
- [x] Color+Theme.swift 생성
- [x] ToneMeterGauge.swift 생성
- [x] EmotionCard.swift 생성
- [x] EmotionChart.swift 생성
- [x] Linter 에러 없음

### Preview 확인
- [ ] ToneMeterGauge Preview 정상
- [ ] EmotionCard Preview 정상
- [ ] EmotionChart Preview 정상
- [ ] 다크 모드 Preview 정상

### 실제 적용 (선택)
- [ ] HomeView에서 ToneMeterGauge 사용
- [ ] StatisticsSection에서 EmotionCard 사용
- [ ] DetailView에서 EmotionChart 사용

---

## 🎨 색상 커스터마이징

### 색상 변경

`Color+Theme.swift` 파일에서 원하는 색상으로 변경:

```swift
// 예시: 메인 색상을 초록색으로 변경
static let primaryColor = Color.green

// 예시: 긍정적 감정을 파란색으로 변경
static let emotionPositive = Color.blue
```

### 새로운 색상 추가

```swift
extension Color {
    // 커스텀 색상 추가
    static let customHighlight = Color.yellow
    static let customWarning = Color.pink
}
```

---

## 🚀 다음 단계

1. **HomeView 리팩토링** (선택)
   - 기존 Gauge를 ToneMeterGauge로 교체
   - 색상을 Color+Theme로 통일

2. **새로운 화면에 적용**
   - DetailView에서 EmotionChart 사용
   - SettingsView에서 EmotionCard 사용

3. **다음 Todolist 항목 진행**
   - 14번: Permissions (권한 요청 로직)
   - 15번: Firebase 초기화
   - 16번: Firebase Setup Guide

---

## 💡 유용한 팁

### 1. 재사용 가능한 컴포넌트 만들기

```swift
// 점수와 레이블을 함께 표시하는 커스텀 뷰
struct ScoreCard: View {
    let score: Double
    
    var body: some View {
        VStack(spacing: 16) {
            ToneMeterGauge(score: score, size: 150)
            
            Text(scoreLabel(score))
                .font(.headline)
                .foregroundColor(Color.emotionColor(for: score))
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .cardShadow()
    }
    
    private func scoreLabel(_ score: Double) -> String {
        switch score {
        case 70...100: return "긍정적 😊"
        case 40..<70: return "중립적 😐"
        default: return "부정적 😢"
        }
    }
}
```

### 2. 애니메이션 추가

```swift
ToneMeterGauge(score: score)
    .onAppear {
        // 나타날 때 애니메이션
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            // 상태 변경
        }
    }
```

### 3. 조건부 렌더링

```swift
if viewModel.hasData {
    EmotionChart(data: viewModel.chartData)
} else {
    Text("데이터가 없습니다")
        .foregroundColor(Color.textSecondary)
}
```

---

**구현 완료 일시**: 2025년 11월 12일  
**테스트 상태**: Preview 확인 필요  
**다음 단계**: Permissions 구현

---

즐거운 코딩 되세요! 🎨✨


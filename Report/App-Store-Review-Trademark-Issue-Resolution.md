# App Store 심사 리뷰 - 상표권 위반 문제 해결 가이드

## 📋 문제 상황

**심사 리뷰 날짜**: 2024년 (예상)

**위반 항목**: Guideline 5.2.5 - Legal - Intellectual Property

**문제 내용**:
> Your app does not comply with the Guidelines for Using Apple's Trademarks and Copyrights. Specifically, your app includes:
> - iOS in the app name or subtitle in an inappropriate manner

## 🔍 원인 분석

Apple의 상표권 가이드라인에 따르면, 앱 이름이나 부제목에 "iOS"를 부적절하게 사용하는 것은 금지되어 있습니다.

### 일반적인 위반 사례:
- ❌ "ToneMeter iOS"
- ❌ "ToneMeter for iOS"
- ❌ "MyApp iOS Edition"
- ✅ "ToneMeter" 또는 "ToneMeter AI" (정상)

### 현재 프로젝트 상태 확인:
- ✅ **코드베이스 앱 이름**: "ToneMeter AI" (정상)
- ✅ **Bundle Display Name**: "ToneMeter AI" (정상)
- ⚠️ **App Store Connect 메타데이터**: 확인 필요

## 🛠️ 해결 방법

### 1단계: App Store Connect에서 앱 이름 확인

1. [App Store Connect](https://appstoreconnect.apple.com/)에 로그인
2. **내 앱** 메뉴 선택
3. ToneMeter 앱 선택
4. **앱 정보** 탭 클릭
5. 다음 항목들을 확인:

#### 확인해야 할 항목:
- **이름** (Name): 앱 이름에 "iOS"가 포함되어 있는지 확인
- **부제목** (Subtitle): 부제목에 "iOS"가 포함되어 있는지 확인
- **프로모션 텍스트** (Promotional Text): "iOS" 사용 여부 확인

### 2단계: 메타데이터 수정

#### 앱 이름 수정:
1. **앱 정보** 페이지에서 **이름** 필드 확인
2. 만약 "ToneMeter iOS" 또는 "ToneMeter for iOS" 같은 형태라면:
   - ✅ "ToneMeter" 또는 "ToneMeter AI"로 변경
3. **저장** 클릭

#### 부제목 수정:
1. **부제목** 필드 확인
2. "iOS"가 포함되어 있다면 제거
3. 예시:
   - ❌ "대화 감정 분석 iOS 앱"
   - ✅ "대화 감정 분석 앱" 또는 "AI 기반 감정 분석"

#### 프로모션 텍스트 확인:
1. **프로모션 텍스트** 필드 확인
2. "iOS"가 부적절하게 사용되었다면 제거
3. 예시:
   - ❌ "iOS에서 사용 가능한 최고의 감정 분석 앱"
   - ✅ "최고의 감정 분석 앱" 또는 "iPhone과 iPad에서 사용 가능한 감정 분석 앱"

### 3단계: 앱 설명 및 키워드 확인

1. **버전** 탭으로 이동
2. **앱 스토어 제출 정보** 섹션 확인
3. 다음 항목들 확인:

#### 앱 설명 (Description):
- "iOS"를 플랫폼 설명으로 사용하는 것은 허용됩니다
- 예: "iOS 16.0 이상에서 실행됩니다"
- 하지만 앱 이름처럼 강조하는 것은 피해야 합니다

#### 키워드 (Keywords):
- 키워드에 "iOS"를 포함하는 것은 일반적으로 문제없습니다
- 하지만 앱 이름이나 부제목에 사용하는 것과는 다릅니다

### 4단계: 스크린샷 및 앱 미리보기 확인

1. **버전** 탭의 **앱 미리보기 및 스크린샷** 섹션 확인
2. 스크린샷 이미지에 "iOS"가 앱 이름의 일부로 표시되는지 확인
3. 필요시 스크린샷 수정

### 5단계: 변경사항 저장 및 재제출

1. 모든 변경사항 **저장**
2. **버전 제출** 또는 **앱 제출** 클릭
3. 심사 제출

## 📝 수정 체크리스트

다음 항목들을 확인하고 수정했는지 체크하세요:

- [ ] App Store Connect의 **앱 이름**에서 "iOS" 제거
- [ ] App Store Connect의 **부제목**에서 "iOS" 제거 (있는 경우)
- [ ] **프로모션 텍스트**에서 부적절한 "iOS" 사용 제거
- [ ] **앱 설명**에서 "iOS"가 앱 이름처럼 사용되지 않았는지 확인
- [ ] **스크린샷**에 앱 이름으로 "iOS"가 표시되지 않는지 확인
- [ ] 모든 변경사항 저장
- [ ] 앱 재제출

## ✅ 예상 결과

수정 후:
- ✅ 앱 이름: "ToneMeter" 또는 "ToneMeter AI"
- ✅ 부제목: "대화 감정 분석 앱" (iOS 없이)
- ✅ 앱 설명: "iOS 16.0 이상에서 실행됩니다" (플랫폼 요구사항으로만 사용)

## 📚 참고 자료

### Apple 공식 문서:
- [Guidelines for Using Apple Trademarks and Copyrights](https://www.apple.com/legal/intellectual-property/guidelinesfor3rdparties.html)
- [App Store Connect Developer Help - View and edit app information](https://help.apple.com/app-store-connect/#/dev219213dfc)
- [Technical Q&A QA1823: Updating the Display Name of Your App](https://developer.apple.com/library/archive/qa/qa1823/_index.html)

### 허용되는 사용 예시:
- ✅ "iOS 16.0 이상 필요" (플랫폼 요구사항)
- ✅ "iPhone 및 iPad용" (디바이스 설명)
- ✅ "Apple의 iOS 플랫폼에서 실행" (기술적 설명)

### 금지되는 사용 예시:
- ❌ "MyApp iOS" (앱 이름)
- ❌ "MyApp for iOS" (앱 이름)
- ❌ "iOS 앱" (부제목)
- ❌ "iOS 전용" (부제목)

## 🔄 재제출 후 예상 시나리오

### 성공적인 경우:
1. Apple 심사팀이 수정사항 확인
2. 심사 통과
3. 앱스토어 출시

### 추가 문제가 있는 경우:
1. Apple이 추가 피드백 제공
2. 해당 항목 추가 수정
3. 재제출

## 💡 예방 조치

앞으로 앱을 제출할 때:
1. 앱 이름에 "iOS", "iPhone", "iPad" 같은 Apple 상표 사용 금지
2. 부제목에도 Apple 상표 사용 금지
3. 앱 설명에서는 플랫폼 요구사항으로만 사용
4. 제출 전 메타데이터 재확인

## 📞 문의

문제가 지속되거나 추가 도움이 필요한 경우:
- [Apple Developer Support](https://developer.apple.com/contact/)
- [App Store Connect 지원](https://appstoreconnect.apple.com/support)

---

**작성일**: 2024년  
**프로젝트**: ToneMeter  
**상태**: 해결 대기 중








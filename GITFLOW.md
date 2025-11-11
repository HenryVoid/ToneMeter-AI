# Gitflow 워크플로우 전략

## 📋 개요
이 프로젝트는 Gitflow 브랜치 전략을 사용합니다. 이는 체계적인 릴리즈 관리와 협업을 위한 브랜치 모델입니다.

## 🌳 브랜치 구조

### 주요 브랜치 (영구 브랜치)

#### `main`
- **목적**: 프로덕션 릴리즈용 브랜치
- **특징**: 항상 배포 가능한 상태 유지
- **규칙**: 직접 커밋 금지, `release` 또는 `hotfix` 브랜치를 통해서만 병합

#### `develop`
- **목적**: 다음 릴리즈를 위한 개발 브랜치
- **특징**: 최신 개발 변경사항 통합
- **규칙**: 기능 개발은 `feature` 브랜치에서 진행 후 병합

### 보조 브랜치 (임시 브랜치)

#### `feature/*` - 기능 개발
- **생성 기준**: `develop`
- **병합 대상**: `develop`
- **명명 규칙**: `feature/기능명` (예: `feature/login`, `feature/audio-analysis`)
- **사용법**:
  ```bash
  # 기능 브랜치 생성 및 시작
  git checkout develop
  git pull origin develop
  git checkout -b feature/new-feature
  
  # 개발 후 커밋
  git add .
  git commit -m "feat: 새로운 기능 추가"
  
  # develop에 병합
  git checkout develop
  git merge --no-ff feature/new-feature
  git push origin develop
  git branch -d feature/new-feature
  ```

#### `release/*` - 릴리즈 준비
- **생성 기준**: `develop`
- **병합 대상**: `main` 및 `develop`
- **명명 규칙**: `release/버전` (예: `release/1.0.0`)
- **사용법**:
  ```bash
  # 릴리즈 브랜치 생성
  git checkout develop
  git checkout -b release/1.0.0
  
  # 버전 업데이트 및 버그 수정
  # ...
  
  # main에 병합 및 태그
  git checkout main
  git merge --no-ff release/1.0.0
  git tag -a v1.0.0 -m "Release version 1.0.0"
  
  # develop에도 병합
  git checkout develop
  git merge --no-ff release/1.0.0
  
  # 브랜치 삭제
  git branch -d release/1.0.0
  ```

#### `hotfix/*` - 긴급 수정
- **생성 기준**: `main`
- **병합 대상**: `main` 및 `develop`
- **명명 규칙**: `hotfix/버전` (예: `hotfix/1.0.1`)
- **사용법**:
  ```bash
  # 핫픽스 브랜치 생성
  git checkout main
  git checkout -b hotfix/1.0.1
  
  # 버그 수정
  # ...
  
  # main에 병합 및 태그
  git checkout main
  git merge --no-ff hotfix/1.0.1
  git tag -a v1.0.1 -m "Hotfix version 1.0.1"
  
  # develop에도 병합
  git checkout develop
  git merge --no-ff hotfix/1.0.1
  
  # 브랜치 삭제
  git branch -d hotfix/1.0.1
  ```

## 📝 커밋 메시지 컨벤션

다음 형식을 따릅니다:

```
<타입>: <제목>

<본문> (선택사항)

<푸터> (선택사항)
```

### 타입 종류
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅, 세미콜론 누락 등
- `refactor`: 코드 리팩토링
- `test`: 테스트 코드 추가
- `chore`: 빌드 업무, 패키지 매니저 설정 등

### 예시
```
feat: 음성 분석 기능 추가

사용자의 음성을 분석하여 톤을 측정하는 기능을 구현했습니다.
- Core ML 모델 통합
- 실시간 오디오 처리
- 결과 시각화

Resolves: #123
```

## 🔄 워크플로우

### 1. 새로운 기능 개발
```bash
develop → feature/기능명 → develop
```

### 2. 릴리즈
```bash
develop → release/버전 → main (태그) + develop
```

### 3. 긴급 수정
```bash
main → hotfix/버전 → main (태그) + develop
```

## 🚀 배포 프로세스

1. `develop` 브랜치에서 기능 개발
2. 릴리즈 준비가 되면 `release` 브랜치 생성
3. QA 및 버그 수정
4. `main`에 병합 및 버전 태그
5. `develop`에도 변경사항 병합
6. App Store에 배포

## 👥 협업 규칙

1. **Pull Request 사용**: 모든 병합은 PR을 통해 진행
2. **코드 리뷰**: 최소 1명 이상의 승인 필요
3. **충돌 해결**: 로컬에서 해결 후 푸시
4. **정기적 동기화**: 작업 시작 전 항상 최신 코드 pull

## 📌 현재 브랜치 상태

- ✅ `main`: 프로덕션 브랜치
- ✅ `develop`: 개발 브랜치

## 🔗 원격 저장소

```
origin: git@github.com:HenryVoid/ToneMeter-AI.git
```

## 📚 참고 자료

- [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [Conventional Commits](https://www.conventionalcommits.org/)


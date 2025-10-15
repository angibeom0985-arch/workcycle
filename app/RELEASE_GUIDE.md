# 교대근무 달력 - 웹뷰 앱 빌드 가이드

## 개요
이 프로젝트는 웹사이트(https://workcycle.money-hotissue.com)를 Flutter 웹뷰로 감싸서 안드로이드 앱으로 만든 것입니다.

## 주요 변경사항

### 1. 앱 구조
- **이전**: Flutter 네이티브 UI (캘린더, 폼 등)
- **현재**: WebView를 통해 웹사이트 표시
- **파일**: `lib/main.dart` - 웹뷰 기반 앱으로 완전히 재작성

### 2. 앱 정보
- **패키지명**: com.workcycle.app
- **앱 이름**: 교대근무 달력
- **버전**: 1.0.0 (빌드 번호: 1)
- **최소 SDK**: 21 (Android 5.0)

### 3. 의존성
불필요한 패키지 제거:
- ❌ shared_preferences
- ❌ intl
- ❌ table_calendar

남은 패키지:
- ✅ webview_flutter: ^4.5.0
- ✅ cupertino_icons: ^1.0.8

## 플레이스토어 출시 절차

### Step 1: 키스토어 생성

```powershell
keytool -genkey -v -keystore C:\KB\Website\Workcycle\app\android\app\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**중요 정보 (안전하게 보관!):**
- 키스토어 비밀번호
- 키 비밀번호
- 키스토어 파일 위치

### Step 2: key.properties 파일 생성

`C:\KB\Website\Workcycle\app\android\key.properties` 파일을 생성하고:

```properties
storePassword=여기에_키스토어_비밀번호
keyPassword=여기에_키_비밀번호
keyAlias=upload
storeFile=upload-keystore.jks
```

⚠️ **주의**: 이 파일은 .gitignore에 포함되어 있으므로 Git에 커밋되지 않습니다.

### Step 3: 앱 아이콘 생성 (선택사항)

아이콘이 이미 준비되어 있다면 건너뛰세요.

```powershell
flutter pub run flutter_launcher_icons:main
```

### Step 4: 릴리즈 빌드 생성

#### AAB (권장 - 플레이스토어용)
```powershell
cd C:\KB\Website\Workcycle\app
flutter clean
flutter pub get
flutter build appbundle --release
```

생성 위치: `build\app\outputs\bundle\release\app-release.aab`

#### APK (테스트용)
```powershell
flutter build apk --release
```

생성 위치: `build\app\outputs\flutter-apk\app-release.apk`

### Step 5: 개인정보 처리방침 페이지 추가

웹사이트에 개인정보 처리방침 페이지를 추가해야 합니다.

1. `web/components/PrivacyPolicy.tsx` 파일이 생성되어 있습니다.
2. 라우팅을 추가하여 `/privacy-policy` 경로로 접근 가능하게 만드세요.
3. 이메일 주소를 실제 연락처로 변경하세요.
4. 웹사이트에 배포 후 URL을 플레이스토어에 등록하세요.

예시 URL: `https://workcycle.money-hotissue.com/privacy-policy`

### Step 6: Google Play Console에서 앱 등록

1. **계정 생성**
   - Google Play Console 접속 (https://play.google.com/console)
   - 개발자 계정 등록 (25달러 일회성 비용)

2. **앱 만들기**
   - "앱 만들기" 클릭
   - 앱 이름: 교대근무 달력
   - 기본 언어: 한국어
   - 앱 유형: 앱
   - 무료/유료: 무료

3. **앱 콘텐츠 작성**
   - **앱 카테고리**: 생산성
   - **개인정보 처리방침**: 웹사이트의 개인정보 처리방침 URL 입력
   - **앱 액세스 권한**: 앱이 모든 사용자에게 공개되어 있음
   - **광고**: Google AdSense 사용 여부에 따라 선택
   - **콘텐츠 등급**: 설문지 작성
   - **대상 고객**: 전체 연령 또는 특정 연령대 선택

4. **스토어 등록정보**
   
   **짧은 설명 (80자):**
   ```
   3교대, 4교대 등 교대근무 스케줄을 쉽게 관리하세요. 주간/야간 근무일과 휴무일을 자동으로 달력에 표시합니다.
   ```

   **전체 설명:**
   ```
   교대근무 달력은 3교대, 4교대 등 다양한 교대근무 패턴을 쉽게 관리할 수 있는 무료 앱입니다.

   주요 기능:
   ✅ 3교대, 4교대 등 다양한 근무 패턴 지원
   ✅ 주간/야간 근무 자동 표시
   ✅ 휴무일 자동 계산
   ✅ 직관적인 달력 보기
   ✅ 근무 패턴 사용자 정의
   ✅ 간편한 데이터 관리

   이런 분들께 추천합니다:
   - 3교대, 4교대 등 교대근무를 하시는 분
   - 근무 스케줄 관리가 필요하신 분
   - 주간/야간 근무 일정을 한눈에 보고 싶으신 분

   사용 방법:
   1. 시작 근무일 선택
   2. 근무 패턴 입력 (예: 주간 2일, 야간 2일, 휴무 2일)
   3. 자동으로 생성되는 달력 확인

   간편하게 교대근무 일정을 관리하세요!
   ```

5. **그래픽 에셋**
   
   필요한 이미지:
   - **앱 아이콘**: 512 x 512px (PNG, 32비트)
   - **피처 그래픽**: 1024 x 500px (PNG 또는 JPG)
   - **스크린샷**: 최소 2장, 최대 8장
     - 크기: 1080 x 1920px (세로) 또는 1920 x 1080px (가로)

   스크린샷 캡처 방법:
   - 에뮬레이터에서 앱 실행
   - 주요 화면 캡처 (메인 화면, 근무 패턴 설정 화면 등)

6. **프로덕션 출시**
   - "프로덕션" 트랙 선택
   - "출시 만들기" 클릭
   - AAB 파일 업로드 (`app-release.aab`)
   - 출시 이름: v1.0.0
   - 출시 노트 작성:
     ```
     첫 번째 릴리스입니다.
     - 교대근무 달력 기능
     - 근무 패턴 관리
     - 직관적인 UI
     ```
   - 검토 후 출시

### Step 7: 출시 후 확인

출시 승인까지 보통 며칠이 소요됩니다. 검토 과정에서 문제가 발견되면 이메일로 통보받게 됩니다.

## 앱 업데이트 방법

### 버전 업데이트

1. **pubspec.yaml** 수정:
```yaml
version: 1.0.1+2  # 버전명+빌드번호
```

2. **android/app/build.gradle.kts** 수정:
```kotlin
versionCode = 2
versionName = "1.0.1"
```

3. **빌드 및 업로드**:
```powershell
flutter clean
flutter pub get
flutter build appbundle --release
```

4. Google Play Console에서 새 버전 업로드

## 테스트

### 디버그 빌드로 테스트
```powershell
# 에뮬레이터 시작
C:\Android\emulator\emulator.exe -avd Pixel_6_API_36

# 앱 실행
flutter run -d emulator-5554
```

### 릴리즈 APK로 테스트
```powershell
flutter build apk --release
```

생성된 APK를 물리적 기기에 설치하여 테스트하세요.

## 문제 해결

### 빌드 오류
```powershell
flutter clean
flutter pub get
flutter doctor
```

### 키스토어 분실
⚠️ **키스토어 파일과 비밀번호는 절대 잃어버리면 안 됩니다!**
분실 시 새로운 앱으로 등록해야 하며, 기존 앱을 업데이트할 수 없습니다.

백업 위치:
- 키스토어 파일: 안전한 클라우드 저장소
- 비밀번호: 비밀번호 관리자

### 서명 오류
`key.properties` 파일이 올바른 위치(`android/` 폴더)에 있는지 확인하세요.

## 참고 자료

- [Flutter 공식 문서 - Android 배포](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android 앱 서명](https://developer.android.com/studio/publish/app-signing)
- [WebView Flutter 플러그인](https://pub.dev/packages/webview_flutter)

## 연락처

문의사항이 있으시면 [이메일 주소]로 연락 주세요.

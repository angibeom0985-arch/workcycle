# 교대근무 달력 - 플레이스토어 출시 가이드

## 앱 정보

### 기본 정보
- **앱 이름**: 교대근무 달력
- **패키지명**: com.workcycle.app
- **카테고리**: 생산성 (Productivity)
- **가격**: 무료

### 앱 설명

#### 짧은 설명 (80자 이내)
3교대, 4교대 등 교대근무 스케줄을 쉽게 관리하세요. 주간/야간 근무일과 휴무일을 자동으로 달력에 표시합니다.

#### 전체 설명
교대근무 달력은 3교대, 4교대 등 다양한 교대근무 패턴을 쉽게 관리할 수 있는 무료 앱입니다.

**주요 기능:**
- ✅ 3교대, 4교대 등 다양한 근무 패턴 지원
- ✅ 주간/야간 근무 자동 표시
- ✅ 휴무일 자동 계산
- ✅ 직관적인 달력 보기
- ✅ 근무 패턴 사용자 정의
- ✅ 간편한 데이터 관리

**이런 분들께 추천합니다:**
- 3교대, 4교대 등 교대근무를 하시는 분
- 근무 스케줄 관리가 필요하신 분
- 주간/야간 근무 일정을 한눈에 보고 싶으신 분

**사용 방법:**
1. 시작 근무일 선택
2. 근무 패턴 입력 (예: 주간 2일, 야간 2일, 휴무 2일)
3. 자동으로 생성되는 달력 확인

간편하게 교대근무 일정을 관리하세요!

## 필요한 스크린샷 (2-8장)

플레이스토어에 등록하려면 다음 크기의 스크린샷이 필요합니다:
- 최소 2장, 최대 8장
- 크기: 1080 x 1920px (세로) 또는 1920 x 1080px (가로)
- 형식: PNG 또는 JPG

스크린샷 캡처 방법:
1. 에뮬레이터에서 앱 실행
2. 주요 화면들 캡처:
   - 메인 달력 화면
   - 근무 패턴 설정 화면
   - 근무 스케줄 표시 화면

## 아이콘 이미지

- **고해상도 아이콘**: 512 x 512px PNG (32비트, 알파 채널 포함)
- **피처 그래픽**: 1024 x 500px PNG 또는 JPG

## 개인정보 처리방침

플레이스토어 출시를 위해서는 개인정보 처리방침 URL이 필요합니다.
웹사이트에 개인정보 처리방침 페이지를 만들고 해당 URL을 제공해야 합니다.

예시 URL: https://workcycle.money-hotissue.com/privacy-policy

### 개인정보 처리방침 내용 예시:

```
교대근무 달력 개인정보 처리방침

1. 수집하는 개인정보
   - 본 앱은 사용자의 개인정보를 수집하지 않습니다.
   - 모든 데이터는 사용자 기기에 로컬로 저장됩니다.

2. 개인정보의 이용 목적
   - 앱 기능 제공 외에 개인정보를 이용하지 않습니다.

3. 개인정보의 제3자 제공
   - 본 앱은 제3자에게 개인정보를 제공하지 않습니다.

4. 개인정보의 보유 및 이용 기간
   - 앱 삭제 시 모든 데이터가 함께 삭제됩니다.

5. 문의
   - 이메일: [your-email@example.com]
```

## 출시 체크리스트

### 1. 키스토어 생성
- [ ] `android/KEYSTORE_GUIDE.md` 참고하여 키스토어 생성
- [ ] `android/key.properties` 파일 생성

### 2. 릴리즈 빌드 생성
```powershell
cd C:\KB\Website\Workcycle\app
flutter clean
flutter pub get
flutter build appbundle
```

생성된 파일 위치: `build/app/outputs/bundle/release/app-release.aab`

### 3. Google Play Console 준비
- [ ] Google Play Console 계정 생성 (25달러 등록비 필요)
- [ ] 새 앱 만들기
- [ ] 앱 이름, 설명 입력
- [ ] 스크린샷 업로드
- [ ] 개인정보 처리방침 URL 입력
- [ ] 콘텐츠 등급 받기
- [ ] 대상 고객 선택

### 4. AAB 파일 업로드
- [ ] 프로덕션 트랙에 AAB 파일 업로드
- [ ] 버전 이름 및 변경사항 입력
- [ ] 출시 검토 및 승인 대기

## 테스트

실제 출시 전에 내부 테스트 트랙에서 먼저 테스트하는 것을 권장합니다.

```powershell
# 디버그 빌드로 테스트
flutter run -d emulator-5554

# 릴리즈 빌드 APK로 테스트
flutter build apk --release
```

## 업데이트 방법

앱 업데이트 시:
1. `pubspec.yaml`에서 버전 번호 증가
2. `android/app/build.gradle.kts`에서 versionCode, versionName 업데이트
3. 새 AAB 파일 빌드
4. Google Play Console에서 업데이트 출시

## 참고 자료

- [Flutter 앱 출시 가이드](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android 앱 서명](https://developer.android.com/studio/publish/app-signing)

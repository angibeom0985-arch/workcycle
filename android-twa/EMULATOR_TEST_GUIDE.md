# 🧪 Android 에뮬레이터 테스트 가이드

## 📋 사전 준비

### 1. Android Studio 프로젝트 생성 확인
```powershell
# 프로젝트 존재 확인
Test-Path "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp"
```

**결과가 `False`인 경우:**
- `QUICK_START.md` 2단계를 먼저 진행하세요 (프로젝트 생성)

---

## 🎯 빠른 에뮬레이터 테스트 (5분)

### 방법 1: Android Studio 통합 테스트 (추천)

#### 1️⃣ Android Studio에서 프로젝트 열기
1. Android Studio 실행
2. **Open** 클릭
3. `C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp` 선택
4. **OK** 클릭
5. Gradle Sync 완료 대기

#### 2️⃣ 에뮬레이터 생성 (없는 경우)
1. 상단 도구 모음 → **Device Manager** 아이콘 클릭
2. **Create Device** 클릭
3. 디바이스 선택:
   - **Phone** → **Pixel 7** (추천)
   - **Next** 클릭
4. System Image 선택:
   - **Android 14.0 (UpsideDownCake)** 또는 최신 버전
   - **Download** 클릭 (처음 사용 시)
   - 다운로드 완료 후 **Next**
5. 설정 확인:
   - AVD Name: `Pixel_7_API_34`
   - **Finish** 클릭

#### 3️⃣ 앱 실행
1. 에뮬레이터 선택 (상단 드롭다운)
2. **Run** 버튼 (▶️) 클릭 또는 `Shift + F10`
3. 에뮬레이터 부팅 대기 (약 30초~1분)
4. 앱 자동 설치 및 실행

---

### 방법 2: PowerShell + ADB 명령어

#### 1️⃣ Debug APK 빌드
```powershell
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp"

# Debug APK 빌드
.\gradlew assembleDebug

# 빌드 성공 확인
if (Test-Path "app\build\outputs\apk\debug\app-debug.apk") {
    Write-Host "✅ APK 빌드 완료!" -ForegroundColor Green
    Write-Host "📦 위치: app\build\outputs\apk\debug\app-debug.apk"
} else {
    Write-Host "❌ 빌드 실패!" -ForegroundColor Red
}
```

#### 2️⃣ 에뮬레이터 실행 확인
```powershell
# 실행 중인 에뮬레이터 확인
adb devices

# 출력 예시:
# List of devices attached
# emulator-5554    device
```

**에뮬레이터가 없는 경우:**
- Android Studio → **Device Manager** → 에뮬레이터 선택 → **Play** 버튼

#### 3️⃣ APK 설치
```powershell
# APK 설치
adb install -r "app\build\outputs\apk\debug\app-debug.apk"

# 출력:
# Performing Streamed Install
# Success
```

#### 4️⃣ 앱 실행
```powershell
# 앱 실행
adb shell am start -n com.workcycle.app.debug/com.google.androidbrowserhelper.trusted.LauncherActivity

# 또는 에뮬레이터 앱 드로어에서 "Workcycle" 앱 찾아서 클릭
```

---

## 🔍 테스트 체크리스트

### ✅ 앱 시작 테스트
- [ ] 앱 아이콘이 보이는가?
- [ ] 앱을 탭하면 실행되는가?
- [ ] 스플래시 스크린이 표시되는가?

### ✅ TWA 기능 테스트
- [ ] 웹사이트가 전체 화면으로 로드되는가?
- [ ] 주소창이 숨겨져 있는가?
- [ ] 상태 표시줄 색상이 설정한 파란색인가?
- [ ] 웹사이트 내비게이션이 정상 작동하는가?

### ✅ 페이지 전환 테스트
- [ ] '근무 패턴 설정' 페이지가 로드되는가?
- [ ] '완료' 버튼을 누르면 '/calendar'로 이동하는가?
- [ ] '설정 수정' 버튼으로 다시 돌아가는가?
- [ ] 뒤로 가기 버튼이 작동하는가?

### ✅ 광고 테스트
- [ ] 하단 앵커 광고가 표시되는가?
- [ ] 광고가 콘텐츠를 가리지 않는가?
- [ ] 광고가 페이지 전환 시에도 유지되는가?

---

## 🐛 문제 해결

### 앱이 설치되지 않음
```powershell
# 기존 앱 제거 후 재설치
adb uninstall com.workcycle.app.debug
adb install "app\build\outputs\apk\debug\app-debug.apk"
```

### 앱이 브라우저로 열림 (TWA 미작동)
**원인:** Digital Asset Links가 설정되지 않음

**해결:**
1. `assetlinks.json`이 웹사이트에 배포되었는지 확인:
   ```
   https://workcycle.money-hotissue.com/.well-known/assetlinks.json
   ```

2. SHA-256이 정확한지 확인:
   ```powershell
   # Debug 키의 SHA-256 추출
   keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```

3. Debug용 assetlinks.json에 SHA-256 추가:
   ```json
   {
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "com.workcycle.app.debug",
       "sha256_cert_fingerprints": [
         "DEBUG_SHA256_HERE"
       ]
     }
   }
   ```

### 에뮬레이터가 느림
```powershell
# 하드웨어 가속 확인
# Android Studio → Settings → Tools → Emulator
# "Use hardware acceleration" 체크
```

### Gradle 빌드 오류
```powershell
# 캐시 정리
cd WorkcycleApp
.\gradlew clean
.\gradlew assembleDebug --refresh-dependencies
```

---

## 📱 에뮬레이터 단축키

| 키 | 기능 |
|---|---|
| `Ctrl + M` | 메뉴 열기 |
| `Ctrl + Left/Right` | 화면 회전 |
| `Ctrl + H` | 홈 버튼 |
| `Ctrl + B` | 뒤로 가기 |
| `Ctrl + O` | 최근 앱 |

---

## 🎥 로그 확인

### 앱 로그 실시간 확인
```powershell
# Workcycle 앱의 로그만 필터링
adb logcat -s "chromium" -s "TWA"

# 또는 Android Studio Logcat 창 사용
```

### 크래시 로그 확인
```powershell
adb logcat -b crash
```

---

## 📸 스크린샷 캡처 (Play Store용)

```powershell
# 스크린샷 저장
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png .

# 또는 에뮬레이터에서 Ctrl + S
```

**Play Store 요구사항:**
- 최소 2개, 최대 8개
- 형식: PNG 또는 JPG
- 크기: 320px~3840px (긴 쪽 기준)

---

## 🚀 다음 단계

에뮬레이터 테스트가 성공하면:

### 1. Release APK/AAB 빌드
```powershell
# Release AAB 빌드 (Play Store용)
.\gradlew bundleRelease

# 출력: app/build/outputs/bundle/release/app-release.aab
```

### 2. 실제 기기 테스트
```powershell
# USB 디버깅 활성화 후
adb devices
adb install "app\build\outputs\apk\debug\app-debug.apk"
```

### 3. Play Store 업로드
- AAB 파일 업로드
- 스크린샷 추가
- 앱 설명 작성
- 검토 제출

---

## ✅ 테스트 완료 체크리스트

- [ ] Debug APK 빌드 성공
- [ ] 에뮬레이터에서 앱 실행 성공
- [ ] TWA가 전체 화면으로 표시됨
- [ ] 모든 페이지 전환 정상 작동
- [ ] 광고가 올바르게 표시됨
- [ ] 뒤로 가기/홈 버튼 정상 작동
- [ ] 로그에 오류 없음
- [ ] 스크린샷 캡처 완료 (Play Store용)

---

**테스트가 성공하면 `Release AAB`를 빌드하고 Play Store에 업로드하세요!** 🎉

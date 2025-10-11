# 🚀 Workcycle Android APK/AAB 빠른 빌드 가이드

**목표: 30분 안에 APK/AAB 파일 생성하기**

---

## ⚡ 빠른 시작 (5단계)

### 1️⃣ 키스토어 생성 (3분)

```powershell
# PowerShell 관리자 권한으로 실행
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa"

# 키스토어 생성
keytool -genkey -v -keystore workcycle-release.keystore -alias workcycle -keyalg RSA -keysize 2048 -validity 10000
```

**입력할 정보:**

- 비밀번호: `workcycle2025!` (예시 - 본인만 아는 비밀번호 사용)
- 이름: `Workcycle`
- 조직: `Workcycle`
- 도시: `Seoul`
- 국가: `KR`

**SHA-256 추출:**

```powershell
keytool -list -v -keystore workcycle-release.keystore -alias workcycle
```

출력에서 `SHA256:` 값을 복사하세요! (예: `A1:B2:C3:...`)

---

### 2️⃣ Android Studio 프로젝트 생성 (5분)

**Android Studio 실행:**
- 시작 메뉴: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio`
- 또는 PowerShell: `Start-Process "C:\Program Files\Android\Android Studio\bin\studio64.exe"`

**프로젝트 생성:**
1. **New Project** 클릭
2. **Empty Views Activity** 선택
3. 설정:
   - Name: `WorkcycleApp`
   - Package: `com.workcycle.app`
   - Location: `C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp`
   - Language: `Kotlin`
   - Minimum SDK: `API 24`

---

### 3️⃣ 설정 파일 복사 (10분)

#### A. `app/build.gradle.kts` 수정

`android-twa/build.gradle.kts.template` 파일의 내용을 복사하여 붙여넣기.

**⚠️ 중요: 비밀번호 수정**

```kotlin
storePassword = "workcycle2025!"  // 1단계에서 설정한 비밀번호
keyPassword = "workcycle2025!"     // 동일한 비밀번호
```

#### B. `app/src/main/AndroidManifest.xml` 수정

`android-twa/AndroidManifest.xml.template` 파일의 내용으로 전체 교체.

#### C. `app/src/main/res/values/colors.xml` 생성

`android-twa/colors.xml.template` 파일의 내용을 복사하여 생성.

#### D. `app/src/main/res/xml/file_paths.xml` 생성

1. `app/src/main/res/` 폴더에 `xml` 폴더 생성
2. `android-twa/file_paths.xml.template` 파일의 내용을 복사하여 생성

---

### 4️⃣ Gradle Sync (2분)

Android Studio에서:

1. 상단 메뉴 → **File** → **Sync Project with Gradle Files**
2. 또는 알림 배너에서 **Sync Now** 클릭
3. 완료 대기 (약 1-2분)

---

### 5️⃣ APK/AAB 빌드 (5분)

#### 방법 1: 자동 스크립트 사용 ⭐ 추천

```powershell
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa"
.\build.ps1
```

메뉴에서 선택:

- `3` → Release AAB (Play Store용)
- `4` → 전체 빌드 (Debug + Release)

#### 방법 2: Android Studio 사용

**Release AAB 빌드:**

1. 메뉴: **Build** → **Generate Signed Bundle / APK**
2. **Android App Bundle** 선택 → **Next**
3. 키스토어 정보 입력:
   - Key store path: `C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\workcycle-release.keystore`
   - Key store password: `workcycle2025!`
   - Key alias: `workcycle`
   - Key password: `workcycle2025!`
4. **Next** → **release** 선택 → **Create**

**출력 위치:**

- AAB: `WorkcycleApp/app/build/outputs/bundle/release/app-release.aab`
- APK: `WorkcycleApp/app/build/outputs/apk/release/app-release.apk`

---

## 📦 빌드 결과

빌드가 성공하면 다음 파일들이 생성됩니다:

| 파일              | 크기 (예상) | 용도                 |
| ----------------- | ----------- | -------------------- |
| `app-debug.apk`   | ~5-10MB     | 테스트용 (서명 없음) |
| `app-release.apk` | ~5-10MB     | 직접 배포용 (서명됨) |
| `app-release.aab` | ~3-7MB      | Play Store 업로드용  |

---

## 🎯 다음 단계

### 테스트:

```powershell
# 에뮬레이터 또는 실제 기기에 설치
adb install "WorkcycleApp/app/build/outputs/apk/debug/app-debug.apk"
```

### Digital Asset Links 설정:

1. `public/.well-known/assetlinks.json` 파일 생성:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.workcycle.app",
      "sha256_cert_fingerprints": [
        "A1:B2:C3:D4:E5:..." // 1단계에서 추출한 SHA-256
      ]
    }
  }
]
```

2. Git에 커밋 및 푸시:

```powershell
git add public/.well-known/assetlinks.json
git commit -m "Add Digital Asset Links for Android TWA"
git push origin main
```

3. 확인:

```
https://workcycle.money-hotissue.com/.well-known/assetlinks.json
```

### Play Store 업로드:

1. [Google Play Console](https://play.google.com/console) 접속
2. 새 앱 만들기
3. `app-release.aab` 업로드
4. 앱 정보 입력 (아이콘, 스크린샷 등)
5. 검토 제출

---

## 🐛 문제 해결

### Gradle 빌드 실패:

```powershell
cd WorkcycleApp
./gradlew clean
./gradlew --refresh-dependencies
```

### 키스토어 경로 오류:

`build.gradle.kts`에서 상대 경로 확인:

```kotlin
storeFile = file("../../workcycle-release.keystore")
```

### 서명 오류:

- 비밀번호가 정확한지 확인
- 키스토어 파일이 올바른 위치에 있는지 확인

---

## ✅ 최종 체크리스트

- [ ] 키스토어 생성 완료 (`workcycle-release.keystore`)
- [ ] SHA-256 추출 완료
- [ ] Android Studio 프로젝트 생성
- [ ] `build.gradle.kts` 설정 (비밀번호 포함)
- [ ] `AndroidManifest.xml` 설정
- [ ] `colors.xml` 및 `file_paths.xml` 생성
- [ ] Gradle Sync 성공
- [ ] APK/AAB 빌드 성공
- [ ] `assetlinks.json` 웹사이트 배포

---

**🎉 빌드 성공! 이제 Play Store에 업로드할 준비가 되었습니다!**

더 자세한 내용은 `BUILD_GUIDE.md`를 참고하세요.

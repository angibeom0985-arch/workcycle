# Android APK/AAB 빌드 가이드

## 📋 사전 요구사항

- Android Studio (최신 버전)
- JDK 17 이상
- 프로젝트 폴더: `android-twa/WorkcycleApp`

---

## 🚀 1단계: 키스토어 생성

### Windows PowerShell에서 실행:

```powershell
# 프로젝트 디렉토리로 이동
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa"

# 키스토어 생성 (JDK keytool 사용)
keytool -genkey -v -keystore workcycle-release.keystore -alias workcycle -keyalg RSA -keysize 2048 -validity 10000

# 정보 입력:
# - 비밀번호: [안전한 비밀번호 입력 및 기억]
# - 이름: Workcycle
# - 조직 단위: Development
# - 조직: Workcycle
# - 도시: Seoul
# - 시/도: Seoul
# - 국가 코드: KR
```

### SHA-256 Fingerprint 추출:

```powershell
keytool -list -v -keystore workcycle-release.keystore -alias workcycle

# 출력에서 SHA256 값을 복사 (예: A1:B2:C3:...)
```

---

## 🔧 2단계: Android Studio 프로젝트 설정

### 2-1. 새 프로젝트 생성

1. Android Studio 실행
2. **File** → **New** → **New Project**
3. **Empty Views Activity** 선택
4. 설정:
   - Name: `WorkcycleApp`
   - Package name: `com.workcycle.app`
   - Save location: `C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp`
   - Language: `Kotlin`
   - Minimum SDK: `API 24 (Android 7.0)`
5. **Finish** 클릭

### 2-2. build.gradle.kts (Project level) 수정

파일 위치: `WorkcycleApp/build.gradle.kts`

```kotlin
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
}
```

### 2-3. build.gradle.kts (Module: app) 수정

파일 위치: `WorkcycleApp/app/build.gradle.kts`

```kotlin
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.workcycle.app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.workcycle.app"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            // 키스토어 경로 (상대 경로 또는 절대 경로)
            storeFile = file("../../workcycle-release.keystore")
            storePassword = "YOUR_KEYSTORE_PASSWORD" // 실제 비밀번호로 변경
            keyAlias = "workcycle"
            keyPassword = "YOUR_KEY_PASSWORD" // 실제 비밀번호로 변경
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    // AndroidX Browser Helper for TWA
    implementation("com.google.androidbrowserhelper:androidbrowserhelper:2.5.0")

    // Core Android dependencies
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}
```

### 2-4. AndroidManifest.xml 수정

파일 위치: `WorkcycleApp/app/src/main/AndroidManifest.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.WorkcycleApp"
        tools:targetApi="31">

        <!-- Trusted Web Activity -->
        <activity
            android:name="com.google.androidbrowserhelper.trusted.LauncherActivity"
            android:label="@string/app_name"
            android:exported="true"
            android:launchMode="singleTask">

            <meta-data
                android:name="android.support.customtabs.trusted.DEFAULT_URL"
                android:value="https://workcycle.money-hotissue.com" />

            <meta-data
                android:name="android.support.customtabs.trusted.STATUS_BAR_COLOR"
                android:resource="@color/colorPrimary" />

            <meta-data
                android:name="android.support.customtabs.trusted.NAVIGATION_BAR_COLOR"
                android:resource="@color/colorPrimary" />

            <meta-data
                android:name="android.support.customtabs.trusted.SPLASH_IMAGE_DRAWABLE"
                android:resource="@drawable/ic_launcher_foreground" />

            <meta-data
                android:name="android.support.customtabs.trusted.SPLASH_SCREEN_BACKGROUND_COLOR"
                android:resource="@color/colorPrimary" />

            <meta-data
                android:name="android.support.customtabs.trusted.SPLASH_SCREEN_FADE_OUT_DURATION"
                android:value="300" />

            <meta-data
                android:name="android.support.customtabs.trusted.FILE_PROVIDER_AUTHORITY"
                android:value="com.workcycle.app.fileprovider" />

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data
                    android:scheme="https"
                    android:host="workcycle.money-hotissue.com" />
            </intent-filter>
        </activity>

        <!-- File Provider for downloads -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.workcycle.app.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>

    </application>

</manifest>
```

### 2-5. colors.xml 생성

파일 위치: `WorkcycleApp/app/src/main/res/values/colors.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorPrimary">#2563EB</color>
    <color name="colorPrimaryDark">#1E40AF</color>
    <color name="colorAccent">#3B82F6</color>
</resources>
```

### 2-6. file_paths.xml 생성

파일 위치: `WorkcycleApp/app/src/main/res/xml/file_paths.xml`

디렉토리 생성 후:

```powershell
New-Item -ItemType Directory -Path "WorkcycleApp/app/src/main/res/xml" -Force
```

파일 내용:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path name="external_files" path="." />
    <cache-path name="cache" path="." />
</paths>
```

---

## 📦 3단계: APK/AAB 빌드

### Debug APK 빌드 (테스트용)

```powershell
# Android Studio Terminal 또는 PowerShell에서:
cd "WorkcycleApp"
./gradlew assembleDebug

# 출력 위치:
# WorkcycleApp/app/build/outputs/apk/debug/app-debug.apk
```

### Release AAB 빌드 (Play Store 배포용)

```powershell
# Android Studio Terminal 또는 PowerShell에서:
cd "WorkcycleApp"
./gradlew bundleRelease

# 출력 위치:
# WorkcycleApp/app/build/outputs/bundle/release/app-release.aab
```

### Release APK 빌드 (직접 배포용)

```powershell
cd "WorkcycleApp"
./gradlew assembleRelease

# 출력 위치:
# WorkcycleApp/app/build/outputs/apk/release/app-release.apk
```

---

## 🔐 4단계: Digital Asset Links 설정

### SHA-256 확인 후 assetlinks.json 생성

파일 위치: `public/.well-known/assetlinks.json`

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.workcycle.app",
      "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT_HERE"]
    }
  }
]
```

웹사이트에 배포 후 확인:

```
https://workcycle.money-hotissue.com/.well-known/assetlinks.json
```

---

## 🧪 5단계: 테스트

### 에뮬레이터에서 테스트:

1. Android Studio → **Device Manager** → 에뮬레이터 생성/실행
2. Terminal:

```powershell
# Debug APK 설치
adb install "WorkcycleApp/app/build/outputs/apk/debug/app-debug.apk"

# 앱 실행
adb shell am start -n com.workcycle.app.debug/com.google.androidbrowserhelper.trusted.LauncherActivity
```

### 실제 기기에서 테스트:

1. USB 디버깅 활성화
2. USB로 연결
3. 위 명령어 실행 (`.debug` 제거)

---

## 📤 6단계: Play Store 업로드

### 준비물:

- ✅ `app-release.aab` 파일
- ✅ Google Play Console 계정 ($25 등록비)
- ✅ 앱 아이콘 (512x512 PNG)
- ✅ 스크린샷 (최소 2개)
- ✅ 개인정보처리방침 URL

### 업로드:

1. [Google Play Console](https://play.google.com/console) 접속
2. **앱 만들기** 클릭
3. AAB 파일 업로드
4. 스토어 등록정보 작성
5. 검토 제출

---

## 🎯 빌드 요약

| 빌드 타입   | 명령어                      | 용도        | 출력 위치                        |
| ----------- | --------------------------- | ----------- | -------------------------------- |
| Debug APK   | `./gradlew assembleDebug`   | 개발/테스트 | `apk/debug/app-debug.apk`        |
| Release APK | `./gradlew assembleRelease` | 직접 배포   | `apk/release/app-release.apk`    |
| Release AAB | `./gradlew bundleRelease`   | Play Store  | `bundle/release/app-release.aab` |

---

## 🐛 문제 해결

### Gradle 빌드 오류:

```powershell
# Gradle 캐시 정리
./gradlew clean
./gradlew --refresh-dependencies
```

### 서명 오류:

- `build.gradle.kts`의 키스토어 경로 및 비밀번호 확인
- 키스토어 파일이 올바른 위치에 있는지 확인

### TWA가 Chrome 앱처럼 열리지 않음:

- `assetlinks.json` 파일이 웹사이트에 올바르게 배포되었는지 확인
- SHA-256 fingerprint가 정확한지 확인
- Chrome에서 `chrome://flags/#enable-twa` 활성화

---

## ✅ 체크리스트

- [ ] 키스토어 생성 완료
- [ ] SHA-256 추출 완료
- [ ] Android Studio 프로젝트 생성
- [ ] build.gradle.kts 설정 완료
- [ ] AndroidManifest.xml 설정 완료
- [ ] assetlinks.json 배포 완료
- [ ] Debug APK 빌드 및 테스트
- [ ] Release AAB 빌드 완료
- [ ] Play Store 업로드 준비

---

**빌드 성공을 기원합니다! 🚀**

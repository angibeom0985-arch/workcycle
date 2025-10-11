# Android Studio로 TWA 앱 만들기 - 완벽 가이드

## 📱 웹사이트를 Android 앱으로 변환하기

이 가이드는 Android Studio를 사용하여 **workcycle.money-hotissue.com**을 네이티브 Android 앱으로 만드는 전체 과정을 다룹니다.

---

## ✅ 사전 준비

### 필요한 것:
- ✅ Windows 10/11 (64-bit)
- ✅ 최소 8GB RAM (16GB 권장)
- ✅ 10GB 이상 여유 공간
- ✅ 인터넷 연결

### 설치할 것:
1. ✅ **Android Studio** (필수)
2. ✅ **JDK** (Android Studio에 포함)

---

## 📥 1단계: Android Studio 설치

### 1-1. Android Studio 다운로드

1. **공식 웹사이트 방문**
   ```
   https://developer.android.com/studio
   ```

2. **"Download Android Studio" 클릭**
   - 약 1GB 크기
   - 라이선스 동의 필요

3. **설치 파일 실행**
   ```
   android-studio-2024.x.x.x-windows.exe
   ```

### 1-2. 설치 과정

1. **Setup Wizard 시작**
   - "Next" 클릭

2. **컴포넌트 선택**
   - ✅ Android Studio
   - ✅ Android Virtual Device (에뮬레이터)
   - "Next" 클릭

3. **설치 위치 선택**
   - 기본값: `C:\Program Files\Android\Android Studio`
   - "Next" → "Install"

4. **SDK 설치**
   - 자동으로 Android SDK 다운로드 시작
   - 약 3-5GB (시간 소요)

5. **완료**
   - "Finish" 클릭
   - Android Studio 실행

### 1-3. 초기 설정

1. **Welcome to Android Studio**
   - "Next" 클릭

2. **Install Type**
   - "Standard" 선택
   - "Next"

3. **UI Theme**
   - "Darcula" (어두운 테마) 또는 "Light" 선택
   - "Next"

4. **SDK 컴포넌트 다운로드**
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
   - "Finish" 클릭 (다운로드 시작)

---

## 🚀 2단계: TWA 프로젝트 생성

### 2-1. 새 프로젝트 시작

1. **Android Studio 실행**
   - "New Project" 클릭

2. **템플릿 선택**
   - "Empty Views Activity" 선택
   - "Next"

3. **프로젝트 설정**
   ```
   Name: Workcycle
   Package name: com.workcycle.app
   Save location: C:\Users\삼성\AndroidStudioProjects\Workcycle
   Language: Java
   Minimum SDK: API 21 (Android 5.0)
   Build configuration language: Kotlin DSL
   ```
   - "Finish" 클릭

4. **Gradle 동기화 대기**
   - 프로젝트 생성 및 초기화 (약 2-3분)

### 2-2. TWA 라이브러리 추가

1. **build.gradle.kts (Module :app) 열기**
   - 좌측 Project 패널에서 `app` → `build.gradle.kts`

2. **dependencies 섹션에 추가**
   ```kotlin
   dependencies {
       // 기존 dependencies...
       
       // TWA (Trusted Web Activity) 라이브러리
       implementation("com.google.androidbrowserhelper:androidbrowserhelper:2.5.0")
   }
   ```

3. **Sync Now 클릭**
   - 상단에 나타나는 알림에서 "Sync Now"

### 2-3. AndroidManifest.xml 수정

1. **AndroidManifest.xml 열기**
   - `app` → `src` → `main` → `AndroidManifest.xml`

2. **전체 내용 교체**
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <manifest xmlns:android="http://schemas.android.com/apk/res/android"
       xmlns:tools="http://schemas.android.com/tools">

       <!-- 인터넷 권한 -->
       <uses-permission android:name="android.permission.INTERNET" />

       <application
           android:allowBackup="true"
           android:icon="@mipmap/ic_launcher"
           android:label="워크사이클"
           android:roundIcon="@mipmap/ic_launcher_round"
           android:supportsRtl="true"
           android:theme="@style/Theme.Workcycle"
           tools:targetApi="31">

           <!-- TWA Activity -->
           <activity
               android:name="com.google.androidbrowserhelper.trusted.LauncherActivity"
               android:exported="true"
               android:theme="@style/Theme.Workcycle">
               
               <!-- Main launcher -->
               <intent-filter>
                   <action android:name="android.intent.action.MAIN" />
                   <category android:name="android.intent.category.LAUNCHER" />
               </intent-filter>

               <!-- URL handling -->
               <intent-filter android:autoVerify="true">
                   <action android:name="android.intent.action.VIEW" />
                   <category android:name="android.intent.category.DEFAULT" />
                   <category android:name="android.intent.category.BROWSABLE" />
                   
                   <data
                       android:scheme="https"
                       android:host="workcycle.money-hotissue.com" />
               </intent-filter>

               <!-- Meta-data -->
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
                   android:resource="@drawable/splash" />
               
               <meta-data
                   android:name="android.support.customtabs.trusted.SPLASH_SCREEN_BACKGROUND_COLOR"
                   android:resource="@color/colorPrimary" />
               
               <meta-data
                   android:name="android.support.customtabs.trusted.SPLASH_SCREEN_FADE_OUT_DURATION"
                   android:value="300" />
           </activity>

           <!-- Digital Asset Links -->
           <meta-data
               android:name="asset_statements"
               android:resource="@string/asset_statements" />
       </application>
   </manifest>
   ```

### 2-4. 색상 및 리소스 설정

1. **colors.xml 수정**
   - `res` → `values` → `colors.xml`
   
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <color name="colorPrimary">#2563eb</color>
       <color name="colorPrimaryDark">#1e40af</color>
       <color name="colorAccent">#3b82f6</color>
       <color name="white">#FFFFFF</color>
       <color name="black">#000000</color>
   </resources>
   ```

2. **strings.xml에 Asset Links 추가**
   - `res` → `values` → `strings.xml`
   
   ```xml
   <resources>
       <string name="app_name">워크사이클</string>
       <string name="asset_statements">
           [{
               \"relation\": [\"delegate_permission/common.handle_all_urls\"],
               \"target\": {
                   \"namespace\": \"web\",
                   \"site\": \"https://workcycle.money-hotissue.com\"
               }
           }]
       </string>
   </resources>
   ```

3. **스플래시 이미지 추가**
   - `res` → `drawable` 폴더에서 우클릭
   - New → Drawable Resource File
   - File name: `splash.xml`
   
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <layer-list xmlns:android="http://schemas.android.com/apk/res/android">
       <item android:drawable="@color/colorPrimary" />
       <item>
           <bitmap
               android:gravity="center"
               android:src="@mipmap/ic_launcher" />
       </item>
   </layer-list>
   ```

---

## 🔐 3단계: Digital Asset Links 설정

### 3-1. SHA-256 Fingerprint 생성

1. **키스토어 생성 (최초 1회)**
   - Android Studio 상단 메뉴
   - Build → Generate Signed Bundle / APK
   - APK 선택 → Next
   - Create new... 클릭

2. **키스토어 정보 입력**
   ```
   Key store path: C:\Users\삼성\workcycle-keystore.jks
   Password: [안전한 비밀번호 입력]
   
   Key:
   Alias: workcycle
   Password: [안전한 비밀번호 입력]
   Validity: 25 years
   
   Certificate:
   First and Last Name: Your Name
   Organizational Unit: Workcycle
   Organization: Workcycle
   City: Seoul
   State: Seoul
   Country Code: KR
   ```
   - OK → Remember passwords 체크
   - Next

3. **SHA-256 확인**
   - Terminal (하단) 열기
   
   ```bash
   keytool -list -v -keystore C:\Users\삼성\workcycle-keystore.jks -alias workcycle
   ```
   
   - SHA-256 값 복사 (예: `AA:BB:CC:DD:...`)

### 3-2. assetlinks.json 업데이트

1. **기존 assetlinks.json 파일 열기**
   - `public\.well-known\assetlinks.json`

2. **내용 업데이트**
   ```json
   [{
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "com.workcycle.app",
       "sha256_cert_fingerprints": [
         "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
       ]
     }
   }]
   ```
   - SHA-256 값을 실제 값으로 교체

3. **Vercel에 배포**
   ```bash
   git add public/.well-known/assetlinks.json
   git commit -m "Update assetlinks.json with Android app SHA-256"
   git push origin main
   ```

4. **검증**
   - 브라우저에서 확인:
   ```
   https://workcycle.money-hotissue.com/.well-known/assetlinks.json
   ```

---

## 🏗️ 4단계: 앱 아이콘 설정

### 4-1. Image Asset Studio 사용

1. **우클릭 res 폴더**
   - New → Image Asset

2. **Icon Type 선택**
   - Launcher Icons (Adaptive and Legacy)

3. **Foreground Layer**
   - Path: `public\android-chrome-512x512.png` 선택
   - Resize: 80%

4. **Background Layer**
   - Color: `#2563eb`

5. **Next → Finish**

---

## 📦 5단계: APK/AAB 빌드

### 5-1. Debug APK 빌드 (테스트용)

1. **메뉴에서 선택**
   - Build → Build Bundle(s) / APK(s) → Build APK(s)

2. **빌드 완료 대기**
   - 우측 하단에 "APK(s) generated successfully" 알림

3. **APK 위치**
   ```
   app\build\outputs\apk\debug\app-debug.apk
   ```

4. **에뮬레이터 또는 실제 기기에 설치**
   - "locate" 클릭하여 파일 위치 확인

### 5-2. Release AAB 빌드 (Play Store용)

1. **메뉴에서 선택**
   - Build → Generate Signed Bundle / APK

2. **Android App Bundle 선택**
   - AAB 선택 → Next

3. **키스토어 선택**
   - 이전에 생성한 키스토어 선택
   - 비밀번호 입력
   - Next

4. **빌드 타입 선택**
   - ✅ release
   - ❌ V1 (Jar Signature)
   - ✅ V2 (Full APK Signature)
   - Create

5. **AAB 위치**
   ```
   app\build\outputs\bundle\release\app-release.aab
   ```

---

## 🧪 6단계: 에뮬레이터 테스트

### 6-1. AVD (Android Virtual Device) 생성

1. **Device Manager 열기**
   - 우측 상단 툴바에서 Device Manager 아이콘 클릭

2. **Create Device**
   - Phone → Pixel 6 선택
   - Next

3. **System Image 선택**
   - Release Name: Tiramisu (API 33)
   - Download 클릭 (최초 1회)
   - Next

4. **AVD 설정**
   ```
   AVD Name: Pixel_6_API_33
   Startup orientation: Portrait
   ```
   - Finish

### 6-2. 앱 실행

1. **에뮬레이터 시작**
   - Device Manager에서 Play 버튼 클릭

2. **앱 실행**
   - 상단 Run 버튼 (▶️) 클릭
   - 또는 `Shift + F10`

3. **테스트**
   - 앱이 에뮬레이터에서 실행됨
   - 웹사이트가 전체 화면으로 표시됨

---

## 📲 7단계: 실제 기기 테스트

### 7-1. USB 디버깅 활성화

1. **Android 기기에서**
   - 설정 → 휴대전화 정보
   - 빌드 번호 7번 연속 탭
   - "개발자 모드 활성화됨" 메시지 확인

2. **개발자 옵션**
   - 설정 → 개발자 옵션
   - USB 디버깅 활성화

### 7-2. 기기 연결

1. **USB 케이블 연결**
   - 컴퓨터와 Android 기기 연결

2. **USB 디버깅 허용**
   - 기기에서 "USB 디버깅 허용" 팝업
   - "허용" 클릭

3. **Android Studio에서 확인**
   - 상단 Device Selector에서 기기 확인
   - 예: "Samsung Galaxy S21"

4. **앱 실행**
   - Run 버튼 클릭
   - 실제 기기에서 앱 실행 및 테스트

---

## 🎯 최종 체크리스트

### 앱 기능 테스트
- [ ] 앱 아이콘 표시 확인
- [ ] 스플래시 화면 표시
- [ ] 메인 페이지 로드 (근무 패턴 설정)
- [ ] "완료" 버튼 → 달력 페이지
- [ ] "설정 수정" 버튼 작동
- [ ] 뒤로 가기 버튼 작동
- [ ] 앵커 광고 표시
- [ ] 오프라인 기능 (Service Worker)
- [ ] 데이터 저장 (LocalStorage)

### Digital Asset Links
- [ ] assetlinks.json 접근 가능
- [ ] SHA-256 정확히 입력
- [ ] Package name 일치 (com.workcycle.app)
- [ ] URL 바 숨겨짐 (TWA 정상 작동)

### 빌드 파일
- [ ] app-debug.apk 생성 (테스트용)
- [ ] app-release.aab 생성 (Play Store용)
- [ ] 키스토어 파일 안전하게 백업
- [ ] 비밀번호 안전하게 보관

---

## 📤 8단계: Play Store 업로드

### 8-1. Google Play Console

1. **Play Console 접속**
   ```
   https://play.google.com/console
   ```

2. **새 앱 만들기**
   - "앱 만들기" 클릭
   - 앱 이름: 워크사이클
   - 언어: 한국어
   - 앱/게임: 앱
   - 무료/유료: 무료

3. **AAB 업로드**
   - 프로덕션 → 새 버전 만들기
   - AAB 파일 업로드 (`app-release.aab`)
   - 버전 이름: 1.0
   - 변경사항: "첫 번째 출시"

4. **스토어 등록 정보**
   - 짧은 설명
   - 전체 설명
   - 스크린샷 (최소 2개)
   - 아이콘 (512x512)

5. **검토 제출**
   - 모든 필수 항목 완료
   - "검토를 위해 제출" 클릭
   - 승인 대기 (1-3일)

---

## 🔧 문제 해결

### Gradle 동기화 실패
```
File → Invalidate Caches → Invalidate and Restart
```

### AVD 실행 안 됨
```
BIOS에서 가상화 활성화 필요:
- Intel: VT-x
- AMD: AMD-V
```

### SHA-256 오류
```
키스토어 경로 확인
비밀번호 정확히 입력
```

### URL 바가 표시됨 (TWA 실패)
```
1. assetlinks.json 접근 확인
2. SHA-256 정확성 확인
3. Package name 일치 확인
4. 24시간 대기 (Google 캐시)
```

---

## 📝 요약

### 전체 프로세스:
```
Android Studio 설치
    ↓
TWA 프로젝트 생성
    ↓
키스토어 생성 (SHA-256)
    ↓
assetlinks.json 업데이트
    ↓
APK 빌드 (테스트)
    ↓
에뮬레이터 테스트
    ↓
AAB 빌드 (출시)
    ↓
Play Store 업로드
    ↓
승인 및 출시
```

### 소요 시간:
- Android Studio 설치: 30분
- 프로젝트 생성 및 설정: 1시간
- 테스트 및 디버깅: 1-2시간
- Play Store 승인: 1-3일

**총 소요 시간: 약 3-4시간 (승인 제외)**

---

## 🎉 완료!

이제 워크사이클이 완전한 Android 앱이 되었습니다!

- ✅ 네이티브 앱 경험
- ✅ Play Store에서 다운로드 가능
- ✅ 오프라인 지원
- ✅ 푸시 알림 준비 (선택사항)

**다음 단계**: Play Store 최적화 및 마케팅! 🚀

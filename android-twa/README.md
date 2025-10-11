# 📱 Workcycle Android TWA (Trusted Web Activity)

이 폴더에는 Workcycle 웹앱을 네이티브 Android 앱으로 변환하기 위한 파일들이 포함되어 있습니다.

---

## 📁 폴더 구조

```
android-twa/
├── BUILD_GUIDE.md                 # 상세 빌드 가이드
├── QUICK_START.md                 # ⭐ 빠른 시작 가이드 (30분)
├── README.md                      # 이 파일
├── build.ps1                      # 자동 빌드 스크립트
├── build.gradle.kts.template      # Gradle 설정 템플릿
├── AndroidManifest.xml.template   # 앱 매니페스트 템플릿
├── colors.xml.template            # 색상 리소스 템플릿
├── file_paths.xml.template        # 파일 경로 설정 템플릿
├── assetlinks.json.template       # Digital Asset Links 템플릿
├── workcycle-release.keystore     # (생성 후) 릴리즈 키스토어
└── WorkcycleApp/                  # (생성 후) Android Studio 프로젝트
    ├── app/
    │   ├── src/
    │   ├── build.gradle.kts
    │   └── ...
    ├── gradle/
    └── build.gradle.kts
```

---

## 🚀 시작하기

### 처음 시작하는 경우:
1. **[QUICK_START.md](QUICK_START.md)** 를 열어서 30분 가이드를 따라하세요!
2. 5단계만 따라하면 APK/AAB 파일이 생성됩니다.

### 자세한 설명이 필요한 경우:
- **[BUILD_GUIDE.md](BUILD_GUIDE.md)** 를 참고하세요.
- 모든 단계별 상세 설명과 문제 해결 방법이 포함되어 있습니다.

---

## ⚡ 빠른 빌드 (이미 설정 완료한 경우)

```powershell
# PowerShell에서 실행
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa"
.\build.ps1
```

또는 수동으로:
```powershell
cd WorkcycleApp

# Debug APK
./gradlew assembleDebug

# Release AAB (Play Store용)
./gradlew bundleRelease

# Release APK (직접 배포용)
./gradlew assembleRelease
```

---

## 📦 빌드 결과물

빌드가 성공하면 다음 위치에 파일이 생성됩니다:

### Debug APK (테스트용)
```
WorkcycleApp/app/build/outputs/apk/debug/app-debug.apk
```

### Release APK (직접 배포용)
```
WorkcycleApp/app/build/outputs/apk/release/app-release.apk
```

### Release AAB (Play Store용) ⭐
```
WorkcycleApp/app/build/outputs/bundle/release/app-release.aab
```

---

## 🔐 중요 파일

### 키스토어 파일
- **파일**: `workcycle-release.keystore`
- **중요도**: ⚠️ 매우 중요!
- **보관**: 안전한 곳에 백업 필수
- **용도**: 앱 서명 및 업데이트에 필요

⚠️ **주의**: 이 파일을 잃어버리면 Play Store에서 앱을 업데이트할 수 없습니다!

### 비밀번호
`build.gradle.kts`에 입력한 비밀번호를 안전하게 보관하세요:
- `storePassword`: 키스토어 비밀번호
- `keyPassword`: 키 비밀번호

---

## 🌐 Digital Asset Links

TWA가 제대로 작동하려면 웹사이트에 `assetlinks.json` 파일이 필요합니다.

### 1. SHA-256 추출:
```powershell
keytool -list -v -keystore workcycle-release.keystore -alias workcycle
```

### 2. assetlinks.json 생성:
`assetlinks.json.template`을 복사하여 SHA-256 값을 입력하세요.

### 3. 웹사이트에 배포:
파일 위치: `public/.well-known/assetlinks.json`

```powershell
# Workcycle 프로젝트 루트에서
mkdir -p public/.well-known
cp android-twa/assetlinks.json public/.well-known/
git add public/.well-known/assetlinks.json
git commit -m "Add Digital Asset Links for Android TWA"
git push origin main
```

### 4. 확인:
브라우저에서 접속:
```
https://workcycle.money-hotissue.com/.well-known/assetlinks.json
```

---

## 🧪 테스트

### 에뮬레이터 설치:
```powershell
adb install "WorkcycleApp/app/build/outputs/apk/debug/app-debug.apk"
```

### 실제 기기 설치:
1. USB 디버깅 활성화
2. USB로 연결
3. 위 명령어 실행

### 실행:
```powershell
adb shell am start -n com.workcycle.app/com.google.androidbrowserhelper.trusted.LauncherActivity
```

---

## 📤 Play Store 배포

### 준비물:
- ✅ `app-release.aab` 파일
- ✅ Google Play Console 계정 ($25 등록비)
- ✅ 앱 아이콘 (512x512 PNG)
- ✅ 스크린샷 (최소 2개, 최대 8개)
- ✅ 개인정보처리방침 URL

### 업로드:
1. [Google Play Console](https://play.google.com/console) 접속
2. **앱 만들기** 클릭
3. 앱 정보 입력
4. **프로덕션** → **새 버전 만들기**
5. `app-release.aab` 업로드
6. 버전 정보 입력
7. 검토 제출

---

## 🐛 문제 해결

### 빌드 실패:
```powershell
cd WorkcycleApp
./gradlew clean
./gradlew --refresh-dependencies
./gradlew bundleRelease
```

### TWA가 브라우저로 열림:
- `assetlinks.json`이 웹사이트에 올바르게 배포되었는지 확인
- SHA-256 fingerprint가 정확한지 확인
- 앱을 제거하고 다시 설치

### 키스토어 오류:
- `build.gradle.kts`의 경로와 비밀번호 확인
- 키스토어 파일이 올바른 위치에 있는지 확인

---

## 📚 추가 자료

### 공식 문서:
- [Android Developers - TWA](https://developer.android.com/docs/quality-guidelines/building-pwa)
- [Chrome Developers - TWA](https://developer.chrome.com/docs/android/trusted-web-activity/)
- [Google Play Console](https://play.google.com/console)

### 도구:
- [Digital Asset Links Tester](https://developers.google.com/digital-asset-links/tools/generator)
- [APK Analyzer](https://developer.android.com/studio/build/apk-analyzer)

---

## ✅ 체크리스트

빌드 전:
- [ ] Android Studio 설치 완료
- [ ] JDK 17 이상 설치 완료
- [ ] 키스토어 생성 완료

빌드 후:
- [ ] Debug APK 테스트 완료
- [ ] Release AAB 생성 완료
- [ ] assetlinks.json 배포 완료
- [ ] TWA 동작 확인 완료

Play Store:
- [ ] Google Play Console 계정 준비
- [ ] 앱 아이콘 준비 (512x512)
- [ ] 스크린샷 준비 (최소 2개)
- [ ] 개인정보처리방침 URL 준비
- [ ] AAB 업로드 완료

---

## 📞 지원

문제가 발생하면:
1. **QUICK_START.md** 다시 확인
2. **BUILD_GUIDE.md**의 문제 해결 섹션 참고
3. Gradle 캐시 정리: `./gradlew clean`

---

**🎉 즐거운 앱 개발 되세요!**

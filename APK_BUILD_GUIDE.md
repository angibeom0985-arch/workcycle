# AAB/APK 생성 및 테스트 가이드

## 🚀 가장 쉬운 방법: PWABuilder (Android Studio 불필요)

### 1단계: PWABuilder로 APK/AAB 생성

1. **PWABuilder 웹사이트 접속**
   ```
   https://www.pwabuilder.com
   ```

2. **URL 입력 및 분석**
   - URL 입력란에: `https://workcycle.money-hotissue.com`
   - "Start" 버튼 클릭
   - PWA 분석 완료 대기 (약 30초)

3. **Android 패키지 생성**
   - "Package For Stores" 버튼 클릭
   - "Android" 옵션 선택
   - 앱 정보 입력:
     ```
     Package ID: com.workcycle.app
     App name: 워크사이클
     Launcher name: 워크사이클
     Theme color: #2563eb
     Background color: #ffffff
     Start URL: /
     Manifest URL: /site.webmanifest
     ```

4. **서명 옵션 선택**
   - **옵션 A**: "I have a signing key" (이미 키가 있는 경우)
   - **옵션 B**: "Generate a new signing key" (새로 생성) ✨ **권장**
     - PWABuilder가 자동으로 키 생성
     - 키 파일 다운로드 및 안전하게 보관 ⚠️

5. **다운로드**
   - **APK 파일**: 즉시 설치 가능한 파일 (테스트용)
   - **AAB 파일**: Google Play Store 업로드용
   - **서명 키**: 향후 업데이트를 위해 반드시 보관!

---

## 📱 Android Studio 없이 에뮬레이터 테스트하는 방법

### 방법 1: Genymotion (추천 - 가볍고 빠름)

1. **Genymotion 다운로드**
   ```
   https://www.genymotion.com/download/
   ```
   - Genymotion Personal Edition (무료) 선택

2. **가상 기기 생성**
   - Genymotion 실행
   - "+" 버튼 클릭
   - 기기 선택 (예: Samsung Galaxy S20)
   - 다운로드 및 생성

3. **APK 설치**
   - 가상 기기 실행
   - APK 파일을 에뮬레이터 창에 드래그 앤 드롭
   - 자동으로 설치됨

---

### 방법 2: BlueStacks (가장 쉬움)

1. **BlueStacks 다운로드**
   ```
   https://www.bluestacks.com/ko/index.html
   ```

2. **설치 및 실행**
   - BlueStacks 설치 (약 5분 소요)
   - Google 계정으로 로그인 (선택사항)

3. **APK 설치**
   - 방법 A: APK 파일을 BlueStacks 창에 드래그
   - 방법 B: "APK 설치" 버튼 클릭 후 파일 선택
   - 방법 C: Play Store에서 "File Manager" 앱 설치 후 APK 실행

---

### 방법 3: Windows Subsystem for Android (WSA)

**Windows 11 전용**

1. **WSA 설치**
   ```powershell
   # Microsoft Store에서 설치
   Amazon Appstore 검색 및 설치
   ```

2. **개발자 모드 활성화**
   - 설정 → 개발자 옵션 → 개발자 모드 ON

3. **ADB로 APK 설치**
   ```powershell
   # ADB 설치 (Platform Tools)
   # https://developer.android.com/tools/releases/platform-tools
   
   # APK 설치
   adb connect 127.0.0.1:58526
   adb install workcycle.apk
   ```

---

### 방법 4: 실제 Android 기기로 테스트 (가장 정확함)

1. **USB 디버깅 활성화**
   - 설정 → 휴대전화 정보 → 빌드 번호 7번 탭
   - 설정 → 개발자 옵션 → USB 디버깅 ON

2. **APK 전송**
   - **방법 A**: USB 케이블로 연결 후 파일 복사
   - **방법 B**: 이메일/메신저로 APK 전송
   - **방법 C**: Google Drive/Dropbox 업로드

3. **APK 설치**
   - 파일 관리자에서 APK 파일 실행
   - "알 수 없는 출처" 허용
   - 설치 완료

---

## 🔨 직접 APK 생성 (고급 - Android Studio 사용)

필요한 경우에만 사용하세요. PWABuilder가 훨씬 쉽습니다!

### 1단계: Bubblewrap CLI 설치

```powershell
# Node.js 필요 (이미 설치됨)
npm install -g @bubblewrap/cli
```

### 2단계: Java JDK 설치

```powershell
# Chocolatey 사용 (선택)
choco install openjdk11

# 또는 직접 다운로드
# https://adoptium.net/
```

### 3단계: Android SDK 설치

```powershell
# Android Studio 없이 Command Line Tools만 설치
# https://developer.android.com/studio#command-tools

# 환경 변수 설정
$env:ANDROID_HOME = "C:\Android\sdk"
$env:PATH += ";$env:ANDROID_HOME\cmdline-tools\latest\bin"
```

### 4단계: TWA 프로젝트 생성

```powershell
# 프로젝트 폴더 생성
mkdir workcycle-android
cd workcycle-android

# Bubblewrap 초기화
bubblewrap init --manifest https://workcycle.money-hotissue.com/site.webmanifest

# 앱 정보 입력 (대화형)
# - Package ID: com.workcycle.app
# - App name: 워크사이클
# 등등...
```

### 5단계: APK/AAB 빌드

```powershell
# APK 생성 (테스트용)
bubblewrap build

# AAB 생성 (Play Store용)
bubblewrap build --release

# 생성된 파일 위치
# APK: app-release-signed.apk
# AAB: app-release-bundle.aab
```

---

## 📦 생성된 파일 설명

### APK (Android Package)
- **용도**: 직접 설치 및 테스트
- **크기**: 약 5-10MB
- **장점**: 
  - 즉시 설치 가능
  - 에뮬레이터/실제 기기에서 테스트
  - 베타 테스터에게 배포 가능
- **단점**: Play Store에 직접 업로드 불가

### AAB (Android App Bundle)
- **용도**: Google Play Store 업로드
- **크기**: 약 3-7MB (더 작음)
- **장점**:
  - 기기별 최적화된 APK 생성
  - 앱 크기 감소
  - Play Store 필수 포맷
- **단점**: 직접 설치 불가 (Play Store 통해서만)

---

## 🧪 테스트 체크리스트

에뮬레이터/실제 기기에서 확인할 사항:

### 기본 기능
- [ ] 앱 아이콘 표시
- [ ] 스플래시 스크린 (로딩 화면)
- [ ] 앱 이름: "워크사이클"
- [ ] 메인 화면 (근무 패턴 설정) 로드

### 네비게이션
- [ ] "완료" 버튼 → 달력 페이지 이동
- [ ] "설정 수정" 버튼 → 설정 페이지 돌아가기
- [ ] 안드로이드 뒤로 가기 버튼 작동

### UI/UX
- [ ] 앵커 광고 표시 (하단)
- [ ] 버튼이 광고에 가려지지 않음
- [ ] 터치 반응 부드러움
- [ ] 텍스트 가독성

### 데이터 저장
- [ ] 근무 패턴 입력
- [ ] 앱 종료 후 재실행 → 데이터 유지
- [ ] LocalStorage 정상 작동

### 오프라인
- [ ] 비행기 모드에서 앱 실행
- [ ] Service Worker 캐싱 확인
- [ ] 오프라인에서 기본 기능 작동

### 권한
- [ ] 인터넷 권한 (광고 로드)
- [ ] 불필요한 권한 요청 없음

---

## 🎯 권장 워크플로우

### 개발 단계
```
1. 로컬 개발: npm run dev
   ↓
2. 브라우저 DevTools로 모바일 테스트
   ↓
3. Vercel 배포
   ↓
4. 실제 모바일 브라우저에서 PWA 테스트
```

### 앱 출시 단계
```
1. PWABuilder로 APK 생성
   ↓
2. BlueStacks/Genymotion에서 APK 테스트
   ↓
3. PWABuilder로 AAB 생성
   ↓
4. Google Play Console에 AAB 업로드
   ↓
5. 내부 테스트 → 비공개 테스트 → 프로덕션 출시
```

---

## 💡 팁

### APK 서명 키 관리
- **절대 잃어버리지 마세요!** 
- 백업 3곳에 저장 (클라우드, 외장하드, USB)
- 패스워드 안전하게 보관
- 키를 잃으면 앱 업데이트 불가능!

### 테스트 디바이스
- 최소 2-3개 기기에서 테스트 권장
- 다양한 화면 크기 (소형, 중형, 대형)
- 다양한 Android 버전 (8.0+)

### 성능 최적화
- Lighthouse 점수 90+ 목표
- 초기 로딩 시간 < 3초
- 부드러운 애니메이션 (60fps)

---

## 🆘 문제 해결

### APK 설치 실패
- "알 수 없는 출처" 허용 확인
- 충분한 저장 공간 확인
- APK 파일 손상 여부 확인

### 앱이 실행되지 않음
- 인터넷 연결 확인 (첫 실행 시 필요)
- Digital Asset Links 설정 확인
- 도메인 HTTPS 인증서 확인

### 데이터가 사라짐
- LocalStorage 권한 확인
- 앱 캐시 삭제되지 않았는지 확인

---

## 📞 다음 단계

1. **지금 바로**: https://www.pwabuilder.com 방문
2. **URL 입력**: https://workcycle.money-hotissue.com
3. **APK 다운로드**: 5분 내 완료
4. **BlueStacks 설치**: https://www.bluestacks.com
5. **APK 테스트**: 드래그 앤 드롭으로 설치

**AAB 파일도 함께 다운로드하여 Play Store 출시 준비!** 🎉

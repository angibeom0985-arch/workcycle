# 워크사이클 - 플레이스토어 배포 가이드

## PWA가 완성되었습니다! 🎉

웹사이트가 이제 완전한 PWA(Progressive Web App)가 되었으며, Android 앱으로 패키징할 준비가 완료되었습니다.

### ✅ 완료된 작업

1. **향상된 Web App Manifest** (`site.webmanifest`)
   - 앱 이름, 설명, 아이콘
   - 스크린샷 및 바로가기
   - 카테고리 및 방향 설정

2. **Service Worker** (`sw.js`)
   - 오프라인 지원
   - 자동 캐싱
   - 빠른 로딩 속도

3. **Digital Asset Links** (`.well-known/assetlinks.json`)
   - TWA(Trusted Web Activity) 지원
   - 도메인 인증

---

## 🚀 플레이스토어 배포 방법

### 방법 1: PWA Builder (권장 - 가장 쉬움)

1. **PWA Builder 사이트 방문**
   - https://www.pwabuilder.com 접속

2. **PWA 분석**
   ```
   URL 입력: https://workcycle.money-hotissue.com
   "Start" 버튼 클릭
   ```

3. **Android 패키지 생성**
   - "Package For Stores" 클릭
   - "Android" 선택
   - 필요한 정보 입력:
     - Package ID: `com.workcycle.app` (원하는 ID로 변경)
     - App name: `워크사이클`
     - Launcher name: `워크사이클`
   - "Generate" 클릭

4. **서명 키 생성**
   - Signing key 생성 (자동)
   - 키 정보 안전하게 보관 ⚠️ **매우 중요!**

5. **AAB 파일 다운로드**
   - `.aab` 파일 다운로드 (Android App Bundle)
   - 이 파일을 플레이스토어에 업로드

---

### 방법 2: Bubblewrap CLI (개발자용)

1. **Bubblewrap 설치**
   ```bash
   npm install -g @bubblewrap/cli
   ```

2. **Android Studio 및 Java 설치**
   - Android Studio 다운로드: https://developer.android.com/studio
   - Java JDK 설치 확인

3. **TWA 프로젝트 초기화**
   ```bash
   bubblewrap init --manifest https://workcycle.money-hotissue.com/site.webmanifest
   ```

4. **앱 빌드**
   ```bash
   bubblewrap build
   ```

5. **AAB 파일 위치**
   - `./app-release-bundle.aab` 생성됨

---

## 📱 플레이스토어 콘솔 설정

### 1. Google Play Console 계정 생성
- https://play.google.com/console 접속
- 개발자 계정 생성 (일회성 $25 등록 비용)

### 2. 새 앱 만들기
1. "앱 만들기" 클릭
2. 앱 세부정보 입력:
   - **앱 이름**: 워크사이클
   - **기본 언어**: 한국어
   - **앱 또는 게임**: 앱
   - **무료 또는 유료**: 무료

### 3. 스토어 등록 정보 작성
- **짧은 설명** (80자):
  ```
  3교대, 4교대 근무표를 자동으로 생성하고 관리하는 스마트 교대근무 달력
  ```

- **전체 설명** (4000자):
  ```
  워크사이클은 교대근무자를 위한 필수 앱입니다.
  
  🔄 주요 기능:
  • 3교대, 4교대 등 다양한 근무 패턴 지원
  • 주간/야간/휴무일 자동 계산
  • 직관적인 달력 보기
  • 오프라인 사용 가능
  • 광고 없는 깔끔한 인터페이스 (또는 최소한의 광고)
  
  💼 이런 분들께 추천합니다:
  • 교대근무를 하시는 모든 분
  • 간호사, 공장 근로자, 보안요원
  • 근무 스케줄 관리가 필요한 분
  
  📅 사용법:
  1. 근무 패턴 설정 (주간/야간/휴무 일수)
  2. 패턴 시작일 선택
  3. 자동으로 생성되는 달력 확인
  
  ✨ 특징:
  • 빠르고 가벼운 앱
  • 개인정보 수집 없음
  • 무료 사용
  ```

### 4. 그래픽 에셋 업로드
필요한 이미지:
- **앱 아이콘**: 512x512px (이미 있음: `android-chrome-512x512.png`)
- **스크린샷**: 최소 2개 (휴대전화용, 1080x1920px 권장)
- **배너 이미지**: 1024x500px (선택사항)

### 5. 앱 콘텐츠 등록
- **개인정보처리방침 URL**: 필요시 작성
- **앱 카테고리**: 생산성 / 도구
- **콘텐츠 등급**: EVERYONE (모든 연령)
- **대상 국가**: 대한민국 (또는 전 세계)

### 6. AAB 파일 업로드
1. "프로덕션" 또는 "내부 테스트" 트랙 선택
2. "새 버전 만들기" 클릭
3. AAB 파일 업로드
4. 버전 정보 입력
5. "검토" 클릭

### 7. 출시 검토 및 제출
- 모든 필수 항목 완료 확인
- "프로덕션으로 출시" 클릭
- Google 검토 대기 (보통 1-3일 소요)

---

## 📋 체크리스트

배포 전 확인사항:

- [ ] PWA가 HTTPS에서 작동 (Vercel 배포 완료)
- [ ] Service Worker 정상 작동
- [ ] Manifest 파일 올바르게 설정
- [ ] 아이콘 이미지 준비 (192x192, 512x512)
- [ ] 스크린샷 준비 (최소 2개)
- [ ] 개인정보처리방침 작성 (필요시)
- [ ] Google Play Console 계정 생성
- [ ] AAB 파일 생성
- [ ] 서명 키 안전하게 보관

---

## 🔧 업데이트 방법

앱을 업데이트하려면:

1. **웹사이트 업데이트**
   - 코드 수정 후 GitHub 푸시
   - Vercel이 자동으로 배포

2. **PWA는 자동 업데이트**
   - Service Worker가 자동으로 새 버전 감지
   - 사용자가 앱을 다시 열면 업데이트 적용

3. **앱 스토어 업데이트 (필요시)**
   - 주요 변경사항이 있을 때만
   - 새 AAB 생성 → Play Console 업로드

---

## 💡 추가 최적화 팁

### 성능 최적화
- Service Worker 캐시 전략 개선
- 이미지 최적화 (WebP 포맷)
- Code splitting 적용

### 사용자 경험
- 설치 프롬프트 추가
- 푸시 알림 (선택사항)
- 앱 업데이트 알림

### SEO 및 발견성
- 구조화된 데이터 추가
- 메타 태그 최적화 (이미 완료)
- Open Graph 이미지 (이미 완료)

---

## 🆘 문제 해결

### PWA Builder에서 오류 발생 시
- Manifest URL 확인: `https://workcycle.money-hotissue.com/site.webmanifest`
- Service Worker URL 확인: `https://workcycle.money-hotissue.com/sw.js`
- HTTPS 인증서 확인

### Play Console 거부 사유
- 개인정보처리방침 누락 → 추가 작성
- 스크린샷 부족 → 최소 2개 업로드
- 콘텐츠 등급 미완료 → 설문 작성

### 앱이 열리지 않을 때
- Digital Asset Links 확인
- 도메인과 패키지 ID 일치 확인
- `assetlinks.json` 접근 가능 여부 확인

---

## 📞 지원

문제가 발생하면:
1. PWA Builder 문서: https://docs.pwabuilder.com
2. Bubblewrap 문서: https://github.com/GoogleChromeLabs/bubblewrap
3. Google Play Console 지원: https://support.google.com/googleplay/android-developer

---

**🎉 축하합니다!** 
이제 플레이스토어에 앱을 출시할 준비가 완료되었습니다!

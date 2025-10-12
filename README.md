# 📱 Workcycle - 교대근무 달력

3교대, 4교대 등 교대근무 스케줄을 쉽게 관리하는 멀티플랫폼 앱

**🌐 웹사이트**: https://workcycle.money-hotissue.com

---

## 🚀 프로젝트 구조 (Monorepo)

```
Workcycle/
├── web/              # 웹 앱 (React + TypeScript + Vite)
├── app/              # Flutter 모바일 앱 (Android + iOS)
└── README.md
```

## 🌐 웹 앱 개발

**기술 스택**: React 18, TypeScript, Vite, Tailwind CSS

```bash
cd web
npm install
npm run dev
```

**배포**: Vercel (자동 배포)

---

## 📱 모바일 앱 개발

**기술 스택**: Flutter 3.35+, Dart 3.9+

```bash
cd app
flutter pub get
flutter run
```

**지원 플랫폼**: Android, iOS, Web, Windows, macOS, Linux

## 🎯 주요 기능

- 📅 **근무 패턴 설정**: 주간/야간/휴무 일수 설정
- 📆 **캘린더 뷰**: 월별 근무 스케줄 표시
- 💾 **자동 저장**: 로컬 저장소에 설정 저장
- 🎨 **색상 구분**: 근무 유형별 시각적 구분
  - 🟡 주간 근무
  - 🟣 야간 근무
  - 🔴 휴무

---

## 📦 배포

### 웹 배포
```bash
cd web
git add .
git commit -m "message"
git push origin main
```
→ Vercel 자동 배포

### Android 배포
```bash
cd app
flutter build appbundle
```
→ Google Play Console 업로드

---

## 📄 라이선스

MIT License

---

## 👤 개발자

**GitHub**: https://github.com/angibeom0985-arch/workcycle
   - Follow DNS instructions provided by Vercel to point your domain (usually add CNAME or ALIAS records).

Notes:

- The project already includes a `vercel.json` for static builds and an `index.css` prepared for Tailwind.
- Make sure to remove any AI Studio-specific importmaps (already cleaned) so the app uses local `react` packages.

If you want, I can generate the exact Git commands for creating a GitHub repo with the `gh` CLI and show the DNS steps for common registrars.

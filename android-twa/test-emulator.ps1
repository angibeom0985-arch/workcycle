# Android 에뮬레이터 자동 테스트 스크립트
# PowerShell에서 실행

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Workcycle 에뮬레이터 테스트" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "WorkcycleApp"
$apkPath = "$projectPath\app\build\outputs\apk\debug\app-debug.apk"
$packageName = "com.workcycle.app.debug"
$launchActivity = "$packageName/com.google.androidbrowserhelper.trusted.LauncherActivity"

# 1. 프로젝트 확인
Write-Host "1️⃣ 프로젝트 확인 중..." -ForegroundColor Yellow
if (-not (Test-Path $projectPath)) {
    Write-Host "❌ WorkcycleApp 프로젝트가 없습니다." -ForegroundColor Red
    Write-Host "먼저 Android Studio에서 프로젝트를 생성하세요." -ForegroundColor Yellow
    Write-Host "가이드: QUICK_START.md 2단계 참고" -ForegroundColor Cyan
    exit 1
}
Write-Host "✅ 프로젝트 발견: $projectPath" -ForegroundColor Green
Write-Host ""

# 2. Debug APK 빌드 확인/생성
Write-Host "2️⃣ Debug APK 빌드 확인 중..." -ForegroundColor Yellow
if (Test-Path $apkPath) {
    Write-Host "ℹ️ 기존 APK 발견" -ForegroundColor Cyan
    $rebuild = Read-Host "다시 빌드하시겠습니까? (y/n)"
    if ($rebuild -eq "y") {
        Write-Host "🔨 Debug APK 빌드 중..." -ForegroundColor Yellow
        Set-Location $projectPath
        .\gradlew assembleDebug
        Set-Location ..
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ 빌드 실패!" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "🔨 Debug APK 빌드 중..." -ForegroundColor Yellow
    Set-Location $projectPath
    .\gradlew assembleDebug
    Set-Location ..
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 빌드 실패!" -ForegroundColor Red
        exit 1
    }
}

if (Test-Path $apkPath) {
    Write-Host "✅ APK 준비 완료: $apkPath" -ForegroundColor Green
} else {
    Write-Host "❌ APK 파일을 찾을 수 없습니다." -ForegroundColor Red
    exit 1
}
Write-Host ""

# 3. ADB 확인
Write-Host "3️⃣ ADB 연결 확인 중..." -ForegroundColor Yellow
try {
    $devices = adb devices 2>&1
    if ($devices -match "emulator-\d+") {
        Write-Host "✅ 에뮬레이터 연결됨" -ForegroundColor Green
        Write-Host $devices -ForegroundColor Gray
    } else {
        Write-Host "⚠️ 실행 중인 에뮬레이터가 없습니다." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "에뮬레이터를 시작하세요:" -ForegroundColor Cyan
        Write-Host "1. Android Studio → Device Manager" -ForegroundColor White
        Write-Host "2. 에뮬레이터 선택 → Play 버튼" -ForegroundColor White
        Write-Host ""
        
        $wait = Read-Host "에뮬레이터 시작 후 Enter를 누르세요"
        
        $devices = adb devices 2>&1
        if (-not ($devices -match "emulator-\d+")) {
            Write-Host "❌ 여전히 에뮬레이터를 찾을 수 없습니다." -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ 에뮬레이터 연결됨" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ ADB를 찾을 수 없습니다." -ForegroundColor Red
    Write-Host "Android SDK Platform Tools가 설치되었는지 확인하세요." -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# 4. 기존 앱 제거 (있는 경우)
Write-Host "4️⃣ 기존 앱 제거 중..." -ForegroundColor Yellow
$uninstallResult = adb uninstall $packageName 2>&1
if ($uninstallResult -match "Success") {
    Write-Host "✅ 기존 앱 제거 완료" -ForegroundColor Green
} else {
    Write-Host "ℹ️ 제거할 앱이 없습니다 (최초 설치)" -ForegroundColor Cyan
}
Write-Host ""

# 5. APK 설치
Write-Host "5️⃣ APK 설치 중..." -ForegroundColor Yellow
$installResult = adb install $apkPath 2>&1
if ($installResult -match "Success") {
    Write-Host "✅ APK 설치 완료!" -ForegroundColor Green
} else {
    Write-Host "❌ 설치 실패:" -ForegroundColor Red
    Write-Host $installResult -ForegroundColor Red
    exit 1
}
Write-Host ""

# 6. 앱 실행
Write-Host "6️⃣ 앱 실행 중..." -ForegroundColor Yellow
$launchResult = adb shell am start -n $launchActivity 2>&1
if ($launchResult -match "Starting") {
    Write-Host "✅ 앱이 실행되었습니다!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 에뮬레이터를 확인하세요!" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ 앱 실행 실패:" -ForegroundColor Yellow
    Write-Host $launchResult -ForegroundColor Gray
    Write-Host ""
    Write-Host "에뮬레이터에서 수동으로 앱을 실행하세요." -ForegroundColor Cyan
}
Write-Host ""

# 7. 테스트 가이드
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "테스트 체크리스트" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ 앱 시작 및 스플래시 화면" -ForegroundColor White
Write-Host "✅ 웹사이트 전체 화면 로드" -ForegroundColor White
Write-Host "✅ 주소창 숨김 확인" -ForegroundColor White
Write-Host "✅ 상태바 색상 (파란색)" -ForegroundColor White
Write-Host "✅ 근무 패턴 설정 페이지" -ForegroundColor White
Write-Host "✅ 달력 페이지 전환" -ForegroundColor White
Write-Host "✅ 뒤로 가기 버튼 작동" -ForegroundColor White
Write-Host "✅ 앵커 광고 표시" -ForegroundColor White
Write-Host ""

# 8. 추가 옵션
Write-Host "추가 작업을 선택하세요:" -ForegroundColor Yellow
Write-Host "1. 로그 실시간 보기"
Write-Host "2. 앱 재시작"
Write-Host "3. 스크린샷 캡처"
Write-Host "4. 앱 제거"
Write-Host "5. 종료"
Write-Host ""

$option = Read-Host "선택 (1-5)"

switch ($option) {
    "1" {
        Write-Host "`n📋 로그 보기 시작 (Ctrl+C로 종료)..." -ForegroundColor Cyan
        adb logcat -s "chromium" -s "TWA" -s "AndroidRuntime"
    }
    
    "2" {
        Write-Host "`n🔄 앱 재시작 중..." -ForegroundColor Cyan
        adb shell am force-stop $packageName
        Start-Sleep -Seconds 1
        adb shell am start -n $launchActivity
        Write-Host "✅ 앱이 재시작되었습니다!" -ForegroundColor Green
    }
    
    "3" {
        Write-Host "`n📸 스크린샷 캡처 중..." -ForegroundColor Cyan
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $screenshotName = "workcycle_$timestamp.png"
        
        adb shell screencap -p /sdcard/screenshot.png
        adb pull /sdcard/screenshot.png $screenshotName
        adb shell rm /sdcard/screenshot.png
        
        if (Test-Path $screenshotName) {
            Write-Host "✅ 스크린샷 저장: $screenshotName" -ForegroundColor Green
            Start-Process explorer.exe "/select,$screenshotName"
        } else {
            Write-Host "❌ 스크린샷 캡처 실패" -ForegroundColor Red
        }
    }
    
    "4" {
        Write-Host "`n🗑️ 앱 제거 중..." -ForegroundColor Cyan
        adb uninstall $packageName
        Write-Host "✅ 앱이 제거되었습니다!" -ForegroundColor Green
    }
    
    "5" {
        Write-Host "`n👋 테스트 종료" -ForegroundColor Cyan
    }
    
    default {
        Write-Host "`n👋 테스트 종료" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "테스트 완료!" -ForegroundColor Green
Write-Host "가이드: EMULATOR_TEST_GUIDE.md 참고" -ForegroundColor Cyan

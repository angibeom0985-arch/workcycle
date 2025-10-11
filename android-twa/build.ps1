# Android TWA 자동 빌드 스크립트
# PowerShell에서 실행

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Workcycle Android APK/AAB Builder" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "WorkcycleApp"

# 프로젝트 존재 확인
if (-not (Test-Path $projectPath)) {
    Write-Host "❌ 오류: WorkcycleApp 프로젝트가 없습니다." -ForegroundColor Red
    Write-Host "먼저 BUILD_GUIDE.md의 2단계를 따라 프로젝트를 생성하세요." -ForegroundColor Yellow
    exit 1
}

Write-Host "📂 프로젝트 디렉토리: $projectPath" -ForegroundColor Green
Write-Host ""

# 빌드 타입 선택
Write-Host "빌드 타입을 선택하세요:" -ForegroundColor Yellow
Write-Host "1. Debug APK (테스트용)"
Write-Host "2. Release APK (직접 배포용)"
Write-Host "3. Release AAB (Play Store용)"
Write-Host "4. 전체 빌드 (Debug APK + Release AAB)"
Write-Host ""

$choice = Read-Host "선택 (1-4)"

cd $projectPath

switch ($choice) {
    "1" {
        Write-Host "`n🔨 Debug APK 빌드 시작..." -ForegroundColor Cyan
        ./gradlew assembleDebug
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ Debug APK 빌드 완료!" -ForegroundColor Green
            Write-Host "📦 파일 위치: app/build/outputs/apk/debug/app-debug.apk" -ForegroundColor Green
            
            # 파일 열기
            $apkPath = "app\build\outputs\apk\debug"
            if (Test-Path $apkPath) {
                Start-Process explorer.exe $apkPath
            }
        } else {
            Write-Host "`n❌ 빌드 실패!" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host "`n🔨 Release APK 빌드 시작..." -ForegroundColor Cyan
        ./gradlew assembleRelease
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ Release APK 빌드 완료!" -ForegroundColor Green
            Write-Host "📦 파일 위치: app/build/outputs/apk/release/app-release.apk" -ForegroundColor Green
            
            $apkPath = "app\build\outputs\apk\release"
            if (Test-Path $apkPath) {
                Start-Process explorer.exe $apkPath
            }
        } else {
            Write-Host "`n❌ 빌드 실패!" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host "`n🔨 Release AAB 빌드 시작..." -ForegroundColor Cyan
        ./gradlew bundleRelease
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ Release AAB 빌드 완료!" -ForegroundColor Green
            Write-Host "📦 파일 위치: app/build/outputs/bundle/release/app-release.aab" -ForegroundColor Green
            
            $aabPath = "app\build\outputs\bundle\release"
            if (Test-Path $aabPath) {
                Start-Process explorer.exe $aabPath
            }
        } else {
            Write-Host "`n❌ 빌드 실패!" -ForegroundColor Red
        }
    }
    
    "4" {
        Write-Host "`n🔨 전체 빌드 시작..." -ForegroundColor Cyan
        Write-Host "1/2: Debug APK 빌드 중..." -ForegroundColor Yellow
        ./gradlew assembleDebug
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Debug APK 완료" -ForegroundColor Green
        }
        
        Write-Host "`n2/2: Release AAB 빌드 중..." -ForegroundColor Yellow
        ./gradlew bundleRelease
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ 전체 빌드 완료!" -ForegroundColor Green
            Write-Host "📦 Debug APK: app/build/outputs/apk/debug/app-debug.apk" -ForegroundColor Green
            Write-Host "📦 Release AAB: app/build/outputs/bundle/release/app-release.aab" -ForegroundColor Green
            
            Start-Process explorer.exe "app\build\outputs"
        } else {
            Write-Host "`n❌ 빌드 실패!" -ForegroundColor Red
        }
    }
    
    default {
        Write-Host "`n❌ 잘못된 선택입니다." -ForegroundColor Red
    }
}

cd ..

Write-Host "`n작업 완료!" -ForegroundColor Cyan
Write-Host "문제가 있으면 BUILD_GUIDE.md를 확인하세요." -ForegroundColor Yellow

# Android Studio Java 문제 자동 해결 스크립트
# PowerShell 관리자 권한으로 실행

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Android Studio Java 버전 문제 해결" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 현재 Java 상태 확인
Write-Host "1️⃣ 현재 Java 상태 확인 중..." -ForegroundColor Yellow
Write-Host ""

try {
    $javaVersion = java -version 2>&1
    Write-Host "✅ Java가 이미 설치되어 있습니다:" -ForegroundColor Green
    Write-Host $javaVersion -ForegroundColor Gray
    Write-Host ""
    
    $continue = Read-Host "다시 설치하시겠습니까? (y/n)"
    if ($continue -ne "y") {
        Write-Host "종료합니다." -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "⚠️ Java가 설치되어 있지 않거나 PATH에 없습니다." -ForegroundColor Yellow
    Write-Host ""
}

# 설치 방법 선택
Write-Host "2️⃣ JDK 설치 방법을 선택하세요:" -ForegroundColor Yellow
Write-Host "1. Chocolatey로 자동 설치 (추천)"
Write-Host "2. 수동 다운로드 링크 열기"
Write-Host "3. Android Studio 내장 JBR 사용 (환경 변수 설정)"
Write-Host ""

$choice = Read-Host "선택 (1-3)"

switch ($choice) {
    "1" {
        Write-Host "`n3️⃣ Chocolatey로 JDK 설치 중..." -ForegroundColor Cyan
        
        # Chocolatey 설치 확인
        try {
            choco --version | Out-Null
            Write-Host "✅ Chocolatey가 이미 설치되어 있습니다." -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Chocolatey를 먼저 설치합니다..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            Write-Host "✅ Chocolatey 설치 완료!" -ForegroundColor Green
        }
        
        # JDK 설치
        Write-Host "`nTemurin JDK 21 설치 중..." -ForegroundColor Yellow
        choco install temurin21 -y
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ JDK 21 설치 완료!" -ForegroundColor Green
            
            # 환경 변수 새로고침
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            
            Write-Host "`n4️⃣ 설치 확인 중..." -ForegroundColor Cyan
            java -version
            
            Write-Host "`n✅ 모든 작업이 완료되었습니다!" -ForegroundColor Green
            Write-Host "⚠️ PowerShell을 재시작한 후 사용하세요." -ForegroundColor Yellow
        } else {
            Write-Host "`n❌ 설치 실패!" -ForegroundColor Red
            Write-Host "수동 설치를 권장합니다 (옵션 2)." -ForegroundColor Yellow
        }
    }
    
    "2" {
        Write-Host "`n3️⃣ 브라우저에서 다운로드 페이지를 엽니다..." -ForegroundColor Cyan
        Start-Process "https://adoptium.net/temurin/releases/?version=21"
        
        Write-Host "`n📝 설치 안내:" -ForegroundColor Yellow
        Write-Host "1. Windows x64 MSI 파일 다운로드"
        Write-Host "2. 설치 시 'Set JAVA_HOME variable' 체크"
        Write-Host "3. 설치 완료 후 PowerShell 재시작"
        Write-Host "4. 'java -version' 명령어로 확인"
        Write-Host ""
        
        $wait = Read-Host "설치 완료 후 Enter를 눌러 확인하세요"
        
        try {
            Write-Host "`n4️⃣ 설치 확인 중..." -ForegroundColor Cyan
            java -version
            Write-Host "`n✅ Java가 정상적으로 설치되었습니다!" -ForegroundColor Green
        } catch {
            Write-Host "`n⚠️ Java를 찾을 수 없습니다." -ForegroundColor Yellow
            Write-Host "PowerShell을 재시작한 후 다시 확인하세요." -ForegroundColor Yellow
        }
    }
    
    "3" {
        Write-Host "`n3️⃣ Android Studio JBR 경로 설정 중..." -ForegroundColor Cyan
        
        $androidStudioPath = "C:\Program Files\Android\Android Studio\jbr"
        
        if (Test-Path $androidStudioPath) {
            Write-Host "✅ Android Studio JBR 발견: $androidStudioPath" -ForegroundColor Green
            
            # JAVA_HOME 설정
            [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $androidStudioPath, "User")
            Write-Host "✅ JAVA_HOME 설정 완료" -ForegroundColor Green
            
            # PATH 추가
            $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
            $javaPath = "$androidStudioPath\bin"
            
            if ($currentPath -notlike "*$javaPath*") {
                [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$javaPath", "User")
                Write-Host "✅ PATH 추가 완료" -ForegroundColor Green
            } else {
                Write-Host "ℹ️ PATH가 이미 설정되어 있습니다." -ForegroundColor Cyan
            }
            
            # 환경 변수 새로고침
            $env:JAVA_HOME = $androidStudioPath
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            
            Write-Host "`n4️⃣ 설정 확인 중..." -ForegroundColor Cyan
            Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Gray
            
            # Java 실행 테스트
            try {
                & "$androidStudioPath\bin\java.exe" -version 2>&1 | Out-Null
                Write-Host "`n⚠️ JBR이 손상되었을 수 있습니다." -ForegroundColor Yellow
                Write-Host "Android Studio를 재설치하거나 옵션 1을 선택하세요." -ForegroundColor Yellow
            } catch {
                Write-Host "`n⚠️ JBR 실행 오류" -ForegroundColor Yellow
                Write-Host "독립적인 JDK 설치를 권장합니다 (옵션 1)." -ForegroundColor Yellow
            }
            
            Write-Host "`n✅ 환경 변수 설정 완료!" -ForegroundColor Green
            Write-Host "⚠️ PowerShell을 재시작한 후 확인하세요." -ForegroundColor Yellow
            
        } else {
            Write-Host "❌ Android Studio JBR을 찾을 수 없습니다." -ForegroundColor Red
            Write-Host "경로: $androidStudioPath" -ForegroundColor Gray
            Write-Host "`n옵션 1 또는 2를 사용하여 JDK를 설치하세요." -ForegroundColor Yellow
        }
    }
    
    default {
        Write-Host "`n❌ 잘못된 선택입니다." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "작업 완료!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart PowerShell"
Write-Host "2. Run 'java -version' to verify"
Write-Host "3. Restart Android Studio"
Write-Host "4. Test with 'flutter doctor' or Gradle build"
Write-Host ""

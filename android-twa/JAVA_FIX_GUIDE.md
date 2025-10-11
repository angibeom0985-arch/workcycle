# Android Studio Java 버전 문제 해결 가이드

## 문제 증상
```
[!] Android Studio (version 2025.1.2)
    X Unable to determine bundled Java version.
```

---

## 🔧 해결 방법

### 방법 1: Android Studio JBR 재설치 (추천)

1. **Android Studio 실행**
2. **File** → **Settings** (또는 `Ctrl + Alt + S`)
3. **Build, Execution, Deployment** → **Build Tools** → **Gradle**
4. **Gradle JDK** 항목에서:
   - 드롭다운 메뉴 열기
   - **Download JDK** 클릭
   - **Version**: `21` (또는 17)
   - **Vendor**: `Eclipse Temurin (AdoptOpenJDK HotSpot)`
   - **Download** 클릭

---

### 방법 2: 환경 변수 수동 설정

#### PowerShell에서 실행:

```powershell
# 1. JAVA_HOME 설정 (사용자 환경 변수)
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Android\Android Studio\jbr", "User")

# 2. PATH에 추가
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$javaPath = "C:\Program Files\Android\Android Studio\jbr\bin"
if ($currentPath -notlike "*$javaPath*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$javaPath", "User")
    Write-Host "✅ Java PATH added" -ForegroundColor Green
}

# 3. 확인
Write-Host "`n환경 변수 설정 완료!" -ForegroundColor Cyan
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host "`n⚠️ PowerShell을 재시작한 후 확인하세요." -ForegroundColor Yellow
```

#### PowerShell 재시작 후 확인:
```powershell
java -version
```

---

### 방법 3: 독립적인 JDK 설치 (권장)

#### Temurin JDK 21 설치:

```powershell
# Chocolatey 설치 (없는 경우)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# JDK 21 설치
choco install temurin21 -y

# 설치 확인
java -version
```

또는 **수동 다운로드**:
1. [Adoptium Temurin JDK 21](https://adoptium.net/temurin/releases/?version=21) 접속
2. **Windows x64 MSI** 다운로드
3. 설치 시 **Set JAVA_HOME variable** 체크
4. 설치 완료 후 PowerShell 재시작

---

### 방법 4: Android Studio 내 JDK 경로 직접 설정

1. **Android Studio** 실행
2. **File** → **Project Structure** (`Ctrl + Alt + Shift + S`)
3. **SDK Location** 탭
4. **JDK location** 설정:
   - 기본값: `C:\Program Files\Android\Android Studio\jbr`
   - 또는 설치한 JDK 경로: `C:\Program Files\Eclipse Adoptium\jdk-21.x.x-hotspot`

---

## ✅ 확인 방법

### PowerShell에서 확인:
```powershell
# Java 버전 확인
java -version

# JAVA_HOME 확인
echo $env:JAVA_HOME

# Gradle이 사용하는 Java 확인
cd "C:\Users\삼성\OneDrive\Desktop\Website\Workcycle\android-twa\WorkcycleApp"
.\gradlew -version
```

**올바른 출력 예시:**
```
openjdk version "21.0.x" 2024-xx-xx
OpenJDK Runtime Environment Temurin-21+xx (build 21.0.x+x)
OpenJDK 64-Bit Server VM Temurin-21+xx (build 21.0.x+x, mixed mode, sharing)
```

---

## 🎯 Android TWA 빌드를 위한 추가 설정

### build.gradle.kts에서 Java 버전 확인:

`WorkcycleApp/app/build.gradle.kts`:
```kotlin
android {
    // ...
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17  // 또는 VERSION_21
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"  // 또는 "21"
    }
}
```

### Gradle wrapper 속성:

`WorkcycleApp/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
```

---

## 🐛 문제가 계속되면

### 1. Android Studio 완전 재설치:
```powershell
# 설정 파일 삭제
Remove-Item -Recurse -Force "$env:USERPROFILE\.android" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Google\AndroidStudio*" -ErrorAction SilentlyContinue

# Android Studio 재설치 후:
# - JetBrains Runtime (JBR) 포함 버전 선택
# - 설치 시 모든 구성 요소 선택
```

### 2. Flutter Doctor 재실행:
```powershell
flutter doctor -v
```

### 3. Android SDK 경로 확인:
```powershell
# Android Studio에서:
# File → Settings → Appearance & Behavior → System Settings → Android SDK
# SDK Path가 올바른지 확인
```

---

## 📝 요약

**가장 빠른 해결책:**

1. **Android Studio 실행**
2. **Settings** → **Gradle** → **Gradle JDK**
3. **Download JDK** (Temurin 21 선택)
4. **적용** 후 재시작

또는

1. [Temurin JDK 21 다운로드](https://adoptium.net/temurin/releases/?version=21)
2. 설치 (JAVA_HOME 자동 설정)
3. PowerShell 재시작
4. `java -version` 확인

---

## ✅ 성공 확인

문제가 해결되면 다음 명령어가 정상 작동해야 합니다:

```powershell
# Java 확인
java -version

# Gradle 빌드 테스트
cd "android-twa\WorkcycleApp"
.\gradlew --version
.\gradlew assembleDebug
```

**출력:**
```
BUILD SUCCESSFUL in Xs
```

---

**문제가 계속되면 추가 도움을 요청하세요!**

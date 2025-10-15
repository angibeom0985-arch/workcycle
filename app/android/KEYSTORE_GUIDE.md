# 키스토어 생성 방법

플레이스토어에 앱을 출시하려면 릴리즈 키스토어가 필요합니다.

## 키스토어 생성 명령어

PowerShell에서 다음 명령어를 실행하세요:

```powershell
keytool -genkey -v -keystore C:\KB\Website\Workcycle\app\android\app\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## 정보 입력

명령어 실행 시 다음 정보를 입력해야 합니다:
- 키스토어 비밀번호 (기억해야 함!)
- 키 비밀번호 (보통 키스토어 비밀번호와 동일하게)
- 이름, 조직, 도시, 국가 등

## key.properties 파일 생성

키스토어 생성 후, `android/key.properties` 파일을 생성하고 다음 내용을 입력하세요:

```
storePassword=여기에_키스토어_비밀번호
keyPassword=여기에_키_비밀번호
keyAlias=upload
storeFile=upload-keystore.jks
```

**중요:** key.properties 파일은 절대 Git에 커밋하지 마세요!

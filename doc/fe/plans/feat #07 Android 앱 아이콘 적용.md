# Android 앱 아이콘 적용 계획서

> **상태**: 승인됨  
> **작성일**: 2026-08-17  
> **작업 번호**: #07  
> **관련 이슈**: [#13](https://github.com/GBSW-ReMake/GONE-Android/issues/13)  
> **브랜치**: `feat/13-app-icon`

## 목적

제공된 GONE 가로형 로고를 Android 런처 아이콘으로 적용합니다. 아이콘 마스킹으로 로고가 잘리지 않도록 흰 배경과 안전 여백을 포함한 정사각형 아이콘을 각 Android 밀도별 리소스로 생성합니다.

## 작업 범위

- 원본 로고의 비율을 유지한 정사각형 런처 아이콘을 생성합니다.
- `mipmap-*`의 기존 `ic_launcher.png`를 Android 표준 해상도로 교체합니다.
- Android debug APK 빌드로 리소스 반영 여부를 검증합니다.

## 완료 기준

- [ ] 홈 화면 아이콘에서 GONE 로고가 잘리지 않고 선명하게 표시됩니다.
- [ ] 모든 `mipmap-*` 해상도에 아이콘이 반영됩니다.
- [ ] `flutter analyze` 및 Android debug APK 빌드가 통과합니다.

> **개발자 검토 의견**
> 승인 ✅

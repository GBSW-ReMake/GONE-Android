# Android 앱 아이콘 및 스플래시 최종 개발 보고서

> **완료일**: 2026-08-17  
> **작업 번호**: #07  
> **관련 이슈**: [#13](https://github.com/GBSW-ReMake/GONE-Android/issues/13)  
> **브랜치**: `feat/13-app-icon`

## 구현 내용

- 제공된 GONE 가로형 로고를 Android `mipmap-*` 런처 아이콘으로 교체했습니다.
- 로고 주변 여백을 줄여 Android 런처 마스크 안에서도 로고가 선명하게 보이도록 확대했습니다.
- Android 12+ 시스템 스플래시의 작은 중복 로고를 투명 아이콘으로 숨겼습니다.
- 기존 Flutter 스플래시 로고 애니메이션은 유지하고, 로고 노출 및 전환 시간을 늘려 자연스럽게 앱 화면으로 진입하도록 조정했습니다.

## QA 결과

- `flutter analyze` 통과
- `flutter test` 통과 (11개)
- `flutter build apk --debug` 통과

## 확인 방법

- 시스템 스플래시는 Hot Restart에서 재생되지 않으므로, 에뮬레이터에서 앱을 완전히 종료한 뒤 홈 화면의 GONE 아이콘으로 다시 실행해 확인합니다.
- 런처 아이콘이 캐시되면 기존 앱을 삭제한 뒤 다시 설치합니다.

## Pull Request

- [#14 feat: GONE 앱 아이콘 및 스플래시 개선](https://github.com/GBSW-ReMake/GONE-Android/pull/14)

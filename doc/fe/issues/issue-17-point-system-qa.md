# Issue #17 교사 상벌점 발급 QA

> 작성일: 2026-08-22
> 브랜치: `feat/17-point-system`

## 확인 결과

- 교사 역할에서 4번째 탭이 상벌점으로 표시되고, 학생 역할은 스쿨캠핑을 유지하도록 구현했습니다.
- 대상자 추가, 학생별 폼 저장/수정/삭제, 일괄 발급, 완료 화면, 발급 내역 필터, 개인 통계를 구현했습니다.
- `git diff --check`를 통과했습니다.

## 미실행 항목

- 현재 실행 환경에 Flutter SDK 명령(`flutter`, `dart`)이 없어 `flutter analyze`, `flutter test`, `flutter build apk --debug` 및 에뮬레이터 QA를 실행하지 못했습니다.
- Flutter SDK가 설치된 환경에서 교사/학생 역할별 탭과 발급 흐름을 재검증해야 합니다.

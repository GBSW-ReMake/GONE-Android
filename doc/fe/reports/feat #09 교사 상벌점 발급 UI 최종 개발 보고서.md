# 교사 상벌점 발급 UI 최종 개발 보고서

> **작업 번호**: #09
> **관련 이슈**: [#17](https://github.com/GBSW-ReMake/GONE-Android/issues/17)
> **브랜치**: `feat/17-point-system`
> **작성일**: 2026-08-23

## 구현 내용

- 로그인 역할을 홈으로 전달해 교사에게만 상벌점 4번째 탭을 노출했습니다. 학생은 기존 스쿨캠핑 탭을 유지합니다.
- 교사 홈 프로필 카드에는 기존 정보와 역할을 유지하고, 상벌점 수치만 숨겼습니다.
- Riverpod 기반 상벌점 상태를 추가해 대상 학생, 학생별 초안, 발급 기록을 관리합니다.
- 학생 검색, 전체 화면 발급 폼, 명단 수정/삭제, 일괄 발급, 완료 화면을 구현했습니다.
- 발급 내역의 전체/상점/벌점 필터와 한국어 날짜, 로그인 교사 기준 통계를 구현했습니다.
- 제공된 `+` 및 체크 이미지를 Android assets로 추가하고, 빈 상태·완료 상태 화면에 적용했습니다.
- 학생 검색 시트에 학번/이름 검색을 추가하고, 검색 결과에서 대상자를 선택하면 발급 폼으로 이동하도록 했습니다.
- 참고 이미지 기준으로 카드 크기, 버튼 상태/색상, 중앙 정렬, 상단 여백, 통계 숫자 크기와 간격을 조정했습니다.
- 역할 선택 일러스트 에셋을 저장소 이력에서 복구해 로그인 화면의 Asset not found 오류를 해결했습니다.

## 검증 결과

- `git diff --check` 통과
- `/Users/kim-eunchan/flutter/bin/flutter build apk --debug` 통과
- 생성된 debug APK를 `emulator-5554`에 설치하고 `com.eunchan.gone.gone/.MainActivity` 실행 확인
- `flutter run -d emulator-5554`로 빌드·설치·디버그 연결 확인
- `flutter analyze`, `flutter test`는 기존 프로젝트 전역 분석 환경 이슈로 별도 재검토가 필요합니다.

## 후속 검토

- 실제 API 계약이 확정되면 현재 mock 기반 PointSystemNotifier를 Repository 계층으로 교체합니다.
- 현재 삭제 상태인 `assets/images/outing-apply-illustration.png`는 이번 작업 범위가 아니므로 복구하지 않았습니다.

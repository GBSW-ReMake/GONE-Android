# GONE Android 아키텍처

> 상태: 초기 적용 기준
> 기준: Feature-first Clean Architecture + Riverpod

## 선택 이유

GONE은 로그인, 예약, 외출, 스쿨캠핑처럼 기능별 화면과 상태가 확장되는 서비스입니다. 기능 단위 폴더를 기준으로 두고, 화면 상태는 Riverpod의 `Notifier`로 관리합니다. API와 저장소가 생기는 기능에는 Domain과 Data 계층을 추가해 테스트와 교체를 쉽게 합니다.

단순한 화면 표현까지 UseCase와 Repository로 나누지 않습니다. 외부 I/O 또는 재사용할 비즈니스 규칙이 생길 때만 계층을 추가합니다.

## 구조

```text
lib/
├── app/                         # 앱 시작, 라우팅, DI 조립
├── core/                        # 네트워크, 저장소, 오류, 공통 유틸리티
├── design_system/               # 토큰과 재사용 UI 컴포넌트
├── features/
│   └── auth/
│       ├── presentation/
│       │   ├── login_page.dart
│       │   ├── login_notifier.dart
│       │   └── login_state.dart
│       ├── application/
│       │   └── sign_in_use_case.dart
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/auth_repository.dart
│       └── data/
│           ├── datasources/
│           ├── dtos/
│           └── repositories/remote_auth_repository.dart
└── main.dart
```

## 책임

| 계층 | 책임 | 예시 |
|---|---|---|
| Page/Widget | UI 표시와 사용자 이벤트 전달 | `LoginPage` |
| Notifier | 화면 상태, 입력 검증, UI 이벤트 처리 | `LoginNotifier` |
| UseCase | 재사용 가능한 비즈니스 규칙 | `SignInUseCase` |
| Repository 계약 | 도메인이 필요한 데이터 접근 정의 | `AuthRepository` |
| Data | API, 로컬 저장소, DTO 변환, Repository 구현 | `RemoteAuthRepository` |
| Entity | 프레임워크와 무관한 도메인 데이터 | `Credentials` |

## 의존성 규칙

```text
Presentation → Application → Domain ← Data
```

- `presentation`은 DTO, HTTP 클라이언트, `SharedPreferences`에 직접 의존하지 않습니다.
- `domain`은 Flutter, Riverpod, Dio 같은 프레임워크에 의존하지 않습니다.
- `data`는 Domain의 Repository 계약을 구현합니다.
- Provider는 `app` 또는 기능의 조립 파일에서 구현체를 연결합니다.
- UI 상태는 `AsyncValue` 또는 명시적인 상태 모델로 표현합니다. 예외를 Widget에서 직접 처리하지 않습니다.

## Riverpod 적용 기준

- 화면 단위의 변경 가능한 상태는 `Notifier` 또는 `AsyncNotifier`를 사용합니다.
- 읽기 전용 설정값과 단순 파생 값은 `Provider`를 사용합니다.
- Widget은 `ref.watch`로 상태를 구독하고, 사용자 이벤트에서만 `ref.read(...notifier)`를 호출합니다.
- Provider를 전역 서비스 로케이터처럼 사용하지 않습니다. 생성자 주입으로 의존성을 드러냅니다.

## 테스트 기준

- UseCase와 Notifier는 단위 테스트를 우선합니다.
- Repository 구현은 DTO 변환과 오류 매핑을 검증합니다.
- 주요 사용자 흐름은 Widget 또는 통합 테스트로 확인합니다.

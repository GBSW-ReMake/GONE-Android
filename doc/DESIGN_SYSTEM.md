# GONE Android 디자인 시스템 v1

> 상태: 기획 초안 · Flutter 적용 전 검토 필요

GONE은 Android 사용자에게 익숙한 동작과 접근성을 우선합니다. 기존 GONE 브랜드 색상을 의미 토큰으로 유지하고, Material 3 컴포넌트를 필요한 범위에서 사용합니다.

## 원칙

- Material 3와 Android 접근성 기준을 우선합니다.
- 색상은 실제 값 대신 의미 토큰으로 사용합니다.
- 최소 터치 영역은 48dp로 유지합니다.
- 색상 외 텍스트와 아이콘으로 상태를 함께 전달합니다.
- Light/Dark 모드와 글자 크기 확대를 지원합니다.

## 브랜드·상태 색상

| 토큰 | 값 | 용도 |
|---|---|---|
| `brand.primary` | `#5B8DEF` | 주요 CTA, 선택 상태 |
| `brand.deepNavy` | `#1F2937` | 제목, 브랜드 강조 |
| `brand.softBlue` | `#EAF1FF` | 선택 배경, 정보 틴트 |
| `status.success` | `#34C77B` | 완료, 승인 |
| `status.warning` | `#FFB547` | 대기, 주의 |
| `status.error` | `#FF5A5F` | 반려, 실패 |

## Flutter 매핑 원칙

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: GoneColors.primary),
)
```

- `Color(0xFF...)`를 화면에서 직접 사용하지 않습니다.
- `ThemeExtension` 또는 의미 기반 색상 클래스로 토큰을 제공합니다.
- 버튼, 입력 필드, 카드, 상태 배지, 빈 상태, 로딩 상태, 오류 상태를 재사용 컴포넌트로 관리합니다.

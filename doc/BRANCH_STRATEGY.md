# GONE Android 브랜치 전략

## 구조

```text
main
└── dev
    ├── feat/<이슈번호>-<기능명>
    ├── fix/<이슈번호>-<설명>
    └── hotfix/<설명>
```

| 브랜치 | 역할 | 직접 커밋 | 병합 방식 |
|---|---|---:|---|
| `main` | 배포 기준 | 금지 | `dev` PR만 |
| `dev` | 다음 릴리즈 통합 | 금지 | `feat`/`fix` PR |
| `feat/*` | 기능 개발 | 허용 | `dev`로 PR |
| `fix/*` | QA 버그 수정 | 허용 | `dev`로 PR |
| `hotfix/*` | 운영 긴급 수정 | 허용 | `main`, 이후 `dev` 반영 |

## 이름 규칙

```text
feat/12-lab-reservation
fix/31-outing-status-update
hotfix-login-blocked
```

- 이슈 기반 작업은 이슈 번호를 포함합니다.
- 기능명은 영문 소문자 케밥 표기법을 사용합니다.
- 계획서가 승인된 뒤 브랜치를 만듭니다.

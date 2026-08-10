# GONE Android 문서 디렉터리

GONE Android 프로젝트의 기획, 개발, QA, 릴리즈 기록을 관리합니다.

## 구조

```text
doc/
├── README.md
├── WORKFLOW.md
├── BRANCH_STRATEGY.md
├── COMMIT_CONVENTION.md
├── PULL_REQUEST_TEMPLATE.md
├── ARCHITECTURE.md
├── DESIGN_SYSTEM.md
├── SENTENCE_REFINEMENT.md
├── issues/
│   └── _TEMPLATE-report.md
├── reports/
│   └── _TEMPLATE-final-report.md
└── fe/
    ├── plans/
    │   └── _TEMPLATE-plan.md
    ├── issues/
    └── reports/
```

## 문서 작성 순서

1. `doc/fe/plans/`에 계획서를 작성합니다.
2. 개발자가 계획서를 검토하고 승인합니다.
3. GitHub 이슈를 만듭니다.
4. 이슈 번호를 포함한 브랜치를 만듭니다.
5. 개발, QA, 최종 보고서, PR 순서로 기록합니다.

## 작업 번호와 파일명

- 작업 번호는 개발 순서이며 GitHub 이슈 번호와 별개입니다.
- 계획서, QA 보고서, 최종 보고서에는 같은 작업 번호를 사용합니다.

```text
doc/fe/plans/feat #01 로그인.md
doc/fe/issues/issue-01-로그인-qa.md
doc/fe/reports/feat #01 로그인 최종 개발 보고서.md
```

## 참고 문서

| 문서 | 설명 |
|---|---|
| [WORKFLOW.md](WORKFLOW.md) | 기능 개발 절차 |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Flutter 아키텍처와 책임 |
| [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) | Android UI 적용 기준 |

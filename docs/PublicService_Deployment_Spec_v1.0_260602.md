# PublicService_Deployment_Spec_v1.0_260602

---

## 문서 정보

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트명** | PublicService — 소상공인·창업자 통합 공공서비스 플랫폼 |
| **문서 유형** | Deployment Spec (형상/배포관리 정의서) |
| **버전** | v1.0 |
| **작성일** | 2026-06-02 |

---

## 1. 소스 버전 관리 (Git Strategy)

### 1.1 Git 설정 현황

```
C:\publicservice\
├── .gitattributes     (줄바꿈 처리 설정)
├── .gitignore         (추적 제외 파일 목록)
└── .claude/
    └── settings.local.json  (로컬 AI 에이전트 설정 - Git 제외 권장)
```

### 1.2 .gitignore 주요 제외 대상 (Spring Boot 표준)

```
# 빌드 산출물
target/
*.war
*.jar

# IDE 설정
.idea/
.vscode/
*.iml

# 환경 설정 (민감 정보)
application-local.properties
application-prod.properties

# OS 메타데이터
.DS_Store
Thumbs.db
```

> **주의:** `application.properties`에 DB 패스워드, API 키(PortOne, 지오코딩) 등 민감 정보가 포함된 경우 `.gitignore`에 추가하거나 환경변수로 분리할 것

### 1.3 브랜치 전략 (권장)

```
main (또는 master)
    └── 배포 가능한 안정 버전

develop
    └── 통합 개발 브랜치

feature/{기능명}
    └── 기능별 개발 브랜치
    └── 예: feature/webrtc-videocall, feature/policy-scrap

hotfix/{이슈번호}
    └── 운영 긴급 수정
```

### 1.4 커밋 메시지 규칙 (권장)

```
타입(범위): 변경 요약

타입:
  feat     — 새 기능
  fix      — 버그 수정
  refactor — 코드 개선 (기능 변경 없음)
  docs     — 문서 수정
  test     — 테스트 추가/수정
  chore    — 빌드·설정 변경

예시:
  feat(consulting): 상담 메시지 WebSocket 실시간 전송 추가
  fix(user): 비밀번호 찾기 이메일 검증 오류 수정
  docs(arch): Architecture Design v1.1 업데이트
```

---

## 2. 빌드 관리 (Build Management)

### 2.1 Maven 빌드 설정

```xml
<!-- pom.xml 핵심 설정 -->
<groupId>com.publicservice</groupId>
<artifactId>publicservice</artifactId>
<version>0.0.1-SNAPSHOT</version>
<packaging>war</packaging>
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.5.13</version>
</parent>
```

### 2.2 빌드 명령어

| 명령어 | 용도 |
| :--- | :--- |
| `./mvnw clean package` | 전체 빌드 (WAR 생성) |
| `./mvnw clean package -DskipTests` | 테스트 스킵 빌드 |
| `./mvnw spring-boot:run` | 로컬 개발 서버 실행 |
| `./mvnw test` | 단위 테스트 실행 |

### 2.3 빌드 산출물

| 파일 | 경로 | 용도 |
| :--- | :--- | :--- |
| `publicservice-0.0.1-SNAPSHOT.war` | `target/` | 외장 Tomcat 배포용 |
| `publicservice-0.0.1-SNAPSHOT.war.original` | `target/` | 내장 Tomcat 실행용 |

### 2.4 버전 관리 규칙

| 환경 | 버전 예시 | 설명 |
| :--- | :--- | :--- |
| 개발 중 | `0.0.1-SNAPSHOT` | 스냅샷 (현재) |
| 첫 릴리즈 | `1.0.0-RELEASE` | 정식 배포 버전 |
| 패치 | `1.0.1-RELEASE` | 버그 수정 배포 |
| 마이너 업데이트 | `1.1.0-RELEASE` | 기능 추가 배포 |

---

## 3. CI/CD 파이프라인 (권장 구성)

### 3.1 파이프라인 흐름

```
[개발자 Push/PR]
        ↓
[CI 단계] — GitHub Actions / Jenkins
    ├── 코드 체크아웃
    ├── ./mvnw clean package
    ├── 단위 테스트 실행 (mvnw test)
    └── 빌드 성공 여부 알림
        ↓
[CD 단계] — main 브랜치 병합 시
    ├── WAR 파일 빌드
    ├── 배포 서버 전송 (SCP/SFTP)
    ├── 기존 서비스 중단 (graceful shutdown)
    ├── WAR 교체 및 서버 재시작
    └── 헬스체크 (Spring Actuator /actuator/health)
```

### 3.2 GitHub Actions 예시 (권장)

```yaml
# .github/workflows/build.yml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      - name: Build with Maven
        run: ./mvnw clean package -DskipTests
      - name: Run Tests
        run: ./mvnw test
```

---

## 4. 환경 설정 분리 (Environment Configuration)

### 4.1 환경별 설정 파일 구조 (권장)

```
src/main/resources/
├── application.properties          (공통 설정)
├── application-local.properties    (로컬 개발 — gitignore)
├── application-dev.properties      (개발 서버)
└── application-prod.properties     (운영 서버 — gitignore)
```

### 4.2 application.properties 주요 항목

| 항목 | 설정 키 | 비고 |
| :--- | :--- | :--- |
| DB URL | `spring.datasource.url` | 환경별 분리 필수 |
| DB 사용자 | `spring.datasource.username` | 민감 정보 |
| DB 패스워드 | `spring.datasource.password` | 민감 정보 — 환경변수 권장 |
| JPA DDL | `spring.jpa.hibernate.ddl-auto` | prod: `validate`, dev: `update` |
| PortOne 키 | `portone.imp_key`, `portone.imp_secret` | 민감 정보 |
| 지오코딩 API 키 | (커스텀 키) | 민감 정보 |

---

## 5. 이미지 빌드 및 태깅 규칙 (컨테이너화 시)

> 현재 프로젝트는 WAR 배포 방식이나, 향후 Docker 컨테이너화를 위한 가이드 제공

### 5.1 Dockerfile (권장)

```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/publicservice-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
```

### 5.2 이미지 태깅 규칙

| 태그 | 예시 | 용도 |
| :--- | :--- | :--- |
| latest | `publicservice:latest` | 최신 개발 버전 |
| 버전 태그 | `publicservice:1.0.0` | 특정 릴리즈 |
| 날짜 태그 | `publicservice:260602` | 날짜 기반 추적 |
| 환경 태그 | `publicservice:prod-1.0.0` | 환경+버전 조합 |

---

*파일명 규칙: `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md`*
*본 문서는 `PublicService_Deployment_Spec_v1.0_260602.md`로 저장한다.*

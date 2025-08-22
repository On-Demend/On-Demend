# HTTP

## HTTP란?
- **HTTP(HyperText Transfer Protocol)**은 웹에서 데이터를 주고받기 위한 **통신 규약(Protocol)**  
- 우리가 브라우저에서 주소창에 URL을 입력하면, 내부적으로 HTTP 요청을 보내고, 웹 서버가 응답을 보내는 방식으로 작동  
- **클라이언트-서버 모델** 기반으로 동작
  - **클라이언트(Client)** : 웹 브라우저, 앱 등 요청을 보내는 쪽
  - **서버(Server)** : 요청을 받아 처리하고 응답하는 쪽

---

## 기본 구조
HTTP는 크게 **요청(Request)**과 **응답(Response)**으로 구성됨.

### 1. 요청(Request)
클라이언트가 서버에 무엇을 해달라고 요구하는 메시지

#### 요청 구조 예시
```
GET /index.html HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
```

- **요청 라인** : 어떤 동작을 할지 지정 (예: `GET /index.html HTTP/1.1`)
- **헤더(Header)** : 부가 정보 전달 (예: 브라우저 정보, 언어, 인증 등)
- **본문(Body)** : (필요할 경우) 서버로 보내는 데이터 (예: 회원가입 폼 정보)

---

### 2. 응답(Response)
서버가 요청을 처리한 뒤 클라이언트에 돌려주는 메시지

#### 응답 구조 예시
```
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234

<html>
  <body>Hello, World!</body>
</html>
```

- **상태 라인** : 요청 처리 결과 (예: `200 OK`)
- **헤더(Header)** : 응답에 대한 부가 정보 (예: 내용 형식, 길이, 캐시 정책 등)
- **본문(Body)** : 실제 데이터(HTML, JSON, 이미지 등)

---

## HTTP 요청 메서드 (Method)
클라이언트가 서버에게 원하는 **동작**을 지정하는 방식

| 메서드 | 설명 | 예시 |
|--------|------|------|
| `GET` | 서버에서 데이터를 가져옴 | 게시글 목록 보기 |
| `POST` | 서버에 데이터를 보냄 | 회원가입, 로그인 |
| `PUT` | 서버의 데이터를 통째로 교체 | 프로필 전체 수정 |
| `PATCH` | 서버 데이터의 일부만 수정 | 프로필의 닉네임만 수정 |
| `DELETE` | 서버에서 데이터 삭제 | 게시글 삭제 |

---

## HTTP 상태 코드 (Status Code)
서버가 요청에 대해 어떤 결과를 반환했는지 나타내는 숫자

| 코드 범위 | 의미 |
|-----------|------|
| `1xx` | 정보(Information) |
| `2xx` | 성공(Success) |
| `3xx` | 리다이렉션(Redirection, 다른 위치로 이동) |
| `4xx` | 클라이언트 에러(Client Error, 요청이 잘못됨) |
| `5xx` | 서버 에러(Server Error, 서버 문제 발생) |

### 자주 쓰이는 상태 코드
- **200 OK** : 성공적으로 처리됨 <-- 많이 보게됨
- **201 Created** : 새로운 데이터가 성공적으로 만들어짐 <-- 많이 보게됨
- **301 Moved Permanently** : 요청한 리소스가 영구적으로 다른 위치로 이동  
- **400 Bad Request** : 잘못된 요청 (문법 오류 등) <-- 많이 보게됨 
- **401 Unauthorized** : 인증 필요 (로그인 필요)  
- **403 Forbidden** : 권한 없음  <-- 많이 보게됨
- **404 Not Found** : 요청한 리소스를 찾을 수 없음 <-- 이건 알겠지??? 
- **500 Internal Server Error** : 서버 내부 오류 😈😈😈 <-- 많이 보게됨;;
- **502 Bad Gateway** : 백엔드 서버에서 정상적인 응답을 받지 못한 상태 (백엔드 서버가 죽은 경우가 많음) <-- 많이 보게됨
- **503 Service Unavailable** : 요청을 처리할 수 없는 상태 <-- 많이 보게됨

---

## HTTP 헤더 (Header)
요청과 응답에서 **추가 정보**를 전달하는 역할

### 요청 헤더 예시
- `Host: www.example.com` → 접속할 서버 도메인
- `User-Agent: Mozilla/5.0` → 클라이언트 정보 (브라우저/앱 종류)
- `Accept: text/html` → 클라이언트가 원하는 응답 데이터 형식

### 응답 헤더 예시
- `Content-Type: text/html` → 응답 본문의 데이터 형식
- `Content-Length: 1234` → 응답 본문의 크기
- `Set-Cookie: sessionId=abc123` → 클라이언트에 쿠키 저장

---

## HTTP vs HTTPS
- **HTTP** : 데이터를 암호화하지 않고 전송 → 도청/변조 위험
- **HTTPS** : SSL/TLS 기반으로 데이터를 암호화 → 안전한 통신
- 요즘은 거의 모든 웹사이트가 HTTPS를 사용함  

---

## 특징
- **Stateless (무상태성)**  
  - 요청과 응답이 끝나면 연결을 유지하지 않음  
  - 서버는 이전 요청을 기억하지 않음  
  - (대신, 쿠키/세션/토큰 같은 방법으로 상태 유지 가능)  

- **Connectionless (비연결성)**  
  - 요청/응답 한 번 완료되면 연결을 끊음  
  - HTTP/1.1부터는 `Keep-Alive`로 일정 시간 연결 유지 가능  

---

## 정리
- HTTP는 **클라이언트-서버 간 데이터 통신 규약**  
- **요청(Request)** → 메서드, 헤더, 바디  
- **응답(Response)** → 상태 코드, 헤더, 바디  
- 대표적인 메서드 : GET, POST, PUT, PATCH, DELETE  
- 대표적인 상태 코드 : 200, 404, 500 등  
- HTTP는 암호화되지 않고, HTTPS는 암호화된 안전한 프로토콜  

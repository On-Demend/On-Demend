# Protocols

### OSI 7 계층 모델
1. **물리 계층 (Physical)**  
    - 전기적·기계적 신호로 비트 전송  
2. **데이터 링크 계층 (Data Link)**  
    - 프레임 단위 오류 검출·수정, MAC 주소 사용  
3. **네트워크 계층 (Network)**  
    - 패킷 전송·라우팅, IP 주소 사용  
4. **전송 계층 (Transport)**  
    - 종단 간 신뢰성·흐름 제어, TCP/UDP 포트 번호 사용  
5. **세션 계층 (Session)**  
    - 통신 세션 설정·유지·종료  
6. **표현 계층 (Presentation)**  
    - 데이터 형식 변환·암호화·압축  
7. **응용 계층 (Application)**  
    - 사용자 인터페이스 제공, HTTP·FTP 등 프로토콜 동작

### TCP/IP 4 계층 모델
1. **네트워크 인터페이스 계층**  
    - 물리·데이터 링크 계층 역할  
2. **인터넷 계층**  
    - IP를 통한 패킷 전달·라우팅  
3. **전송 계층**  
    - TCP·UDP를 통한 종단 간 전송  
4. **응용 계층**  
    - HTTP·DNS·SMTP 등 애플리케이션 프로토콜

## 캡슐화/역캡슐화 (Encapsulation/Decapsulation)
- **캡슐화**: 상위 계층의 데이터를 하위 계층 헤더(및 트레일러)와 결합  
- **역캡슐화**: 수신 측에서 하위 계층 헤더를 순차 제거하면서 상위 계층으로 전달


## 전송 계층 프로토콜

### TCP
- **헤더 주요 필드**: Source Port, Dest Port, Seq, Ack, Flags, Window 등  
- **특징**:  
    - 연결 지향 (Connection-oriented)  
    - 신뢰성 보장 (재전송·오더링)  
    - 흐름 제어·혼잡 제어 지원

### UDP
- **헤더 주요 필드**: Source Port, Dest Port, Length, Checksum  
- **특징**:  
    - 비연결성 (Connection-less)  
    - 낮은 오버헤드  
    - 실시간 전송(VoIP, 스트리밍) 적합

## Handshake

### 3-Way Handshake (TCP 연결 수립)
1. 클라이언트 → 서버: **SYN**  
2. 서버 → 클라이언트: **SYN-ACK**  
3. 클라이언트 → 서버: **ACK**

### 4-Way Handshake (TCP 연결 해제)
1. A → B: **FIN**  
2. B → A: **ACK**  
3. B → A: **FIN**  
4. A → B: **ACK**

## 라우팅 (3계층)
- **라우팅**: 목적지 IP에 따라 패킷을 최적 경로로 전달

### Static Routing
- 관리자가 수동으로 경로 설정  
- 네트워크 변경 시 수동 수정 필요

### Dynamic Routing
- OSPF, BGP 등 프로토콜로 자동 경로 학습·분배  
- 토폴로지 변화에 대응

### Default Routing
- 명시적 경로가 없을 때 모든 트래픽을 특정 게이트웨이로 전달

## 주요 프로토콜
- **HTTP**: 웹 서비스 요청·응답, 포트 80 (포트 8080도 많이 사용) 
- **HTTPS**: TLS/SSL 암호화 HTTP, 포트 443  
- **SSH**: 원격 로그인·명령 실행, 포트 22, 암호화 터널링  
- **FTP**: 파일 전송, 제어(21)/데이터(20) 포트, Active/Passive 모드  
- **SMTP**: 메일 발송, 포트 25/587  
- **DNS**: 도메인 이름 ↔ IP 매핑, 포트 53, UDP/TCP  
- **DHCP**: 동적 IP 할당, 포트 67/68  
- **SNMP**: 네트워크 관리, 포트 161/162  
- **NTP**: 시간 동기화, 포트 123  
- **MQTT**: 경량 메시징, IoT·마이크로서비스, 포트 1883  
- **gRPC**: HTTP/2 기반 원격 프로시저 호출, 마이크로서비스 통신

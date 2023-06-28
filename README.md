# 어린이집 입소 대기 시스템
- 어린이집 입소대기 시스템을 운영하는 한 기관에서 기존에 운영하던 온프레미스 기반의 시스템을 퍼블릭 클라우드로 이관
# 협업 도구 및 개발 환경
- OS : Windows, Mac, Ubuntu
- 언어 및 기술스택 : Node.js (Express), DynamoDB, MySQL
- 형상 관리 : Git / Github
- 협업 : Github Project Board / Discord / Zoom
- CI/CD : Github Actions
- IaC : Terraform
# Architecture Diagram
- 어린이집 입소대기 시스템과 아동 관리 시스템으로 이루어져 있으며 각 시스템을 동기화 해줄 서비스가 가운데에 위치
![team7__의 복사본](https://github.com/cs-devops-bootcamp/devops-04-Final-Team7/assets/107600263/992d485f-1ed6-4d59-80b5-c80d6e457e6e)
# 기능 구현
## 입소대기신청시스템(ReqSys)
- 학부모와 아이들의 등록 정보 관리
- 입소신청시스템에서 요청이 들어올 경우 WAS(EKS)에 접근
- WAS(EKS)는 요청 Body 내용을 통합 이벤트큐(IntergrateEventQueue)로 전달
### 환경변수
- HOSTNAME: 데이터베이스 호스트명
- USERNAME: 데이터베이스 유저명
- PASSWORD: 데이터베이스 비밀번호
- DATABASE: 사용 데이터베이스명(기본적으로 nursery 사용 권장)
- REGION: 사용할 리전
- AWS_ACCESS_KEY_ID: AWS IAM 액세스키
- AWS_SECRET_ACCESS_KEY: AWS IAM 시크릿액세스키
  - 해당 액세스키는 sqs:SendMessage 권한을 가지고 있어야합니다.
- QUEUE_URL: 통합 이벤트 큐 URL
dev 환경에서는 dotenv를 사용할 수 있습니다.
### API 엔드포인트
#### GET /admin/init (DB 초기화)
DROP 미구현으로 RDS 생성 후 최초 1회에만 정상 동작합니다.
#### POST /enterwait/request (신청)
#### POST /enterwait/cancel (취소)
#### POST /request/accept (아동관리시스템에서 승인한 정보 동기화)
#### POST /request/reject (아동관리시스템에서 반려한 정보 동기화)
POST 요청의 body는 JSON 포맷으로 내용은 동일합니다.
```JSON
{
    "child_id": "202301013333333",
    "child_name": "namae",
    "child_birthday": "20230101",
    "user_id": "user",
    "parent_name": "onamae",
    "parent_tel": "010-0000-0000",
    "parent_address": "address",
    "parent_postcode": "00001",
    "parent_email": "user@email.com",
    "nursery_id": "A00017"
}
```
## 입소대기 신청관리시스템 (ReqManageSys)
- 신청 상태 모니터링 및 취소 가능
- DynamoDB가 트리거가 되어 이벤트 버스의 룰에 의해 다음 행동 결정
- 신청/취소 Rule
    - 전달 큐로 이동
    - 전달 큐의 내용을 아동관리시스템로 전달하는 Lambda(SQSToNursery) 실행
    - 전달된 URL에 의해 아동관리시스템이 데이터베이스에 동일한 데이터가 저장
- 신청 정보의 이메일로 보내기 위해 SES에 접근하는 Lambda(SendEmail) 실행
### 시스템 구성
- 입소대기신청시스템에서 신청/취소 이벤트 발생
  1. 통합 이벤트 큐로 메시지 발송
  2. SQS To DynamoDB가 메시지를 테이블에 저장
  3. DyanamoDB to EventBridge가 이벤트 버스로 이벤트 전송
  4. Rule에 따른 처리
    - 신청 Rule
      - Send Email이 신청 완료 메일 발송
      - 전달 큐로 메시지 발송 ▶ SQS To Nursery가 아동관리시스템을 호출하여 신청 정보 동기화
    - 취소 Rule
      - Send Email이 취소 완료 메일 발송
      - 전달 큐로 메시지 발송 ▶ SQS To Nursery가 아동관리시스템을 호출하여 취소 정보 동기화
- 아동관리시스템에서 승인/반려 이벤트 발생
  1. 통합 이벤트 큐로 메시지 발송
  2. SQS To DynamoDB가 메시지를 테이블에 저장
  3. DyanamoDB to EventBridge가 이벤트 버스로 이벤트 전송
  4. Rule에 따른 처리
    - 승인 Rule
      - Send Email이 승인 완료 메일 발송
      - 전달 큐로 메시지 발송 ▶ SQS To Enterwait이 입소대기신청시스템을 호출하여 승인 정보 동기화
    - 반려 Rule
      - Send Email이 반려 완료 메일 발송
      - 전달 큐로 메시지 발송 ▶ SQS To Enterwait이 입소대기신청시스템을 호출하여 반려 정보 동기화
     
### 환경변수
#### Lambda : SQS To DynamoDB
- TABLE_NAME: DynamoDB 테이블명
#### Lambda : DynamoDB to EventBridge
- EVENT_BUS_NAME: 이벤트 버스명
#### Lambda : Send Email
- 별도의 환경변수 불필요
  - 단, 샌드박스 모드에서는 확인된 자격 증명으로만 메일을 보낼 수 있기 때문에 메일 주소가 하드코딩되어 있음에 주의
#### Lambda : SQS To Nursery
- REQUEST_URL: 아동관리시스템/enterwait/request 로 지정 필요
- CANCEL_URL: 아동관리시스템/enterwait/cancel 로 지정 필요
#### Lambda : SQS To Enterwait
- ACCEPT_URL: 입소대기신청시스템/request/accept 로 지정 필요
- REJECT_URL: 입소대기신청시스템/request/reject 로 지정 필요
## 아동관리시스템 (ChildManageSys)
- 어린이집 신청 및 입소 요청 처리
- 승인/반려 및 입소대기 신청시스템에서 신청/취소한 정보 동기화
### 환경변수
- HOSTNAME: 데이터베이스 호스트명
- USERNAME: 데이터베이스 유저명
- PASSWORD: 데이터베이스 비밀번호
- DATABASE: 사용 데이터베이스명(기본적으로 nursery 사용 권장)
- REGION: 사용할 리전
- AWS_ACCESS_KEY_ID: AWS IAM 액세스키
- AWS_SECRET_ACCESS_KEY: AWS IAM 시크릿액세스키
  - 해당 액세스키는 sqs:SendMessage 권한을 가지고 있어야합니다.
- QUEUE_URL: 통합 이벤트 큐 URL

dev 환경에서는 dotenv를 사용할 수 있습니다.

### API 엔드포인트
#### GET /admin/init (DB 초기화)
DROP 미구현으로 RDS 생성 후 최초 1회에만 정상 동작합니다.
#### POST /request/accept (승인)
#### POST /request/reject (반려)
#### POST /enterwait/request (입소대기신청시스템에서 신청한 정보 동기화)
#### POST /enterwait/cancel (입소대기신청시스템에서 취소한 정보 동기화)
POST 요청의 body는 JSON 포맷으로 내용은 동일합니다.
```JSON
{
    "child_id": "202301013333333",
    "child_name": "namae",
    "child_birthday": "20230101",
    "user_id": "user",
    "parent_name": "onamae",
    "parent_tel": "010-0000-0000",
    "parent_address": "address",
    "parent_postcode": "00001",
    "parent_email": "user@email.com",
    "nursery_id": "A00017"
}
```

# 입소대기신청시스템(ReqSys)
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


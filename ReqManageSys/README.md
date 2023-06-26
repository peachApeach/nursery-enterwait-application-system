# 입소대기신청관리시스템(ReqManageSys)

## 시스템 구성
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
     
## 환경변수
### Lambda : SQS To DynamoDB
- TABLE_NAME: DynamoDB 테이블명
### Lambda : DynamoDB to EventBridge
- EVENT_BUS_NAME: 이벤트 버스명
### Lambda : Send Email
- 별도의 환경변수 불필요
  - 단, 샌드박스 모드에서는 확인된 자격 증명으로만 메일을 보낼 수 있기 때문에 메일 주소가 하드코딩되어 있음에 주의
### Lambda : SQS To Nursery
- REQUEST_URL: 아동관리시스템/enterwait/request 로 지정 필요
- CANCEL_URL: 아동관리시스템/enterwait/cancel 로 지정 필요
### Lambda : SQS To Enterwait
- ACCEPT_URL: 입소대기신청시스템/request/accept 로 지정 필요
- REJECT_URL: 입소대기신청시스템/request/reject 로 지정 필요


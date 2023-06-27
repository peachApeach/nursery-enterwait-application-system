#AWS acm certificate 인증서를 참조하는 코드
data "aws_acm_certificate" "love-liverpool-certificate" {
  domain   = var.domain-certificate
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}
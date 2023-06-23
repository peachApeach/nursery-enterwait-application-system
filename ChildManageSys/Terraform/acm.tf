#AWS acm certificate 인증서를 참조하는 코드
data "aws_acm_certificate" "love-liverpool-certificate" {
  domain   = var.domain-certificate
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}
#AWS route53의 도메인을 참조하는 코드
data "aws_route53_zone" "love-liverpool-domain" {
  name = var.domain
}

# 레코드 생성 테라폼 코드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
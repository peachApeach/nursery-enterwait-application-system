#AWS route53의 도메인을 참조하는 코드
data "aws_route53_zone" "love-liverpool-domain" {
  name = var.domain
}

# 레코드 생성 테라폼 코드
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.love-liverpool-domain.zone_id
  name    = "www.${data.aws_route53_zone.love-liverpool-domain.name}"
  type    = "A"

  alias {
    name                   = aws_lb.final-projcet-ecs-lb.dns_name
    zone_id                = aws_lb.final-projcet-ecs-lb.zone_id
    evaluate_target_health = true
  }
}
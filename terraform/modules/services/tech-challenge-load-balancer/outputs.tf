output "load_balancer_id" {
  value = aws_elb.web_elb.id
}

output "tech_elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
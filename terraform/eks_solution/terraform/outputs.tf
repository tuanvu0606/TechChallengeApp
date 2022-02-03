# output "load_balancer_dns_name" {
#   value       = module.tech_challenge_load_balancer.tech_elb_dns_name
#   description = "Load Balancer DNS name"
# }

output "tech_challenge_vpc_id" {
  value       = module.tech_challenge_vpc.tech_challenge_vpc_id
  description = "Tech Challenge VPC ID"
  sensitive   = true
}

# output "challenge_scaling_group_tls_private_key_pem_content" {
#   value = module.tech_challenge_key_pair.tech_tls_private_key_pem_content
#   sensitive = true
#   description = "tls private key content"
# }

output "challenge_postgres_db_endpoint" {
  value = module.tech_challenge_db_instance.endpoint
  sensitive = false
  description = "challenge_postgres_db_endpoint"
}


output "challenge_postgres_db_host" {
  value = module.tech_challenge_db_instance.address
  sensitive = false
  description = "challenge_postgres_db_endpoint"
}

output "challenge_postgres_db_port" {
  value = module.tech_challenge_db_instance.port
  sensitive = false
  description = "challenge_postgres_db_endpoint"
}

output "eks_cluster_name" {
  value = module.tech_challenge_eks_cluster.name
  sensitive = false
  description = "eks cluster name"
}

output "eks_solution_region" {
  value = var.eks_solution_region
  sensitive = false
  description = "eks solution region"
}

output "tech_challenge_iam_role_eks_nodes_arn" {
  value = module.tech_challenge_iam_role_eks_nodes.arn
  sensitive = false
  description = "eks solution region"
}

output "tech_challenge_iam_role_eks_nodes_name" {
  value = module.tech_challenge_iam_role_eks_nodes.name
  sensitive = false
  description = "eks solution region"
}
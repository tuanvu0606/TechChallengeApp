resource "aws_eks_cluster" "eks_cluster" {
  name            = var.name
  role_arn        = var.role_arn
  version         = var.cluster_version
  vpc_config  {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids 
  }
}

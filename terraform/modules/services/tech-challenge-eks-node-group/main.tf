resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # depends_on = [
  #   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  # ]
}
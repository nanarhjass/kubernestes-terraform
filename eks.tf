resource "aws_eks_cluster" "main" {
  name     = "my-cluster"
  role_arn  = aws_iam_role.eks_cluster.arn
  version   = "1.24"  # Replace with the desired Kubernetes version

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id,
    ]
  }

  tags = {
    Name = "my-cluster"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids       = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
  ]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t2.micro"]

  tags = {
    Name = "my-node-group"
  }
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"] #tells to take the official amazon image

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#Create IAM Role for your EKS control plane
resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({    #Who is allowed to use this?
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

/*
    participant EKS as AWS EKS Service (eks.amazonaws.com)
    participant IAM as AWS IAM (Trust Policy)
    participant Role as Cluster Role

    EKS->>IAM: "Can I use the Cluster Role?"
    Note over IAM: Checks Trust Policy
    IAM->>IAM: 1. Is Principal "eks.amazonaws.com"? (YES)
    IAM->>IAM: 2. Is Action "sts:AssumeRole"? (YES)
    IAM->>IAM: 3. Can I tag the session? (sts:TagSession - YES)
    IAM->>EKS: "Access Granted. Here are your temp credentials."
    EKS->>Role: *Assumes Role with Session Tags*
*/

# Attach policy to above created role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

# Create EKS Control Plane
resource "aws_eks_cluster" "example" {
  name = var.cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  bootstrap_self_managed_addons = true

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = var.private_subnet
  }
}

#Create IAM Role for EKS Worker Node
resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#The Standard Worker Policy
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

#The Standard Registry Read-Only Policy
resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

#The CNI Policy (Critical for Networking)
resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

#Create Worker Node
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.cluster_name}-node-groups"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnet

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  instance_types = [var.instance_type]
  ami_type = "AL2_x86_64"

  tags = {
    Name = "${var.env}-app"
  }

  depends_on = [
    aws_eks_cluster.example,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly]
}

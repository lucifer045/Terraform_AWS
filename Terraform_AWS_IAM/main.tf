module "IAM_role" {
    source = "./modules/IAM_role"
    region = "us-west-1"

    roles = {
        ec2_role = {
            name = "ec2_role"
            description = "Role for EC2 for S3 and CloudWatch"
            trust_relationship = {
                Version = "2012-10-17"
                Statement = [{
                    Effect = "Allow"
                    Action = "sts:AssumeRole"
                    Principal = {
                        Service = "ec2.amazonaws.com"
                    }
                }]
            }
            policy_arn = [
                "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
                "arn:aws:iam::aws:policy/CloudWatchFullAccess"
            ]
        }

        lambda_role = {
            name = "lambda_role"
            description = "Lambada role for execution"
            trust_relationship = {
                Version = "2012-10-17"
                Statement = [{
                    Effect = "Allow"
                    Action = "sts:AssumeRole"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                }]
            }
            policy_arn = [
                "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
            ]
        }
    }
    tags = {
        Name = "dev-role"
        Environment = "dev"
        Project = "terraform_iam"
    }
  
}
# Configure the AWS provider
provider "aws" {
   region = var.region
}

# IAM ROLES CREATION
resource "aws_iam_role" "roles"{

    # Creates multiple IAM roles from variable "roles"
    # Each key in var.roles becomes one IAM role
    for_each = var.roles 
    name = each.value.name   # Actual IAM role name in AWS
    description = each.value.description
    assume_role_policy = jsonencode(each.value.trust_relationship)    # Trust policy (WHO can assume this role)
    tags = var.tags
} 

# IAM ROLE POLICY ATTACHMENTS
resource "aws_iam_role_policy_attachment" "attachements" {

    # This loop converts:
    # Roles -> Policies list
    # One policy attachment per role per policy
    for_each = {
        for pair in flatten([
            for role, role_data in var.roles: [
                for policy in role_data.policy_arn: {
                    role = role
                    policy = policy 
                }
            ]

        # Convert list into map
        # This creates unique keys:
        # Example: "ec2-role-arn1" => {role=..., policy=...}    
        ]) : "${pair.role}-${pair.policy}" => pair
    }
    role = aws_iam_role.roles[each.value.role].name 
    policy_arn = each.value.policy   # Policy ARN to attach
}


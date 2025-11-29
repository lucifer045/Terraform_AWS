provider "aws" {
   region = var.region
}

resource "aws_iam_role" "roles"{
    for_each = var.roles 
    name = each.value.name
    description = each.value.description
    assume_role_policy = jsonencode(each.value.trust_relationship)
    tags = var.tags
} 

resource "aws_iam_role_policy_attachment" "attachements" {
    for_each = {
        for pair in flatten([
            for role, role_data in var.roles: [
                for policy in role_data.policy_arn: {
                    role = role
                    policy = policy 
                }
            ]
        ]) : "${pair.role}-${pair.policy}" => pair
    }
    role = aws_iam_role.roles[each.value.role].name 
    policy_arn = each.value.policy
}


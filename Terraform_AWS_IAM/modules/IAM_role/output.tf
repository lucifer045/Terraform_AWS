output "role_name" {
  description = "Roles that are created"
  value = keys(aws_iam_role.roles)
}

output "roles_arn" {
    description = "ARN of Roles created"
    value = {
        for name, role in aws_iam_role.roles :
        name => role.arn 
    }
}

output "role_policy_mapping" {
  description = "role to policy mapping"
  value = {
    for pair in flatten([
        for role, role_data in var.roles : [
            for policy in role_data.policy_arn: {
                role = role
                policy = policy
                }
            ]
        ]) :
        "${pair.role}-${pair.policy}" => pair.policy 
    }
  }

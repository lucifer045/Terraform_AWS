output "upload_bucket_name" {
  value = module.s3.bucket_id
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}
provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source        = "./modules/s3"
  bucket_prefix = "my-bucket"
  env           = "dev"
}

module "lambda" {
    source = "./modules/lambda"
    env = "dev"
    s3_bucket_arn = module.s3.bucket_arn
    dynamodb_table_arn = module.dynamodb.table_arn
    dynamodb_table_name = module.dynamodb.table_name
}

#It configures S3 to invoke Lambda automatically when a .jpg file is uploaded into the bucket.
resource "aws_s3_bucket_notification" "bucket_notification"{
    bucket = module.s3.bucket_id
    lambda_function {
      lambda_function_arn = module.lambda.function_arn
      events = ["s3:ObjectCreated:*"]
      filter_suffix = ".jpg"
    }

    depends_on = [module.lambda]
}

module "dynamodb" {
  source = "./modules/dynamodb"
  env = dev
}
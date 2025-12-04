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
}

resource "aws_s3_bucket_notification" "bucket_notification"{
    bucket = module.s3.bucket_id
    lambda_function {
      lambda_function_arn = module.lambda.function_arn
      events = ["s3:ObjectCreated:*"]
      filter_suffix = ".jpg"
    }

    depends_on = [module.lambda]
}
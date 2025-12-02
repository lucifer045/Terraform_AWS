resource "random_id" "bucket_suffix" {
    byte_length = 4
}

resource "aws_s3_bucket" "upload" {
    bucket = "${var.bucket_prefix}-${var.env}-${random_id.bucket_suffix.hex}"

    force_destroy = var.env == "prod" ? false : true

    tags = {
        Name = "${var.bucket_prefix}-${var.env}"
        Environment = var.env
    }
}

resource "aws_s3_bucket_public_access_block" "upload" {
    bucket = aws_s3_bucket.upload.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "upload" {
    bucket = aws_s3_bucket.upload.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload" {
   bucket = aws_s3_bucket.upload.id
   
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
   }
}
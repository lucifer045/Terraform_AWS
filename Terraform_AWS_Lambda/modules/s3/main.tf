resource "random_id" "bucket_suffix" {
    byte_length = 4  #This creates a random, stable, hexadecimal string that Terraform can reuse.
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

    block_public_acls = true    #Prevents anyone from creating ACLs that make objects public.
    block_public_policy = true  #Stops bucket policies that grant public access.
    ignore_public_acls = true   #Even if public ACL exists — AWS ignores it.
    restrict_public_buckets = true  #Disables cross-account public access.
}

resource "aws_s3_bucket_versioning" "upload" {
    bucket = aws_s3_bucket.upload.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload" {
   bucket = aws_s3_bucket.upload.id
# It ensures every object uploaded to your bucket is automatically encrypted by AWS.   
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
   }
}
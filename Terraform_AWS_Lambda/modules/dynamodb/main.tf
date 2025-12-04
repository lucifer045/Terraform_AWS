resource "aws_dynamodb_table" "data" {
  name = "metadata-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "ImageID"   #This is the partition key of the table

  attribute {
    name = "ImageID"
    type = "S"   #String
  }

  tags = {
    Name = "${var.env}-metadata"
    Environment = var.env
  }
}


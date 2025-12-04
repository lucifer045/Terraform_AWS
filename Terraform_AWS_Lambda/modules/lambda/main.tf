data "archiive_file" "lambda_zip"{
    type = "zip"
    source_dir = "${path.module}/../../src"
    output_path = "${path.module}/function.zip"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda-role-${var.env}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
    role = aws_iam_role.lambda_role.name
     policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "s3_read_access" {
  name = s3_read_access
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = ["s3:GetObject"]
        Effect = "Allow"
        Resource = "${var.s3_bucket_arn}/*"
    }]
  })
}

resource "aws_lambda_function" "processor" {
   function_name = "${var.env}-processsor"
   filename = data.archiive_file.lambda_zip.output_path
   source_code_hash = data.archiive_file.lambda_zip.output_base64sha256
   role = aws_iam_role.lambda_role.arn
   handler = "process_image.lambda_handler"
   runtime = "python3.9"

   timeout = 10
   memory_size = 128

   environment {
     variables = {
        ENV = var.env
        TABLE_NAME = var.dynamodb_table_name
     }
   }
}

resource "aws_lambda_permission" "allow_s3"{
    statement_id = "AllowExecutionFroms3"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.processor.function_name
    principal = "s3.amazonaws.com"
    source_arn = var.s3_bucket_arn
}

resource "aws_iam_role_policy" "dynamodb_write" {
  name = "dynamodb-write-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = ["dynamodb:PutItem"]
            Effect = "Allow"
            Resource = var.dynamodb_table_arn
        }
    ]
  })
}
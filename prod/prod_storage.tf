resource "aws_s3_bucket" "my_bucket_created" {
    bucket = var.s3_bucket_name
}
resource "aws_s3_bucket_versioning" "versioning_status" {
    bucket = aws_s3_bucket.my_bucket_created.id
    versioning_configuration {
        status  = "Enabled"
    }
}
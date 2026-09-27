resource "random_id" "bucket_suffix" {
  byte_length = 4 //create random words
}

resource "aws_s3_bucket" "my-app-s3" {
  bucket        = "my-app-storage-bucket-${random_id.bucket_suffix.hex}" //use random function cuz bucket need to be globally unique
  force_destroy = true                                                   # Allows Terraform to cleanly destroy the bucket even if it has files inside if not true then even we terraform destroy it wont delete

  tags = {
    Name        = "app-storage-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "storage_versioning" { //will maintain version so we can recover old code if someone overwrites
  bucket = aws_s3_bucket.my-app-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "security_block" {
  bucket = aws_s3_bucket.my-app-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
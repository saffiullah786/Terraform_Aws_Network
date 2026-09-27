resource "aws_iam_user" "saffitest" {
  name = "saffitest"

  tags = {
    Description = "Learning user with full S3 and EC2 access"
  }
}
resource "aws_iam_user_policy_attachment" "s3_full" {
  user       = aws_iam_user.saffitest.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_user_policy_attachment" "ec2_full" {
  user       = aws_iam_user.saffitest.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_role" "ec2_role" {
  name = "private-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_full" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "private-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
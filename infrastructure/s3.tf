resource "aws_s3_bucket" "media" {
  bucket = "${var.app_name}-media-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "media" {
  bucket              = aws_s3_bucket.media.id
  block_public_acls   = false
  block_public_policy = false
}

data "aws_caller_identity" "current" {}
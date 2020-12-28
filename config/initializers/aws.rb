require 'aws-sdk-s3'

$s3 = Aws::S3::Client.new(
    access_key_id: Rails.application.credentials.fetch(:aws_access_key_id),
    secret_access_key: Rails.application.credentials.fetch(:aws_secret_access_key),
    region: Rails.application.credentials.fetch(:aws_region)
)

BUCKET_NAME = Rails.application.credentials.fetch(:aws_s3_bucket_name)

$iam = Aws::IAM::Client.new(
    access_key_id: Rails.application.credentials.fetch(:aws_access_key_id),
    secret_access_key: Rails.application.credentials.fetch(:aws_secret_access_key),
    region: Rails.application.credentials.fetch(:aws_region)
)

GROUP_NAME = Rails.application.credentials.fetch(:aws_s3_group_name)

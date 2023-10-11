output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_metalgear_hosting.bucket_name
  #value = module.terrahome_aws.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_metalgear_hosting.website_endpoint
  #value = module.terrahome_aws.website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value = module.home_metalgear_hosting.domain_name
  #value = module.terrahome_aws.domain_name
}



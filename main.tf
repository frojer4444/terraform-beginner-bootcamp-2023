terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

  cloud {
    organization = "Icario"
    workspaces {
      name = "terra-house-1"
    }
  }  
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token = var.terratowns_access_token
}

module "home_metalgear_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  #bucket_name = var.bucket_name
  public_path = var.metalgear.public_path
  #index_html_filepath = var.index_html_filepath
  #error_html_filepath = var.error_html_filepath
  content_version = var.metalgear.content_version
  #assets_path = var.assets_path
}

resource "terratowns_home" "home_metalgear" {
    name = "Metal Gear"
    description = <<DESCRIPTION
  The first Metal Gear on the original NES (US Version)
  is one of the best video games of all time and will be available 
  in the Metal Gear Solid Collection 1 that's coming to the
  PS5 later this month
  DESCRIPTION
    domain_name = module.home_metalgear_hosting.domain_name
    #domain_name = "3fafa3.cloudfront.net"
    town = "missingo"
    content_version = var.metalgear.content_version
}

module "home_tng_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  #bucket_name = var.bucket_name
  public_path= var.tng.public_path
  #index_html_filepath = var.index_html_filepath
  #error_html_filepath = var.error_html_filepath
  content_version = var.tng.content_version
  #assets_path = var.assets_path
}

resource "terratowns_home" "home_tng" {
    name = "Star Trek: The Next Generation"
    description = <<DESCRIPTION
  Star Trek: The Next Generation, my favorite tv 
  show of all time. If you have the H&I Network station
  in your cable or streaming package, it can be watched every
  Sunday-Friday at 7:00pm CST.
  DESCRIPTION
    domain_name = module.home_tng_hosting.domain_name
    #domain_name = "3fafa3.cloudfront.net"
    town = "missingo"
    content_version = var.tng.content_version
}
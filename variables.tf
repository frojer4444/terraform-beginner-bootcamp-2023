variable "terratowns_endpoint" {
 type = string
}

variable "terratowns_access_token" {
 type = string
}

variable "teacherseat_user_uuid" {
 type = string
}

variable "metalgear" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "tng" {
  type = object({
    public_path = string
    content_version = number
  })
}

#variable "content_version" {
#  type = number
#}  



#variable "bucket_name" {
#    type = string
#}



#variable "tng_public_path" {
#  type = string
#}

#variable "index_html_filepath" {
#  type   = string
#}

#variable "error_html_filepath" {
#  type   = string
#}



#variable "assets_path" {
#  description = "Path to assets folder"
#  type = string
#}
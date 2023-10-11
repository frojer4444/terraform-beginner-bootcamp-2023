variable "user_uuid" {
  type        = string
  description = "User UUID in a specific format"
  
  validation {
    condition     = can(regex("^([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' where x is a hexadecimal digit."
  }
}

variable "public_path" {
  type        = string
  description = "the file path for the public directory"
}



variable "content_version" {
  type = number

  validation {
    condition     = var.content_version >= 1
    error_message = "content_version must be a positive integer starting at 1."
  }
}


#variable "bucket_name" {
#  type        = string
#  description = "Name of the AWS S3 bucket"
#
#  validation {
#    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
#    error_message = "Bucket name must be between 3 and 63 characters, and can only contain lowercase letters, numbers, hyphens, and periods. It must start and end with a lowercase letter or number."
#  }
#}



#  validation {
#    condition     = fileexists(var.index_html_filepath)
#    error_message = "The specified index_html_filepath does not exist."
#  }


#variable "error_html_filepath" {
#  type        = string
#  description = "Filepath to the error.html file"
#
#  validation {
#    condition     = fileexists(var.error_html_filepath)
#    error_message = "The specified error_html_filepath does not exist."
#  }
#}

#variable "assets_path" {
#  description = "Path to assets folder"
#  type = string
#}

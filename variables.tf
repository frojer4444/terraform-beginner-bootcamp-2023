variable "user_uuid" {
  type        = string
  description = "User UUID in a specific format"
  
  validation {
    condition     = can(regex("^([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' where x is a hexadecimal digit."
  }
}

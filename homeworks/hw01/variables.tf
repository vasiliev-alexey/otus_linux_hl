variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

# variable "public_key_path" {
#   description = "Path to public key used for ssh access"
#   type        = string
# }

variable "cloud_image_id" {
  description = "image for virual machine in cloud"
  type        = string
}
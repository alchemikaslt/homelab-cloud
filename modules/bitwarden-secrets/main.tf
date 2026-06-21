# terraform {
#   required_providers {
#     bitwarden-secrets = {
#             source = "bitwarden/bitwarden-secrets"
#             version = "0.5.4-pre"
#     }
#   }
# }

# # Bitwarden Secrets Manager provider
# provider "bitwarden-secrets" {
#     api_url      = "https://api.bitwarden.com"
#     identity_url = "https://identity.bitwarden.com"
#     access_token = var.BW_ACCESS_TOKEN
#     organization_id = var.BW_ORGANIZATION_ID
# }
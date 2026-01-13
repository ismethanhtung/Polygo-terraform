# Terraform backend configuration
environment      = "global"
project_name     = "polygo"
state_bucket_name = "polygo-infra-terraform-state"
lock_table_name   = "polygo-infra-terraform-lock"
billing_mode      = "PAY_PER_REQUEST"
hash_key          = "LockID"
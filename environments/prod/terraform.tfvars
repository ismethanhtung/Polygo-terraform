# --- environments/prod/terraform.tfvars ---

aws_region           = "ap-southeast-1"
environment          = "prod"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = []
db_name              = "polygo_prod_db"
db_username          = "admin"
db_password          = "SuperSecretPass123!" # Trong thực tế nên dùng AWS Secrets Manager
instance_type        = "t3.micro"
project_name         = "Polygo"

# Supabase Configuration
supabase_url = "https://tenghuxzjlxvqyrycyts.supabase.co"
supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlbmdodXh6amx4dnF5cnljeXRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyMjgwNDUsImV4cCI6MjA3NzgwNDA0NX0.jook-ubNJK-aVBbFsIUw_xREdH5zwYynfnvkn52jICs"

key_name            = "basekey"
public_key          = ######
instance_type       = ["t2.micro", "t2.medium"]
ami                 = ["ami-03c7d01cf4dedc891", "ami-0aa2b7722dc1b5612"]
cidr_block          = "10.0.0.0/16"
cidr_blocks         = ["10.0.1.0/24", "10.0.2.0/24"]
public_ip_on_launch = true
az                  = ["us-east-1a", "us-east-1b"]
subnet_tags         = ["dev", "prod"]
counts              = 2

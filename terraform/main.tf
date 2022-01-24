terraform {
  backend "s3" {
    # Replace this wicd -th your bucket name!
    bucket         = "challenge-terraform-state-s3-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "challenge-terraform-state-dynamodb"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# ------------------------------------------------------------------------------- VPC ------------------------------------------------------------------- #

module "tech_challenge_vpc" {
  source = "./modules/services/tech-challenge-vpc"

  # key_name = "challenge_tls_key"
}

# ------------------------------------------------------------------------------- Subnets ---------------------------------------------------------------- #

module "tech_challenge_subnet_1" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
}

# ------------------------------------------------------------------------------- Internet Gateway-------------------------------------------------------- #

module "tech_challenge_internet_gateway" {
  source = "./modules/services/tech-challenge-internet-gateway"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
}

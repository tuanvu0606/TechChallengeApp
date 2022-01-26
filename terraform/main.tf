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

variable "challenge_postgres_db_password" {
  type        = string
  description = "This is another example input variable using env variables."
}
# ------------------------------------------------------------------------------- VPC ------------------------------------------------------------------- #

module "tech_challenge_vpc" {
  source = "./modules/services/tech-challenge-vpc"
  enable_dns_hostnames = true
}

# ------------------------------------------------------------------------------- Subnets ---------------------------------------------------------------- #

module "tech_challenge_public_subnet_1" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.4.0/24"
  tags_name = "Tech Challenge Public Subnet"
  availability_zone = "ap-southeast-1a"

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_public_subnet_2" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.5.0/24"
  tags_name = "Tech Challenge Public Subnet 2"
  availability_zone = "ap-southeast-1b"

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_private_subnet_1" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.6.0/24"
  tags_name = "Tech Challenge Private Subnet"
  availability_zone = "ap-southeast-1a"

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_private_subnet_2" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.7.0/24"
  tags_name = "Tech Challenge Private Subnet"
  availability_zone = "ap-southeast-1b"

  depends_on = [module.tech_challenge_vpc]
}



# ------------------------------------------------------------------------------- Internet Gateway-------------------------------------------------------- #

module "tech_challenge_internet_gateway" {
  source = "./modules/services/tech-challenge-internet-gateway"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id

  depends_on = [module.tech_challenge_vpc]
}

# ------------------------------------------------------------------------------- Route Table -------------------------------------------------------- #

module "tech_challenge_route_table" {
  source = "./modules/services/tech-challenge-route-table"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id

  internet_gateway_id = module.tech_challenge_internet_gateway.internet_gateway_id

  depends_on = [
    module.tech_challenge_vpc, 
    module.tech_challenge_internet_gateway
  ]
}

# ------------------------------------------------------------------------------- Main Route Table Association------------------------------------------ #

module "tech_challenge_main_route_table_association_public" {
  source = "./modules/services/tech-challenge-main-route-table-association"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id

  route_table_id = module.tech_challenge_route_table.route_table_id

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_route_table    
  ]
}


# ------------------------------------------------------------------------------- Route Table Association---------------------------------------------- #

module "tech_challenge_route_table_association_public_1" {
  source = "./modules/services/tech-challenge-route-table-association"

  subnet_id = module.tech_challenge_public_subnet_1.subnet_id

  route_table_id = module.tech_challenge_route_table.route_table_id

  depends_on = [
    module.tech_challenge_route_table    
  ]
}

module "tech_challenge_route_table_association_public_2" {
  source = "./modules/services/tech-challenge-route-table-association"

  subnet_id = module.tech_challenge_public_subnet_2.subnet_id

  route_table_id = module.tech_challenge_route_table.route_table_id

  depends_on = [
    module.tech_challenge_route_table    
  ]
}


# ------------------------------------------------------------------------------- Security Group ----------------------------------------------------- #

module "tech_challenge_security_group_frontend" {
  source = "./modules/services/tech-challenge-security-group"
  name = "tech_challenge_security_group_frontend"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  ingress_rules = [
    {
      cidr_blocks      = ["0.0.0.0/0",]
      description      = ""
      from_port        = 3000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3000
    }
  ]

  egress_rules = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]


  depends_on = [
    module.tech_challenge_vpc    
  ]
}

module "tech_challenge_security_group_database" {
  source = "./modules/services/tech-challenge-security-group"
  name = "tech_challenge_security_group_database"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  ingress_rules = [
    {
      cidr_blocks      = [
        "10.0.4.0/24",
        "10.0.5.0/24" 
      ]
      description      = ""
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    }
  ]

  egress_rules = [
    {
      cidr_blocks      = [
        "10.0.4.0/24",
        "10.0.5.0/24" 
      ]
      description      = ""
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    },
  ]


  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ------------------------------------------------------------------------------- Key Pair ----------------------------------------------- #

module "tech_challenge_key_pair" {
  source = "./modules/services/tech-challenge-key-pair"

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ------------------------------------------------------------------------------- Launch Configuration ----------------------------------------------- #

module "tech_challenge_launch_configuration" {
  source = "./modules/services/tech-challenge-launch-configuration"

  key_name = module.tech_challenge_key_pair.key_name
  security_group_id = module.tech_challenge_security_group_frontend.security_group_id

  database_host = module.tech_challenge_db_instance.address
  database_port = module.tech_challenge_db_instance.port
  database_password = var.challenge_postgres_db_password
  

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ---------------------------------------------------- Load Balancer ------------------------------------------------------------- #

module "tech_challenge_load_balancer" {
  source = "./modules/services/tech-challenge-load-balancer"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  subnet_list = [
    module.tech_challenge_public_subnet_1.subnet_id,
    module.tech_challenge_public_subnet_2.subnet_id
  ]

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ---------------------------------------------------- Auto Scaling Group ---------------------------------------------------------------- #

module "tech_challenge_auto_scaling_group" {
  source = "./modules/services/tech-challenge-auto-scaling-group"

  load_balancer_id = module.tech_challenge_load_balancer.load_balancer_id
  launch_configuration_name = module.tech_challenge_launch_configuration.launch_configuration_name
  public_subnet_list = [
    module.tech_challenge_public_subnet_1.subnet_id,
    module.tech_challenge_public_subnet_2.subnet_id
  ]

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_db_instance,
    module.tech_challenge_security_group_frontend
  ]
}

# ---------------------------------------------------- DB Instance ---------------------------------------------------------------- #

module "tech_challenge_db_instance" {
  source = "./modules/services/tech-challenge-db-instance"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  challenge_postgres_db_password = var.challenge_postgres_db_password
  db_instance_sg_id = module.tech_challenge_security_group_database.security_group_id

  private_subnet_list = [
    module.tech_challenge_private_subnet_1.subnet_id,
    module.tech_challenge_private_subnet_2.subnet_id
  ]

  depends_on = [
    module.tech_challenge_vpc    
  ]
}
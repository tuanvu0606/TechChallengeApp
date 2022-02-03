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
  enable_dns_hostnames = true
}

# ------------------------------------------------------------------------------- Subnets ---------------------------------------------------------------- #

module "tech_challenge_public_subnet_1" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.4.0/24"
  tags_name = "Tech Challenge Public Subnet"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_public_subnet_2" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.5.0/24"
  tags_name = "Tech Challenge Public Subnet 2"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = true

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_private_subnet_1" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.6.0/24"
  tags_name = "Tech Challenge Private Subnet"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = false

  depends_on = [module.tech_challenge_vpc]
}

module "tech_challenge_private_subnet_2" {
  source = "./modules/services/tech-challenge-subnet"

  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  cidr_block = "10.0.7.0/24"
  tags_name = "Tech Challenge Private Subnet"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = false

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
    module.tech_challenge_vpc,
    module.tech_challenge_route_table    
  ]
}

module "tech_challenge_route_table_association_public_2" {
  source = "./modules/services/tech-challenge-route-table-association"

  subnet_id = module.tech_challenge_public_subnet_2.subnet_id

  route_table_id = module.tech_challenge_route_table.route_table_id

  depends_on = [
    module.tech_challenge_vpc,
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
      cidr_blocks      = []
      description      = ""
      from_port        = 3000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [module.tech_challenge_security_group_elb.id,]
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

  tag_name = "tech_challenge_security_group_frontend"

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

module "tech_challenge_security_group_elb" {
  source = "./modules/services/tech-challenge-security-group"
  name = "tech_challenge_security_group_elb"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  ingress_rules = [
    {
      cidr_blocks      = ["0.0.0.0/0",]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
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

  tag_name = "tech_challenge_security_group_elb"

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

  tag_name = "tech_challenge_security_group_database"

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

module "tech_challenge_security_group_eks_cluster" {
  source = "./modules/services/tech-challenge-security-group"

  count = var.eks_solution ? 1 : 0

  name = "tech_challenge_security_group_eks_cluster"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  ingress_rules = [
    {
      cidr_blocks      = [
        "0.0.0.0/0" 
      ]
      description      = "Allow all"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  egress_rules = [
    {
      cidr_blocks      = [
        "0.0.0.0/0" 
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]

  tag_name = "tech_challenge_security_group_eks_cluster"

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

# ------------------------------------------------------------------- Launch Configuration ----------------------------------------------- #

module "tech_challenge_launch_configuration" {
  source = "./modules/services/tech-challenge-launch-configuration"

  key_name = module.tech_challenge_key_pair.key_name
  security_group_id = module.tech_challenge_security_group_frontend.id

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

  security_groups = [
    module.tech_challenge_security_group_elb.id
  ]

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ---------------------------------------------------- Auto Scaling Group ---------------------------------------------------------------- #

module "tech_challenge_auto_scaling_group_frontend" {
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

# ---------------------------------------------------- Auto Scaling Policy--------------------------------------------------------------- #

module "tech_challenge_auto_scaling_policy_frontend_up" {
  source = "./modules/services/tech-challenge-auto-scaling-policy"

  name                   = "tech_challenge_auto_scaling_policy_frontend_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.tech_challenge_auto_scaling_group_frontend.name
  
  depends_on = [
    module.tech_challenge_vpc
  ]
}

module "tech_challenge_auto_scaling_policy_frontend_down" {
  source = "./modules/services/tech-challenge-auto-scaling-policy"

  name                   = "tech_challenge_auto_scaling_policy_frontend_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.tech_challenge_auto_scaling_group_frontend.name
  
  depends_on = [
    module.tech_challenge_vpc
  ]
}

# ---------------------------------------------------- Cloudwatch Metric Alarm -------------------------------------------------------- #

module "tech_challenge_cloud_metric_alarm_up" {
  source = "./modules/services/tech-challenge-cloudwatch-metric-alarm"

  alarm_name          = "tech_challenge_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"
  dimensions          = {
    AutoScalingGroupName = module.tech_challenge_auto_scaling_group_frontend.name
  } 

  alarm_description   = "Tech Challenge increase alarm auto scaling group instance base on CPU"
  alarm_actions       = [
    module.tech_challenge_auto_scaling_policy_frontend_up.arn
  ]
  
  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_auto_scaling_policy_frontend_up
  ]
}

module "tech_challenge_cloud_metric_alarm_down" {
  source = "./modules/services/tech-challenge-cloudwatch-metric-alarm"

  alarm_name          = "tech_challenge_web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"
  dimensions          = {
    AutoScalingGroupName = module.tech_challenge_auto_scaling_group_frontend.name
  } 

  alarm_description   = "Tech Challenge decrease alarm auto scaling group instance base on CPU"
  alarm_actions       = [
    module.tech_challenge_auto_scaling_policy_frontend_down.arn
  ]
  
  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_auto_scaling_policy_frontend_down
  ]
}

# ---------------------------------------------------- DB Instance ---------------------------------------------------------------------- #

module "tech_challenge_db_instance" {
  source = "./modules/services/tech-challenge-db-instance"
  vpc_id = module.tech_challenge_vpc.tech_challenge_vpc_id
  challenge_postgres_db_password = var.challenge_postgres_db_password
  db_instance_sg_id = module.tech_challenge_security_group_database.id

  private_subnet_list = [
    module.tech_challenge_private_subnet_1.subnet_id,
    module.tech_challenge_private_subnet_2.subnet_id
  ]

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ---------------------------------------------------- IAM roles ---------------------------------------------------------------------- #

module "tech_challenge_iam_role_eks" {

  source = "./modules/services/tech-challenge-iam-role"

  count = var.eks_solution ? 1 : 0

  name = "tech_eks_iam_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      }
    ]
  })

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

module "tech_challenge_iam_role_eks_nodes" {

  source = "./modules/services/tech-challenge-iam-role"

  count = var.eks_solution ? 1 : 0

  name = "tech_eks_nodes_iam_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  depends_on = [
    module.tech_challenge_vpc    
  ]
}

# ---------------------------------------------------- IAM roles policy attachment------------------------------------------------------------------- #

module "tech_challenge_eks_iam_role_policy_attachment" {

  source = "./modules/services/tech-challenge-iam-role-policy-attachment"

  count = var.eks_solution ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = module.tech_challenge_iam_role_eks[0].name

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks 
  ]
}

module "tech_challenge_iam_role_policy_attachment_eks_worker_node" {

  source = "./modules/services/tech-challenge-iam-role-policy-attachment"

  count = var.eks_solution ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = module.tech_challenge_iam_role_eks_nodes[0].name

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks_nodes 
  ]
}

module "tech_challenge_iam_role_policy_attachment_eks_cni_policy" {

  source = "./modules/services/tech-challenge-iam-role-policy-attachment"

  count = var.eks_solution ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = module.tech_challenge_iam_role_eks_nodes[0].name

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks_nodes 
  ]
}

module "tech_challenge_iam_role_policy_attachment_eks_container_registry" {

  source = "./modules/services/tech-challenge-iam-role-policy-attachment"

  count = var.eks_solution ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = module.tech_challenge_iam_role_eks_nodes[0].name

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks_nodes 
  ]
}

# ---------------------------------------------------- EKS Cluster ------------------------------------------------------------------- #

module "tech_challenge_eks_cluster" {

  source = "./modules/services/tech-challenge-eks-cluster"

  count = var.eks_solution ? 1 : 0

  name            = "tech_challenge_eks_cluster"
  role_arn        = module.tech_challenge_iam_role_eks[0].arn
  cluster_version = "1.19"
  security_group_ids = [
    module.tech_challenge_security_group_eks_cluster[0].id
  ]

  subnet_ids       = [
    module.tech_challenge_public_subnet_1.subnet_id,
    module.tech_challenge_public_subnet_2.subnet_id
  ]

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks 
  ]
}

# ---------------------------------------------------- EKS Cluster Nodes --------------------------------------------------------- #

module "tech_challenge_eks_cluster_nodes" {

  source = "./modules/services/tech-challenge-eks-node-group"

  count = var.eks_solution ? 1 : 0

  cluster_name    = module.tech_challenge_eks_cluster[0].name
  node_group_name = "node_group_1"
  node_role_arn   = module.tech_challenge_iam_role_eks_nodes[0].arn
  subnet_ids      = [
    module.tech_challenge_public_subnet_1.subnet_id,
    module.tech_challenge_public_subnet_2.subnet_id
  ]

  desired_size = 1
  max_size     = 1
  min_size     = 1

  # tags = {
  #   "k8s.io/cluster-autoscaler/module.tech_challenge_eks_cluster[0].name" = "owned",
  #   "k8s.io/cluster-autoscaler/enabled" = true
  # }

  depends_on = [
    module.tech_challenge_vpc,
    module.tech_challenge_iam_role_eks 
  ]
}
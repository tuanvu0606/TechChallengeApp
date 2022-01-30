resource "aws_autoscaling_group" "tech_challenge_web_app_frontend" {
  # name = "tech-asg"
  name_prefix = "tech_challenge_launch_configuration"

  min_size             = 1
  desired_capacity     = 1
  max_size             = 4
  
  health_check_type    = "ELB"
  load_balancers = [
    var.load_balancer_id
  ]

  launch_configuration = var.launch_configuration_name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = var.public_subnet_list
    
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "tech-challenge-web-instance"
    propagate_at_launch = true
  }

}
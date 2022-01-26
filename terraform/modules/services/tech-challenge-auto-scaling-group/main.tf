resource "aws_autoscaling_group" "tech_challenge_web_app" {
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

# autoscaling_policy up

resource "aws_autoscaling_policy" "tech_challenge_policy_up" {
  name = "tech_challenge_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.tech_challenge_web_app.name
}

resource "aws_cloudwatch_metric_alarm" "tech_challenge_cpu_alarm_up" {
  alarm_name = "tech_challenge_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tech_challenge_web_app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.tech_challenge_policy_up.arn ]
}

# autoscaling_policy down
resource "aws_autoscaling_policy" "tech_challenge_web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.tech_challenge_web_app.name
}

resource "aws_cloudwatch_metric_alarm" "tech_challenge_web_cpu_alarm_down" {
  alarm_name = "tech_challenge_web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.tech_challenge_web_app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.tech_challenge_web_policy_down.arn ]
}
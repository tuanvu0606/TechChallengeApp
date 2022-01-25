
# ------------------------------------------------------- Launch Configuration ------------------------------------------------------------- #

resource "aws_launch_configuration" "tech_challenge_launch_configuration" {
  name_prefix = "tech-challenge-app-"

  image_id = "ami-07315f74f3fa6a5a3" # Canonical, Ubuntu, 18.04 LTS, amd64 bionic image build on 2021-11-29
  instance_type = "t2.micro"
  key_name = var.key_name

  security_groups = [ 
    var.security_group_id
  ]
  associate_public_ip_address = true

  user_data = "${base64encode(data.template_file.user_data_hw.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data_hw" {
  template = <<EOF
#!/bin/bash -xe

apt-get update -y
apt-get install unzip -y


mkdir /home/ubuntu/tech_challenge
cd /home/ubuntu/tech_challenge/
wget $(curl -s https://api.github.com/repos/servian/TechChallengeApp/releases/latest | awk -F\" '/browser_download_url.*linux64.zip/{print $(NF-1)}')
unzip *linux64.zip
cd ./dist
> conf.toml

cat <<EOT >> conf.toml
"DbUser" = "postgres"
"DbPassword" = "${var.database_password}"
"DbName" = "TechAppDB"
"DbPort" = "${var.database_port}"
"DbHost" = "${var.database_host}"
"ListenHost" = "0.0.0.0"
"ListenPort" = "3000"
EOT

./TechChallengeApp updatedb -s

nohup ./TechChallengeApp serve >/dev/null 2>&1 &

EOF
}
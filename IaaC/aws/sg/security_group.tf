resource "aws_security_group" "tfer--awseb-e-nga34njify-stack-AWSEBLoadBalancerSecurityGroup-tJkV3qWO3n2O_sg-056584eab19ba2c2a" {
  description = "Elastic Beanstalk created security group used when no ELB security groups are specified during ELB creation"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name = "awseb-e-nga34njify-stack-AWSEBLoadBalancerSecurityGroup-tJkV3qWO3n2O"

  tags = {
    Name                                = "python-env"
    "elasticbeanstalk:environment-id"   = "e-nga34njify"
    "elasticbeanstalk:environment-name" = "python-env"
  }

  tags_all = {
    Name                                = "python-env"
    "elasticbeanstalk:environment-id"   = "e-nga34njify"
    "elasticbeanstalk:environment-name" = "python-env"
  }

  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--awseb-e-nga34njify-stack-AWSEBSecurityGroup-srT1WGCR53gU_sg-0f25e88bd450df1be" {
  description = "SecurityGroup for ElasticBeanstalk environment."

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "80"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--awseb-e-nga34njify-stack-AWSEBLoadBalancerSecurityGroup-tJkV3qWO3n2O_sg-056584eab19ba2c2a_id}"]
    self            = "false"
    to_port         = "80"
  }

  name = "awseb-e-nga34njify-stack-AWSEBSecurityGroup-srT1WGCR53gU"

  tags = {
    Name                                = "python-env"
    "elasticbeanstalk:environment-id"   = "e-nga34njify"
    "elasticbeanstalk:environment-name" = "python-env"
  }

  tags_all = {
    Name                                = "python-env"
    "elasticbeanstalk:environment-id"   = "e-nga34njify"
    "elasticbeanstalk:environment-name" = "python-env"
  }

  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--default_sg-0b02998105dcfc1bf" {
  description = "default VPC security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "6379"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6379"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "6380"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6380"
  }

  egress {
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"]
    self            = "false"
    to_port         = "3306"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "tcp"
    self        = "false"
    to_port     = "65535"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "6379"
    protocol    = "tcp"
    self        = "true"
    to_port     = "6379"
  }

  ingress {
    description     = "Allow EC2 access"
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"]
    self            = "false"
    to_port         = "3306"
  }

  ingress {
    from_port = "6380"
    protocol  = "tcp"
    self      = "true"
    to_port   = "6380"
  }

  name = "default"

  tags = {
    cloud-nuke-first-seen = "2024-12-07T19:06:20Z"
  }

  tags_all = {
    cloud-nuke-first-seen = "2024-12-07T19:06:20Z"
  }

  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--launch-wizard-1_sg-0e8ffe4db09a0dbfe" {
  description = "launch-wizard-1 created 2024-11-20T20:51:25.739Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--default_sg-0b02998105dcfc1bf_id}"]
    self            = "false"
    to_port         = "3306"
  }

  name = "launch-wizard-1"

  tags = {
    cloud-nuke-first-seen = "2024-12-07T19:06:21Z"
  }

  tags_all = {
    cloud-nuke-first-seen = "2024-12-07T19:06:21Z"
  }

  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--launch-wizard-2_sg-0b22ad61b9e0f9367" {
  description = "launch-wizard-2 created 2024-12-03T19:30:07.778Z"
  name        = "launch-wizard-2"

  tags = {
    cloud-nuke-first-seen = "2024-12-07T19:06:21Z"
  }

  tags_all = {
    cloud-nuke-first-seen = "2024-12-07T19:06:21Z"
  }

  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--launch-wizard-3_sg-0a0cd914e36d17537" {
  description = "launch-wizard-3 created 2024-12-10T01:50:41.152Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "6379"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6379"
  }

  name   = "launch-wizard-3"
  vpc_id = "vpc-0a39a9d74cc90453c"
}

resource "aws_security_group" "tfer--launch-wizard-4_sg-0580b4caa740e983d" {
  description = "launch-wizard-4 created 2024-12-13T01:04:32.400Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "5000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "5000"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name   = "launch-wizard-4"
  vpc_id = "vpc-0a39a9d74cc90453c"
}

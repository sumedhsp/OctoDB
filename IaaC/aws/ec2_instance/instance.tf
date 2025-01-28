resource "aws_instance" "tfer--i-01704987a8d1e2771_cloudproject" {
  ami                         = "ami-036841078a4b68e14"
  associate_public_ip_address = "true"
  availability_zone           = "us-east-2a"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = "1"
    threads_per_core = "1"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  ipv6_address_count                   = "0"
  key_name                             = "ec2"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "true"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = "172.31.6.227"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"
  }

  security_groups   = ["launch-wizard-4"]
  source_dest_check = "true"
  subnet_id         = "subnet-09419ba3f1de0d04a"

  tags = {
    Name = "cloudproject"
  }

  tags_all = {
    Name = "cloudproject"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["sg-0580b4caa740e983d"]
}

resource "aws_instance" "tfer--i-026f838b29170580d_redis-cache-instance" {
  ami                         = "ami-0c80e2b6ccb9ad6d1"
  associate_public_ip_address = "true"
  availability_zone           = "us-east-2b"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = "1"
    threads_per_core = "1"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  ipv6_address_count                   = "0"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "true"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = "172.31.20.115"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"
  }

  security_groups   = ["launch-wizard-3"]
  source_dest_check = "true"
  subnet_id         = "subnet-0d2d79a3412bdf152"

  tags = {
    Name = "redis-cache-instance"
  }

  tags_all = {
    Name = "redis-cache-instance"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["sg-0a0cd914e36d17537"]
}

resource "aws_instance" "tfer--i-045e576d617ec1c1e_testEC2" {
  ami                         = "ami-0942ecd5d85baa812"
  associate_public_ip_address = "true"
  availability_zone           = "us-east-2a"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = "1"
    threads_per_core = "1"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = "EC2-ssm-role"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  ipv6_address_count                   = "0"
  key_name                             = "ec2"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "true"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = "172.31.6.23"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"
  }

  security_groups   = ["default", "launch-wizard-1", "launch-wizard-2"]
  source_dest_check = "true"
  subnet_id         = "subnet-09419ba3f1de0d04a"

  tags = {
    Name = "testEC2"
  }

  tags_all = {
    Name = "testEC2"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["sg-0b02998105dcfc1bf", "sg-0b22ad61b9e0f9367", "sg-0e8ffe4db09a0dbfe"]
}

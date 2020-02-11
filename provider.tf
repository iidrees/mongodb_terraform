# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
  access_key = ""
  secret_key = ""
  # shared_credentials_file = "~/.aws/creds"
}

# THE EC2 Instance
resource "aws_instance" "new_config" {
  ami           = "ami-0713f98de93617bb4"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1b"

  tags = {
    Name = var.instance_name
  }

  key_name = var.key_name
  security_groups = [var.security_groups]
  associate_public_ip_address = true


}

# The EBS Volumes being created
resource "aws_ebs_volume" "hdd_1" {
  availability_zone = "eu-west-1b"
  size              = 20

  tags = {
    Name = var.hdd1_name
  }
}

resource "aws_ebs_volume" "hdd_2" {
  availability_zone = "eu-west-1b"
  size              = 8

  tags = {
    Name = var.hdd2_name
  }
}

# The Volumes being attached to the Instance
resource "aws_volume_attachment" "ebs_hdd1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.hdd_1.id
  instance_id = aws_instance.new_config.id
}

resource "aws_volume_attachment" "ebs_hdd2" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.hdd_2.id
  instance_id = aws_instance.new_config.id
}

output "instance_ip" {
  description = "The public IP address"
  value = aws_instance.new_config.*.public_ip
}

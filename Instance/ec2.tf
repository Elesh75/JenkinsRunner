terraform { 
  required_version = "~> 1.0"    
  required_providers {
    aws = {
      version = "~> 3.0"
      source = "hashicorp/aws"
    }  
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "instance_names" {
type = list(string)
default = ["Sonar", "Nexus", "Ansible"]
}

resource "aws_key_pair" "key" {
  key_name   = "name of your choice"
  public_key = file("/path/to/your/public_key")
}


resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amzlinux2.id
  for_each      = toset(var.instance_names)
  key_name      = aws_key_pair.key.key_name

  tags = {
    Name = each.key
  }
}



data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
# Define the bootstrap script for Ansible instance
resource "aws_instance" "ansible_bootstrap" {
  count         = contains(var.instance_names, "Ansible") ? 1 : 0
  instance_type = "t2.medium"
  ami           = data.aws_ami.amzlinux2.id
  key_name      = aws_key_pair.key.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Ansible instance bootstrap script"
              # Add your Ansible bootstrap commands here
              sudo hostnamectl set-hostname ansible
              sudo adduser ansible
              echo "ansible  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
              sudo su - ansible
              sudo yum update -y
              sudo yum makecache  
              sudo amazon-linux-extras install ansible2  -y 
              sudo chown ansible:ansible -R  /etc/ansible/
              EOF

  tags = {
    Name = "Ansible"
  }
}
#*In this updated configuration:

#We've added a new resource block aws_instance.ansible_bootstrap to create the "Ansible" instance with specific user_data for bootstrapping.

#The count argument is used to conditionally create the "Ansible" instance based on whether "Ansible" is included in the var.instance_names list.

#The user_data attribute contains a Bash script for bootstrapping the "Ansible" instance. You can customize this script with your Ansible installation and setup steps.

#This configuration will create three EC2 instances with the specified names and specifications, and the "Ansible" instance will be bootstrapped with the provided user_data script. The other two instances ("Sonar" and "Nexus") will not have user_data specified and will be created with default configurations.*\
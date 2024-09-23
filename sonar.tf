 resource "aws_security_group" "newsonarqubeSG" {
  name        = "sonar-sg"
  description = "Allow inbound traffic for sonar"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 
#launch the ec2 instance and install website
resource "aws_instance" "sonar_instance" {
  ami                    = "ami-0c9f6749650d5c0e3"
  instance_type          = "t2.xlarge"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.newsonarqubeSG.id]
  key_name               = "terraform"
 # user_data            = file("sonar_script.sh")
 root_block_device {
    volume_size = 28  # Desired size in GB (e.g., increasing to 20 GB)
  }
  tags = {
    Name = "sonar server"
  }
}


# an empty resource block
resource "null_resource" "name1" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/Downloads/terraform.pem")
    host        = aws_instance.sonar_instance.public_ip
  }


  provisioner "file" {
    source      = "sonar_script.sh"
    destination = "/tmp/sonar_script.sh"
  }

 
  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/sonar_script.sh",
        "sh /tmp/sonar_script.sh"
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.sonar_instance]
}


output "website_url1" {
  value     = join ("", ["http://", aws_instance.sonar_instance.public_dns, ":", "9000"])
}


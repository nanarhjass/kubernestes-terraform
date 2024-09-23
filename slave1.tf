# Create a security group for the Jenkins slave
resource "aws_security_group" "jenkins_slave_sg" {
  name_prefix = "jenkins-slave-"
  description  = "Allow inbound traffic for Jenkins slave"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all IPs, adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-slave-sg"
  }
}

# Define the Jenkins slave instance
resource "aws_instance" "jenkins_slave" {
  ami           = "ami-0c6d358ee9e264ff1"  # Change to your desired Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "terraform"  # Replace with your SSH key pair name
  security_groups = [aws_security_group.jenkins_slave_sg.name]  # Corrected to use security group name

  tags = {
    Name = "jenkins-slave"
  }

}

resource "null_resource" "name5" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/Downloads/terraform.pem")
    host        = aws_instance.jenkins_slave.public_ip
  }


  provisioner "file" {
    source      = "slave.sh"
    destination = "/tmp/slave.sh"
  }

 
  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/slave.sh",
        "sh /tmp/slave.sh"
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.jenkins_slave]
}

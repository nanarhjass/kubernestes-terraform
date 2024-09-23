
#!/bin/bash
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk  # Install Java
sudo apt-get install -y maven
sudo apt-get install -y git
sudo useradd jenkins
sudo mkdir -p /home/jenkins/.ssh
sudo chmod 700 /home/jenkins/.ssh

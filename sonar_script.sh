#!/bin/bash
# Update and install required packages
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk wget unzip

# Download and install SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.2.77730.zip
unzip sonarqube-9.9.2.77730.zip
sudo mv sonarqube-9.9.2.77730 /opt/sonarqube

# Create a user for SonarQube
sudo useradd -r -s /bin/false sonar
sudo chown -R sonar:sonar /opt/sonarqube

# Create a systemd service for SonarQube
sudo bash -c 'cat > /etc/systemd/system/sonarqube.service << EOL
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOL'

# Start and enable the SonarQube service
sudo systemctl start sonarqube
sudo systemctl enable sonarqube



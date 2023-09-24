sudo yum update -y
sudo useradd sonar
sudo echo "sonar ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonarsudo hostnamectl set-hostname sonar
sudo su - sonar

# This will be run as SONAR User
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
cd /opt
sudo yum -y install unzip wget git
sudo yum install java-11-openjdk-devel
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
sudo unzip sonarqube-9.1.0.47736.zip
sudo mv sonarqube-9.1.0.47736 sonarqube
sudo rm -rf sonarqube-9.1.0.47736.zip        
sudo chown -R sonar:sonar /opt/sonarqube/
sudo chmod -R 775 /opt/sonarqube/
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh status  # OR yOU CAN SET-UP A SYSTEMD SERVICE to start,restart and stop sonarqube

# If your linux os fails to install java 11 which is an important prerequisite for sonar to run, do yhe following 
# sudo yum update
# sudo amazon-linux-extras list  (This command will display a list of available software collections, including OpenJDK versions.)

# Enable the desired OpenJDK version. For example, to enable OpenJDK 11, you can use the following command:
# sudo amazon-linux-extras enable java-openjdk11
# sudo yum install java-11-openjdk-devel

# List the installed Java packages to determine the version that is currently installed
# rpm -qa | grep java

# To delete any version of Java
# sudo yum remove (java version name)
sudo yum update -y
sudo yum install wget git nano unzip -y
useradd nexus
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
sudo su - nexus
cd /opt
sudo yum install java-11-openjdk-devel
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xvf nexus.tar.gz
sudo mv nexus-3* nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work
echo run_as_user="nexus" > /opt/nexus/bin/nexus.rc
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
echo "end of nexus installation"
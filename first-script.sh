#! /bin/bash
USERNAME="root"
PASSWORD=""
HOST=""
# SSH to remote Server  and Execute a Command [ Invoke the Script ] 
ssh -t ${USERNAME}@${HOST} << EOF
echo ${PASSWORD} | sudo -u root --stdin
apt update -y
apt upgrade -y
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0

echo "dotnet version is: $(dotnet -version)"
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0

apt install nginx

systemctl status nginx

systemctl enable nginx

echo "Nginx version is : $(nginx --version)"

EOF

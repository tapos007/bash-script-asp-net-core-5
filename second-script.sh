#! /bin/bash
USERNAME="root"
PASSWORD="tapos007A!ab"
HOST="137.184.151.3"
# SSH to remote Server  and Execute a Command [ Invoke the Script ] 
ssh -t ${USERNAME}@${HOST} << EOF

echo ${PASSWORD} | sudo -u root --stdin
useradd -m "tapos"
mkdir -p /home/tapos/all-application/firstApp
chown -R tapos /home/tapos/all-application/*
cd /home/tapos/all-application 
mkdir one
mkdir two
mkdir three

EOF
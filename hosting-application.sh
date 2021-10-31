#! /bin/bash
USERNAME="root"
PASSWORD=""
HOST=""
NEWUSER="eva"



# SSH to remote Server  and Execute a Command [ Invoke the Script ] 
ssh -t ${USERNAME}@${HOST} << EOF

echo ${PASSWORD} | sudo -u root --stdin

if id -u "$NEWUSER" >/dev/null 2>&1; then
    echo 'user exists'
else
    useradd -m $NEWUSER
fi


if [ ! -d "/home/$NEWUSER/all-application/firstApp" ] 
then
    mkdir -p /home/$NEWUSER/all-application/firstApp
    chown -R $NEWUSER /home/$NEWUSER/all-application/firstApp
fi

chown -R $NEWUSER /home/$NEWUSER/all-application/firstApp

EOF

cd TESTAPP/TESTAPP
dotnet publish --configuration Release
# rm bin/Release/net5.0/publish/appsettings*
scp bin/Release/net5.0/publish/* ${USERNAME}@${HOST}:/home/$NEWUSER/all-application/firstApp <<EOF
EOF

ssh -t ${USERNAME}@${HOST} << EOF


cat >/etc/systemd/system/kestrel-api.service <<"HERE"
[Unit]
Description=Example .NET Web API App running on Ubuntu

[Service]
WorkingDirectory=/home/$NEWUSER/all-application/firstApp
ExecStart=/usr/bin/dotnet /home/$NEWUSER/all-application/firstApp/TESTAPP.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=$NEWUSER
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
HERE

cat >/etc/nginx/conf.d/test.conf <<"NGC"
server {
    listen        90;
    server_name   localhost ;
    location / {
        proxy_pass         http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
NGC
systemctl restart nginx
systemctl enable kestrel-api.service
systemctl start kestrel-api.service
EOF



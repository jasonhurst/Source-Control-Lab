sudo yum -y install java-1.8.0-openjdk
sudo wget -q http://download.sonatype.com/nexus/3/nexus-3.16.1-02-unix.tar.gz
sudo tar xvzf nexus-3.16.1-02-unix.tar.gz -C /opt

echo "[Unit]
Description=nexus service
After=network.target
  
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus-3.16.1-02/bin/nexus start
ExecStop=/opt/nexus-3.16.1-02/bin/nexus stop
User=root
Restart=on-abort
  
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/nexus.service
sudo systemctl daemon-reload
sudo systemctl enable nexus.service
sudo systemctl start nexus.service

sudo yum -y install java-1.8.0-openjdk
sudo wget -q http://download.sonatype.com/nexus/3/nexus-3.16.1-02-unix.tar.gz
sudo tar xvzf nexus-3.16.0-02-unix.tar.gz -C /opt

echo "[Unit]
Description=nexus service
After=network.target
  
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus-3.13.0-01/bin/nexus start
ExecStop=/opt/nexus-3.13.0-01/bin/nexus stop
User=root
Restart=on-abort
  
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/nexus.service
sudo systemctl daemon-reload
sudo systemctl enable nexus.service
sudo systemctl start nexus.service
sudo cp /vagrant/hostnames/hosts /etc/hosts
sudo yum -y install unzip
sudo yum -y install zip
curl -s get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
sdk install groovy
groovy -Dgroovy.grape.report.downloads=true -Dgrape.config=grapeConfig.xml /vagrant/nexus-setup/addUpdateScript.groovy -u "admin" -p "admin123" -n "repo" -f "/vagrant/nexus-setup/repo.groovy" -h "http://127.0.0.1:8081"
curl -v -X POST -u admin:admin123 --header "Content-Type: text/plain" 'http://localhost:8081/service/rest/v1/script/repo/run'
for i in `ls /vagrant/artifacts`
    do 
        curl -v -u admin:admin123 --upload-file /vagrant/artifacts/$i 'http://localhost:8081/repository/install-artifacts/'
done;
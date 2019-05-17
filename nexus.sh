sudo cp /vagrant/hostnames/hosts /etc/hosts
if [[ "$(ping -c 1 ca.cie.unclass.mil > /dev/null ; echo $?)" == 0 ]];
then
    sudo curl -o /etc/pki/ca-trust/source/anchors/myCA.pem --insecure --user vagrant:vagrant scp://ca.cie.unclass.mil/home/vagrant/myCA.pem
    sudo update-ca-trust extract
fi
sudo yum -y install java-1.8.0-openjdk
sudo wget -q --user "${USERNAME}" --password "${PASSWORD}" "https://nexus.di2e.net/nexus/content/repositories/Private_AFDCGSCICD_Releases/content/repositories/Releases/CIE/nexus/nexus-3.13.0-01-unix.tar.gz"
sudo tar xvzf nexus-3.13.0-01-unix.tar.gz -C /opt

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
sudo yum install httpd
sudo sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
sudo yum install subversion mod_dav_svn
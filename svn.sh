sudo yum install -y httpd
sudo sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
sudo yum install -y subversion mod_dav_svn

echo '<Location /svn>
DAV svn
SVNParentPath /svn
AuthName "SVN Repos"
AuthType Basic
AuthUserFile /etc/svn/svn-auth
AuthzSVNAccessFile /svn/authz
Require valid-user
</Location>' | sudo tee -a  /etc/httpd/conf.modules.d/10-subversion.conf

sudo mkdir /svn
cd /svn
sudo svnadmin create repo1
sudo chown -R apache:apache repo1

sudo mkdir /etc/svn
sudo htpasswd -cmb /etc/svn/svn-auth svn-user password
sudo chown root:apache /etc/svn/svn-auth
sudo chmod 640 /etc/svn/svn-auth

sudo cp /svn/repo1/conf/authz /svn/authz

echo '[groups]
admin=svn-user

[/]
@admin=rw' | sudo tee /svn/authz

sudo systemctl enable httpd.service
sudo systemctl start httpd.service
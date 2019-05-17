#!/bin/bash
sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
wget -q https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
sudo rpm -i "GitLab-CE-11.10.4-ce.0.el7.x86_64.rpm"
sudo yum install -y gitlab-ce
sudo sed -i 's#external_url .*#external_url '"'"'http://gitlab.cie.unclass.mil'"'"'#' /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure
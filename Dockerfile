FROM cloudfoundry/cflinuxfs3
ADD post-configuration.sh ./
ADD tag ./
ADD switch-versions ./

RUN export PACKAGES="apt-transport-https debianutils ldap-utils mysql-client mysql-common perl perl-base perl-modules postgresql-client python-pip python-dev redis-tools sensible-utils sshpass ruby-dev" && \
apt-get -y update && \
apt-get -y install $PACKAGES && \
apt-get clean
 
RUN cp tag /etc/tag && \
cp switch-versions /usr/bin/switch-versions && \
bash post-configuration.sh


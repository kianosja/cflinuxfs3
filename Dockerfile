FROM cloudfoundry/cflinuxfs3
ADD post-configuration.sh ./
ADD tag ./

RUN export PACKAGES="apt-transport-https debianutils ldap-utils mysql-client mysql-common perl perl-base perl-modules postgresql-client python-pip python-dev redis-tools sensible-utils sshpass" && \
apt-get -y update && \
apt-get -y install $PACKAGES && \
apt-get clean
 
RUN bash post-configuration.sh
RUN cp tag /etc/tag

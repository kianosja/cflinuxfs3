#!/bin/bash

##
## Install cf-cli and dnsutils (per Kirk + Brandon)
##

echo ""
echo "Installing latest cf-cli"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get update
apt-get install -y cf-cli
apt-get install -y dnsutils
apt-get install -y gettext-base
apt-get install -y bind9utils
apt-get clean

##
## Install mc
##

echo ""
echo "Installing latest mc"
wget --no-check-certificate -q -O /usr/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc
chmod 755 /usr/bin/mc

##
## Install bosh
##

echo ""
echo "Installing bosh 5.4.0 as bosh-5.4.0 (was bosh)"
VER="5.4.0"
curl -k -s -Lo /usr/bin/bosh-5.4.0 https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh-5.4.0

echo "Installing bosh 5.5.1 as bosh-5.5.1 (was bosh-latest)"
VER="5.5.1"
curl -k -s -Lo /usr/bin/bosh-5.5.1 https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh-5.5.1

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry/bosh-cli/releases/latest | awk -F / '{ print $NF }' | cut -c 2-`
echo "Installing latest bosh version ($VER) as bosh (was bosh-test)"
curl -k -s -Lo /usr/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh
ln -s /usr/bin/bosh /usr/bin/bosh-latest

##
## Install govc
##

echo ""
echo "Installing govc 0.15.0 as govc-0.15.0"
VER="v0.15.0"
curl -k -s -Lo /usr/bin/govc.gz https://github.com/vmware/govmomi/releases/download/${VER}/govc_linux_amd64.gz
gzip -d /usr/bin/govc.gz
chmod 755 /usr/bin/govc
mv /usr/bin/govc /usr/bin/govc-0.15.0

# Now get the latest version for testing

#VER=`curl -L -k -s https://github.com/vmware/govmomi/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/vmware/govmomi/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest govc ($VER) as /usr/bin/govc (was govc-latest)" 
echo ""
curl -k -s -Lo /usr/bin/govc.gz https://github.com/vmware/govmomi/releases/download/${VER}/govc_linux_amd64.gz
gzip -d /usr/bin/govc.gz
chmod 755 /usr/bin/govc
ln -s /usr/bin/govc /usr/bin/govc-latest

##
## Install om-linux
##

echo ""
echo "Installing om-linux 0.42.0"
VER="0.42.0"
curl -k -s -Lo /usr/bin/om-linux-0.42.0 https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux
chmod 755 /usr/bin/om-linux-0.42.0

# Now install the latest
#
# Note binary name changed at 2.2.0 to om-linux-VER

#VER=`curl -L -k -s https://github.com/pivotal-cf/om/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/pivotal-cf/om/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest ($VER) om-linux as /usr/bin/om-linux (was om-linux-latest)"
echo ""
curl -k -s -Lo /usr/bin/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux-${VER}
chmod 755 /usr/bin/om-linux
ln -s /usr/bin/om-linux /usr/bin/om-linux-latest

echo ""
echo "Installing jq 1.5 as jq-1.5"
curl -k -s -Lo /usr/bin/jq-1.5 https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod 755 /usr/bin/jq-1.5

# Now install the latest

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/stedolan/jq/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest jq ($VER) as /usr/bin/jq (was jq-latest)"
echo ""
curl -k -s -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/${VER}/jq-linux64
chmod 755 /usr/bin/jq

echo ""
echo "Installing latest aws"
curl -k -s -Lo awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws
rm -r -f awscli-bundle

#
## Looks like the uaac client was removed - add it back in as we use it
#

echo "Installing uaac"
echo ""
gem install cf-uaac

#
## Install kubernetes packages
#

echo "Installing latest kubectl"
echo ""
curl -k -s -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod uog+rx /usr/bin/kubectl

#
## Install jfrog cli
#

echo "Installing jfrog cli"
echo ""
curl -fL https://getcli.jfrog.io | sh
mv jfrog /usr/bin/jfrog
chmod uog+rx /usr/bin/jfrog

#
### Install credhub-cli
#

echo "Installing latest credhub-cli"
echo ""
VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest | awk -F / '{ print $NF }'`
curl -k -s -Lo ./credhub.tar.gz https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${VER}/credhub-linux-${VER}.tgz
tar xvzf credhub.tar.gz 
mv credhub /usr/bin/credhub
rm credhub.tar.gz
chmod 755 /usr/bin/credhub


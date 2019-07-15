#!/bin/bash

echo ""
echo "Installing latest cf-cli"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get update
apt-get install cf-cli

apt-get clean

echo ""
echo "Installing latest mc"
wget --no-check-certificate -q -O /usr/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc
chmod 755 /usr/bin/mc

echo ""
echo "Installing bosh 5.4.0"
VER="5.4.0"
curl -k -s -Lo /usr/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh
#VER=`curl -k -s https://s3.amazonaws.com/bosh-cli-artifacts/cli-current-version`
#echo "Installing latest bosh version ($VER) as bosh-latest"
echo "Temporarily locking bosh-latest at 5.5.1 until latest issue with cli-current-version file is fixed"
VER="5.5.1"
curl -k -s -Lo /usr/bin/bosh-latest https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh-latest

echo ""
echo "Installing govc 0.15.0"
#VER=`curl -L -k -s https://github.com/vmware/govmomi/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER="v0.15.0"
curl -k -s -Lo /usr/bin/govc.gz https://github.com/vmware/govmomi/releases/download/${VER}/govc_linux_amd64.gz
gzip -d /usr/bin/govc.gz
chmod 755 /usr/bin/govc

# Now get the latest version for testing

VER=`curl -L -k -s https://github.com/vmware/govmomi/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
echo "Installing latest govc ($VER) as /usr/bin/govc-latest" 
echo ""
curl -k -s -Lo /tmp/govc.gz https://github.com/vmware/govmomi/releases/download/${VER}/govc_linux_amd64.gz
gzip -d /tmp/govc.gz
chmod 755 /tmp/govc
mv /tmp/govc /usr/bin/govc-latest

echo ""
echo "Installing om-linux 0.42.0"
#VER=`curl -L -k -s https://github.com/pivotal-cf/om/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER="0.42.0"
curl -k -s -Lo /usr/bin/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux
chmod 755 /usr/bin/om-linux

# Now install the latest
#
# Note binary name changed at 2.2.0 to om-linux-VER

VER=`curl -L -k -s https://github.com/pivotal-cf/om/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
echo "Installing latest ($VER) om-linux as om-linux-latest"
echo ""
curl -k -s -Lo /tmp/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux-${VER}
chmod 755 /tmp/om-linux
mv /tmp/om-linux /usr/bin/om-linux-latest

echo ""
echo "Installing jq-1.5"
curl -k -s -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod 755 /usr/bin/jq

# Now install the latest

echo "Installing latest jq as jq-latest"
echo ""
curl -k -s -Lo /usr/bin/jq-latest https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod 755 /usr/bin/jq-latest

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


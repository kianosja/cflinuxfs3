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
apt-get install -y python3-pip
apt-get clean

##
## Install skopeo
##

echo ""
echo "Installing latest skopeo"
. /etc/os-release
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | apt-key add -
apt update
apt -y install skopeo
apt clean

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
echo "Installing bosh 5.4.0"
VER="5.4.0"
curl -k -s -Lo /usr/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh

echo "Temporarily locking bosh-latest at 5.5.1 until latest issue with cli-current-version file is fixed"
VER="5.5.1"
curl -k -s -Lo /usr/bin/bosh-latest https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh-latest

echo "Installing latest bosh version ($VER) as bosh-test"
VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry/bosh-cli/releases/latest | awk -F / '{ print $NF }' | cut -c 2-`
curl -k -s -Lo /usr/bin/bosh-test https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh-test

##
## Install govc
##

echo ""
echo "Installing govc 0.15.0"
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

##
## Install om-linux
##

echo ""
echo "Installing om-linux 0.42.0"
#VER=`curl -L -k -s https://github.com/pivotal-cf/om/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER="0.42.0"
curl -k -s -Lo /usr/bin/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux
chmod 755 /usr/bin/om-linux

# Now install the latest
#
# Note binary name changed at 2.2.0 to om-linux-VER

#VER=`curl -L -k -s https://github.com/pivotal-cf/om/releases/latest | grep "<title>Release" | awk '{ print $2 }'`
VER=4.8.0
echo "Installing latest ($VER) om-linux as om-linux-latest"
echo ""
curl -k -s -Lo /tmp/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux-${VER}
chmod 755 /tmp/om-linux
mv /tmp/om-linux /usr/bin/om-linux-latest

#
## Install jq
# 

echo ""
echo "Installing jq-1.5"
curl -k -s -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod 755 /usr/bin/jq

# Now install the latest

echo "Installing latest jq as jq-latest"
echo ""
curl -k -s -Lo /usr/bin/jq-latest https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod 755 /usr/bin/jq-latest

#
## Install yq
#

echo 
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/mikefarah/yq/releases/latest | awk -F / '{ print $NF }' )
echo "Installing yq-${VER}"
echo

curl -k -s -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${VER}/yq_linux_amd64
chmod 755 /usr/bin/yq

#
## Install awscli
#

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

#echo "Installing latest kubectl"
#echo ""
#curl -k -s -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#chmod uog+rx /usr/bin/kubectl

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

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest credhub-cli ${VER}"
echo ""
curl -k -s -Lo ./credhub.tar.gz https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${VER}/credhub-linux-${VER}.tgz
tar xvzf credhub.tar.gz 
mv credhub /usr/bin/credhub
chmod 755 /usr/bin/credhub

#
### Install ytt
#

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/k14s/ytt/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest ytt (${VER}"
echo
curl -k -s -Lo /usr/bin/ytt https://github.com/k14s/ytt/releases/download/${VER}/ytt-linux-amd64
chmod 755 /usr/bin/ytt

#
### Install kapp
#

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/k14s/kapp/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest kapp (${VER}"
echo
curl -k -s -Lo /usr/bin/kapp https://github.com/k14s/kapp/releases/download/${VER}/kapp-linux-amd64
chmod 755 /usr/bin/kapp

#
### Install oc
#

echo "Installing latest oc"
echo
curl -k -s -Lo openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar xvzf openshift-client-linux.tar.gz
cp oc /usr/bin/oc
chmod 755 /usr/bin/oc
rm kubectl
rm README*

#
### Install skopeo
#

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/containers/skopeo/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest skopeo (${VER})"
echo

#
### Install hub
#

VER=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/github/hub/releases/latest | awk -F / '{ print $NF }'`
echo "Installing latest hub (${VER})"
echo 
curl -k -s -Lo /usr/bin/hub https://github.com/github/hub/releases/download/${VER}/hub-linux-amd64-${VER}.tgz
chmod 755 /usr/bin/hub


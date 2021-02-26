#!/bin/bash

##
## Install cf-cli and dnsutils (per Kirk + Brandon)
##

echo ""
echo "Installing latest cf-cli"
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get update
apt-get install -y cf7-cli
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

# Cut the v off this VER and manually add it where needed as the VER in the path has the v but not the VER in the filename
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry/bosh-cli/releases/latest | awk -F / '{ print $NF }' | cut -c 2- )
echo "Installing latest bosh version ($VER) as bosh"

curl -k -s -Lo /usr/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v${VER}/bosh-cli-${VER}-linux-amd64
chmod 755 /usr/bin/bosh

##
## Install govc
##

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/vmware/govmomi/releases/latest | awk -F / '{ print $NF }' )
echo "Installing govc (${VER}) as /usr/bin/govc" 

curl -k -s -Lo /tmp/govc.gz https://github.com/vmware/govmomi/releases/download/${VER}/govc_linux_amd64.gz

gzip -d /tmp/govc.gz
chmod 755 /tmp/govc
mv /tmp/govc /usr/bin/govc

##
## Install om-linux
##

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/pivotal-cf/om/releases/latest | awk -F / '{ print $NF }' )
echo "Installing om-linux (${VER}) as /usr/bin/om-linux"

curl -k -s -Lo /usr/bin/om-linux https://github.com/pivotal-cf/om/releases/download/${VER}/om-linux
chmod 755 /usr/bin/om-linux

#
## Install jq
# 

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/stedolan/jq/releases/latest | awk -F / '{ print $NF }' )
echo "Installing latest jq (${VER})as jq"

curl -k -s -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/${VER}/jq-linux64
chmod 755 /usr/bin/jq

#
## Install yq 4
#

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/mikefarah/yq/releases/latest | awk -F / '{ print $NF }' )
echo "Installing yq-${VER}"
echo

curl -k -s -Lo /usr/bin/yq4 https://github.com/mikefarah/yq/releases/download/${VER}/yq_linux_amd64
chmod 755 /usr/bin/yq4

#
## Install yq 3.4.1 
#

echo ""
VER="v3.4.1"
echo "Installing yq-${VER}"
echo

curl -k -s -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${VER}/yq_linux_amd64
chmod 755 /usr/bin/yq
ln -s /usr/bin/yq /usr/bin/yq3

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

echo ""
echo "Installing uaac via gem"

gem install cf-uaac

#
## Install jfrog cli
#

echo ""
echo "Installing jfrog cli"

curl -fL https://getcli.jfrog.io | sh
mv jfrog /usr/bin/jfrog
chmod uog+rx /usr/bin/jfrog

#
### Install credhub-cli
#

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest | awk -F / '{ print $NF }' )
echo "Installing latest credhub-cli ${VER}"

curl -k -s -Lo ./credhub.tar.gz https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${VER}/credhub-linux-${VER}.tgz
tar xvzf credhub.tar.gz 
mv credhub /usr/bin/credhub
chmod 755 /usr/bin/credhub

#
### Install ytt
#

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/k14s/ytt/releases/latest | awk -F / '{ print $NF }' )
echo "Installing latest ytt (${VER}"

curl -k -s -Lo /usr/bin/ytt https://github.com/k14s/ytt/releases/download/${VER}/ytt-linux-amd64
chmod 755 /usr/bin/ytt

#
### Install kapp
#

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/k14s/kapp/releases/latest | awk -F / '{ print $NF }' )
echo "Installing latest kapp (${VER}"

curl -k -s -Lo /usr/bin/kapp https://github.com/k14s/kapp/releases/download/${VER}/kapp-linux-amd64
chmod 755 /usr/bin/kapp

#
### Install hub
#

echo ""
VER=$( curl -Ls -o /dev/null -w %{url_effective} https://github.com/github/hub/releases/latest | awk -F / '{ print $NF }' | cut -c 2- )
echo "Installing latest hub (${VER})"
 
curl -k -s -Lo hub.tar.gz https://github.com/github/hub/releases/download/v${VER}/hub-linux-amd64-${VER}.tgz
tar xvzf hub.tar.gz
cp hub-linux-amd64-${VER_NO_V}/bin/hub /usr/bin/hub
chmod 755 /usr/bin/hub


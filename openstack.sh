#!/bin/bash
sudo su -
yum update -y

yum install -y python3

pip3 install gdown

gdown   --id   1cm90fhr4-haQ8TVG2CP-Tno1vozdEUAR    --output    rhel-7-server-additional-20180628.iso

gdown   --id   1ZVs-pksddhB88xZZnLzHmUoYSE1AFnaB   --output    rhel-7.5-server-updates-20180628.iso

gdown   --id   1xyPUYYVg-3mOPeu0t-9OoeJ5G3IOGpii    --output    RHEL7OSP-13.0-20180628.2-x86_64.iso

mkdir /iso1  /iso2  /iso3

mount  rhel-7.5-server-updates-20180628.iso  /iso1/

mount   rhel-7-server-additional-20180628.iso  /iso2/

mount  RHEL7OSP-13.0-20180628.2-x86_64.iso /iso3/

mkdir /software

cp -rvf /iso1/*  /software/

cp -rvf /iso2/*  /software/

cp -rvf /iso3/*  /software/

yum install createrepo  -y

createrepo -v /software/.

cat <<EOF > /etc/yum.repos.d/openstack.repo
[Openstack]
name=Openstack
baseurl=file:///software
gpgcheck=0
EOF

systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl stop firewalld
echo redhat | passwd  --stdin root
setenforce 0
hostnamectl set-hostname openstack.lw.com
vim /etc/hosts
yum install openstack-packstack -y

packstack --gen-answer-file=setup.txt

packstack  --answer-file=setup.txt

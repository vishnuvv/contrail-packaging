#! /bin/bash

# create shell scripts and put to bin
mkdir -p /opt/contrail/bin

cd /opt/contrail/contrail_installer_package
DEBIAN_FRONTEND=noninteractive dpkg -i binutils_2.24-5ubuntu3_amd64.deb make_3.81-8.2ubuntu3_amd64.deb libdpkg-perl_1.17.5ubuntu5.3_all.deb dpkg-dev_1.17.5ubuntu5.3_all.deb patch_2.7.1-4ubuntu1_amd64.deb

#DEBIAN_FRONTEND=noninteractive dpkg -i binutils_2.22-6ubuntu1.1_amd64.deb dpkg-dev_1.16.1.2ubuntu7.2_all.deb libdpkg-perl_1.16.1.2ubuntu7.2_all.deb make_3.81-8.1ubuntu1.1_amd64.deb patch_2.6.1-3_amd64.deb python-pip_1.0-1build1_all.deb python-pkg-resources_0.6.24-1ubuntu1_all.deb python-setuptools_0.6.24-1ubuntu1_all.deb

DEBIAN_FRONTEND=noninteractive dpkg -i python3-pycurl_7.19.3-0ubuntu3_amd64.deb python3-software-properties_0.92.37.1_all.deb software-properties-common_0.92.37.1_all.deb unattended-upgrades_0.82.1ubuntu2_all.deb python-colorama_0.2.5-0.1ubuntu1_all.deb python-distlib_0.1.8-1_all.deb python-html5lib_0.999-2_all.deb python-pkg-resources_3.3-1ubuntu1_all.deb python-setuptools_3.3-1ubuntu1_all.deb python-pip_1.5.4-1_all.deb

CONTRAIL_FAB=`ls contrail-fabric-utils_*.deb`
DEBIAN_FRONTEND=noninteractive dpkg -i $CONTRAIL_FAB libyaml-0-2_0.1.4-3ubuntu3_amd64.deb python-yaml_3.10-4build4_amd64.deb

cd /etc/apt/
# Allow unauthenticated pacakges to get installed.
# Do not over-write apt.conf. Instead just append what is necessary
# retaining other useful configurations such as http::proxy info.
apt_auth="APT::Get::AllowUnauthenticated \"true\";"
grep --quiet "$apt_auth" apt.conf
if [ "$?" != "0" ]; then
    echo "$apt_auth" >> apt.conf
fi

# install ecdsa and fabric
pip install --upgrade --no-deps --index-url='' /opt/contrail/python_packages/ecdsa-0.10.tar.gz
pip install --upgrade --no-deps --index-url='' /opt/contrail/python_packages/Fabric-1.7.0.tar.gz

#disabled sun-java-jre and sun-java-bin prompt during installation, add oracle license acceptance in debconf
echo 'sun-java6-plugin shared/accepted-sun-dlj-v1-1 boolean true' | /usr/bin/debconf-set-selections
echo 'sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true' | /usr/bin/debconf-set-selections
echo 'sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true' | /usr/bin/debconf-set-selections
echo 'debconf shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections
echo 'debconf shared/accepted-oracle-license-v1-1 seen true' | sudo debconf-set-selections

#sudo add-apt-repository -y cloud-archive:havana
#sudo add-apt-repository -y ppa:webupd8team/java
#sudo add-apt-repository -y ppa:nilarimogard/webupd8
#echo "deb http://www.apache.org/dist/cassandra/debian 11x main" |     sudo tee /etc/apt/sources.list.d/cassandra.list
#curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add
#apt-get update
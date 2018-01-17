#!/bin/bash

if [ "$#" -lt 1 ];then
	echo "Usage: $0 <install folder (absolute path)> <runtime version (default: v92)>  <release (default: R2017a)"
	echo "For sudoer recommend: $0 /opt"
	echo "For normal user recommend: $0 $HOME/app"
	exit 0
fi


INSTALL=$1
mkdir -p $INSTALL

if [ "$#" -lt 3 ]
then
VERSION=v92
RELEASE=R2017a
echo "Using default VERSION=$VERSION, RELEASE=$RELEASE"
else
VERSION=$2
RELEASE=$3
fi

TMP_DIR=/tmp/mcr
MCR_DIR=$INSTALL/mcr/$VERSION
mkdir -p $MCR_DIR $TMP_DIR
MCR_DIR=`realpath $MCR_DIR`


curl -L --retry 5 http://ssd.mathworks.com/supportfiles/downloads/${RELEASE}/deployment_files/${RELEASE}/installers/glnxa64/MCR_${RELEASE}_glnxa64_installer.zip > $TMP_DIR/install.zip
pushd $TMP_DIR
unzip install.zip
./install -mode silent -agreeToLicense yes -destinationFolder $MCR_DIR
popd

rm -rf $TMP_DIR





Bootstrap: shub
From: khanlab/neuroglia-core:v1.0.0


#cd <Singularity> folder
#rm ~/singularity/mp2rage_correction.img && singularity create  --size 4000 ~/singularity/mp2rage_correction.img && sudo singularity bootstrap ~/singularity/mp2rage_correction.img Singularity

#########
%setup
#########
mkdir $SINGULARITY_ROOTFS/src
cp -Rv . $SINGULARITY_ROOTFS/src

#cp install_mp2rage_correction_sudo.sh $SINGULARITY_ROOTFS
#ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

#########
%post
#########

cd /src

# checkout specific git release 
SINGULARITY_TAG=${SINGULARITY_BUILDDEF#Singularity.}
if [ ! "$SINGULARITY_TAG" = "Singularity" ]
then
  git checkout $SINGULARITY_TAG
fi
chmod a+x mcr/v93/mp2rage_correction/mp2rage_correction
chmod a+x mcr/v93/mp2rage_correction/run_mp2rage_correction.sh


#MCR
./install_scripts/05.install_MCR.sh /opt v93 R2017b

# default-jre
# 
#bash install_mp2rage_correction_sudo.sh /opt

#remove all install scripts
#rm install_mp2rage_correction_sudo.sh

#########
%environment

export MCRROOT=/opt/mcr/v93
export PATH=/src/mcr/v93/mp2rage_correction:$PATH



#told apt-get to skip any interactive steps
#export DEBIAN_FRONTEND=noninteractive
#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#mp2rage_correction
#export LC_ALL=C
#export PATH=/opt/mp2rage_correction:$PATH
#export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/v93/X11/app-defaults
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/MATLAB/MATLAB_Runtime/v93/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/opengl/lib/glnxa64

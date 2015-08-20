#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Please add correct version number; otherwise it won't install properly!"
    exit 
fi

#set -x
#version=$1
logf="install_arraydb_Version-$1.log"

echo "Now we start to dowload and install arraydb version $1"  > $HOME/$logf
echo "####################################################" >>   $HOME/$logf
echo " " 2>&1 | tee -a  $HOME/$logf

    tar zvxf arraydb-server-$1.tar.gz 2>&1 | tee -a $HOME/$logf

    tar zvxf arraydb-client-$1.tar.gz 2>&1 | tee -a  $HOME/$logf

# Install for client
cd arraydb-client-$1 
./install.sh

# Install for server
cd ../arraydb-server-$1  
./install.sh 

# Check if client and server installed correctly


export dir=$HOME/arraydb
if [[ -f $dir/bin/adbcli && -f $dir/bin/adbstart ]] 
then
    echo "" >> $HOME/$logf
    echo "#########################################################################" >> $HOME/$logf
    echo "Installation of Server and Client for arraydb_$1 were successfully done!"  >> $HOME/$logf
    echo "#########################################################################" >> $HOME/$logf 
fi

# Check if client and server installed correctly
export dir=$HOME/arraydb
echo " "  >> $HOME/$logf
echo "The files in each folers: " >> $HOME/$logf
echo "#########################################################################" >> $HOME/$logf
echo " "  >> $HOME/$logf

# 1 Check bin directory
echo "Files under $dir/bin: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/bin >> $HOME/$logf
echo " "  >> $HOME/$logf

echo "Files under $dir/doc: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/doc >> $HOME/$logf
echo " "  >> $HOME/$logf

echo "Files under $dir/conf: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/conf >> $HOME/$logf
echo " "  >> $HOME/$logf

echo "Files under $dir/data: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/data >> $HOME/$logf
echo " "  >> $HOME/$logf

echo "Files under $dir/include: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/include >> $HOME/$logf
echo " "  >> $HOME/$logf


echo "Files under $dir/lib: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/lib >> $HOME/$logf
echo " "  >> $HOME/$logf

echo "Files under $dir/log: " >> $HOME/$logf
echo "-------------------------------------" >> $HOME/$logf
ls $dir/log >> $HOME/$logf



#!/bin/bash
#: Authors: Andrew Zhang
#: Reviewers:
#: Date: 08/16/2015
#: Purpose: 	Automate the installation process for attayDB(jaguar version).
#: Test cases:
#    	Use case 1:
#	    -------------------------------------------------------------------
#
#: Component/Sub Comp:
#: Owned by:
#: Tag:
#: Dependencies: batch, github
#: Runnable: true
#: Arguments: none
#: Memory/Disk: 200MB/200MB
#: SUC:
#: Created for:
#: Retired for:
#: Test time: within 60 sec
#: History:
# 05/26/2015 AZHANG	First edition for array db
# Modified on: Aug. 15. 2015
# Scrit name: arraydbInstallj.sh

# Note:
# git clone https://github.com/exeray/jaguar.git"
#
#version=$1
logf="install_arraydb_Version-$1.log"

echo "Now we start to dowload and install arraydb version $1"  > $logf
echo "####################################################" >>   $logf
echo " " 2>&1 | tee -a  $logf

# Stop the process of adb is running

if  [ -d jaguar ]
    then
        echo "jaguar already existed. "
    else
        echo "Start to download from githut, it takes a few minutes..."
        git clone https://github.com/exeray/jaguar.gitecho
fi

# Client installation
cd  jaguar/client
tar zvxf jaguar-client-*.gz
cd jaguar-client-*
./install.sh 2>&1 | tee -a $logf

# Server installation
cd ../../../jaguar/server
tar zvxf jaguar-server-*.gz
cd jaguar-server-*
./install.sh 2>&1 | tee -a $logf

# Check if client and server installed correctly
export dir=$HOME/jaguar
if [[ -f $dir/bin/jcli && -f $dir/bin/jdbstart  ]]
then
    echo "" >> $logf
    echo "#########################################################################" >> $logf
    echo "Installation of Server and Client for arraydb_$1 were successfully done!"  >> $logf
    echo "#########################################################################" >> $logf
fi

exit
# comment of the cluster mode:
#sed -i '/#CLUSTER_MODE=yes/c\CLUSTER_MODE=yes' $HOME/jaguar/conf/jaguar.conf
sed -i 's/#CLUSTER_MODE=yes/CLUSTER_MODE=yes' $HOME/jaguar/conf/jaguar.conf


grep CLUSTER_MODE $HOME/jaguar/conf/jaguar.conf


exit

$HOME/arraydb/bin/adbstop 2>&1 | tee -a $logf
echo "Run adbstop... "  
sleep 5

$HOME/arraydb/bin/aobstop 2>&1 | tee -a $logf
echo "Run aobstop..."
sleep 5
# Download files
    rm arraydb-server-$1.tar.gz*
    wget https://github.com/exeray/jaguar/tree/master/server/jaguar-server-$1.tar.gz 2>&1 | tee -a  $logf

    rm arraydb-client-$1.tar.gz*
    wget https://github.com/exeray/jaguar/tree/master/server/jaguar-client-$1.tar.gz 2>&1 | tee -a  $logf

# Unzip
    rm -rf arraydb-server-$1i
    tar zvxf arraydb-server-$1.tar.gz 2>&1 | tee -a $logf

    rm -rf arraydb-client-$1
    tar zvxf arraydb-client-$1.tar.gz 2>&1 | tee -a  $logf

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
    echo "" >> $logf
    echo "#########################################################################" >> $logf
    echo "Installation of Server and Client for arraydb_$1 were successfully done!"  >> $logf
    echo "#########################################################################" >> $logf 
fi

# Check if client and server installed correctly
export dir=$HOME/arraydb
echo " "  >> $logf
echo "The files in each folers: " >> $logf
echo "#########################################################################" >> $logf
echo " "  >> $logf

# Check bin directory
echo "Files under $dir/bin: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/bin >> $logf
echo " "  >> $logf

echo "Files under $dir/doc: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/doc >> $logf
echo " "  >> $logf

echo "Files under $dir/conf: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/conf >> $logf
echo " "  >> $logf

echo "Files under $dir/data: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/data >> $logf
echo " "  >> $logf

echo "Files under $dir/include: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/include >> $logf
echo " "  >> $logf


echo "Files under $dir/lib: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/lib >> $logf
echo " "  >> $logf

echo "Files under $dir/log: " >> $logf
echo "-------------------------------------" >> $logf
ls $dir/log >> $logf

echo "Config arraydb.conf for \"CLUSTER_MODE=yes\""   >> $logf
sed -i '/#CLUSTER_MODE=yes/c\CLUSTER_MODE=yes' $HOME/arraydb/conf/arraydb.conf
grep CLUSTER_MODE $HOME/arraydb/conf/arrayd  
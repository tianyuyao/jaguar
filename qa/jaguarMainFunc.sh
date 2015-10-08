#!/bin/bash

# Main test to control the batch sql
# Script Name: jaguarMainFunc.sh
# Created by: Andrew Zhang
# Date: June 27, 2015
#

# Test 1:
# Create database and grant ussers; 

/bin/mkdir -p jaguarMainFunc.log
logf="jaguarMainFunc.log/jaguarFunc_sql_`date +%Y%m%d_%H%M%S`.log"
export PATH=$PATH:$HOME/jaguar/bin


echo "##### Main Function Test #####" 2>&1 | tee -a $logf
echo "##############################" 2>&1 | tee -a $logf

echo "Part 1: Now Running: Use jadmin to create user, db, etc" 2>&1 | tee -a $logf
echo "#########################################################" 2>&1 | tee -a $logf
echo " "  >> $logf

# Stop jdb is it's running:
#$HOME/jaguar/bin/jobstop 2>&1 | tee -a $logf
#echo "Stop jodbstop...wait for 5 second"
#sleep 5

$HOME/jaguar/bin/jdbstop 2>&1 | tee -a $logf
echo "Stop jdbstop...wait for 5 second"
sleep 5

# Test delete and create database
jadmin dropdb myJaguar1 2>&1 | tee -a $logf
echo "jadmin createdb myJaguar1"
jadmin createdb myJaguar1 2>&1 | tee -a $logf

jadmin createdb myJaguar2 2>&1 | tee -a $logf
echo "jadmin createuser user_myJaguar1:password"
jadmin createuser user_myJaguar1:password 2>&1 | tee -a $logf
jadmin createuser user_myJaguar2:password 2>&1 | tee -a $logf

echo "jadmin dropdb myJaguar2"
jadmin dropdb myJaguar2 2>&1 | tee -a $logf
jadmin dropuser user_myJaguar2 2>&1 | tee -a $logf

# Test create users for jbench test
echo "jadmin createuser test:test"
jadmin createuser test:test 2>&1 | tee -a $logf
jadmin listusers 2>&1 | tee -a $logf


# Start arrary db:
#$HOME/jaguar/bin/jobstart 2>&1 | tee -a $logf
#echo "Start jobserver, wait for 5 sec..."
#sleep 5

echo "start jdbserv ..."
#$HOME/jaguar/bin/jdbstart 2>&1 | tee -a $logf
$HOME/jaguar/bin/jdbstart
echo "start jdbserv, wait for 5 sec."
sleep 5

echo "Now run aydbFunc.sql:" 2>&1 | tee -a $logf
echo "#####################" 2>&1 | tee -a $logf

ps -ef |grep jdbserv 2>&1 | tee -a $logf
#ps -ef |grep jobserv 2>&1 | tee -a $logf


echo "" 2>&1 | tee -a $logf
echo "Now run aydbFunc.sql: " 2>&1 | tee -a $logf
echo "#####################" 2>&1 | tee -a $logf 


port=`grep port $HOME/jaguar/conf/server.conf |grep -v oport |grep -v '#' | awk -F= '{print $2}'`
jag -u user_myJaguar1 -p password -d myJaguar1  -h 127.0.0.1:$port  -v yes < jaguarFunc.sql 2>&1 | tee -a $logf


# Basic Data Query performance Test
#exit
# We will update the rest of the test soon...
echo "" 2>&1 | tee -a $logf
echo "##################################################################" 2>&1 | tee -a $logf
echo "Basic concurrent request and load performance test by \"jbench\" "  2>&1 | tee -a $logf
echo "##################################################################" 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf

echo "1) Generate 1000 numbers randomly and insert record to jbench table in the Server" 2>&1 | tee -a $logf
echo "###################################################################################" 2>&1 | tee -a $logf
echo "jbench -r \"1000:0.0\" -h 127.0.0.1:$port -c 4  " 2>&1 | tee -a $logf
jbench -r "1000:0.0" -h 127.0.0.1:$port  -c 4 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf


echo "2) Query server 1000 times"   2>&1 | tee -a $logf
echo "#############################" 2>&1 | tee -a $logf
echo " jbench -r \"0:0:1000\" -h 127.0.0.1:$port "     2>&1 | tee -a $logf
jbench -r "0:0:1000" -h 127.0.0.1:$port	 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf


echo "3) 100% users data inset concurrently " 2>&1 | tee -a $logf
echo "#####################################" 2>&1 | tee -a $logf
echo "jbench -r \"1000:0:0\" -h 127.0.0.1:$port -c 4" 2>&1 | tee -a $logf
jbench -r "1000:0:0" -h 127.0.0.1:$port  -c 4 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf

echo "4) 100% users data query concurrently " 2>&1 | tee -a $logf
echo "#####################################" 2>&1 | tee -a $logf
echo "jbench -r \"0:0:1000\" -h 127.0.0.1:$port -c 4" 2>&1 | tee -a $logf
jbench -r "0:0:1000" -h 127.0.0.1:$port  -c 4 2>&1 | tee -a $logf

echo "" 2>&1 | tee -a $logf
echo "5) 20% users data insert and 80% user data selection concurrently " 2>&1 | tee -a $logf
echo "###############################################################" 2>&1 | tee -a $logf
echo "jbench -r \"200:0:800\" -h 127.0.0.1:$port -c 4 " 2>&1 | tee -a $logf
jbench -r "200:0:800" -h 127.0.0.1:$port  -c 4 2>&1 | tee -a $logf

#$HOME/jaguar/bin/jdbstop 2>&1 | tee -a $logf
# More tests based on the https://github.com/exeray/jaguar/blob/master/JaguarProdIntro.pdf



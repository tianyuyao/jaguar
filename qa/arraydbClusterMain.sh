#!/bin/bash

# Main test to control the batch sql
# Script Name: arraydbClusterMain.sh
# Created by: Andrew Zhang
# Date: June 27, 2015
# Modified: 07/27/2015, Andrew Zhang
#
# Test 1:
# Login as root to create database and ussers;

logf="arraydbFunc_sql_`date +%Y%m%d_%H%M%S`.log"

echo "##### Main Function Test #####" 2>&1 | tee -a $logf
echo "##############################" 2>&1 | tee -a $logf

echo "Part 1: Now Running: Use adbadmin to create user, db, etc" 2>&1 | tee -a $logf
echo "#########################################################" 2>&1 | tee -a $logf
echo " "  >> $logf

# Stop adb is it's running:
$HOME/arraydb/bin/adbstop 2>&1 | tee -a $logf
echo "Stop adbstop...wait for 5 second"
sleep 5

$HOME/arraydb/bin/adbstop 2>&1 | tee -a $logf
echo "Stop adbstop...wait for 5 second"
sleep 5

# Test delete and create database
adbadmin dropdb myArrayDB1 2>&1 | tee -a $logf
adbadmin dropdb myArrayDB2 2>&1 | tee -a $logf

echo "Db droped."
sleep 2
adbadmin createdb myArrayDB1 2>&1 | tee -a $logf
adbadmin createdb myArrayDB2 2>&1 | tee -a $logf

# Test delete and create users
adbadmin dropuser user_myArrayDB1 2>&1 | tee -a $logf
adbadmin dropuser user_myArrayDB2 2>&1 | tee -a $logf

adbadmin createuser user_myArrayDB1:password 2>&1 | tee -a $logf
adbadmin createuser user_myArrayDB2:password 2>&1 | tee -a $logf

adbadmin createuser test:test 2>&1 | tee -a $logf

adbadmin listusers 2>&1 | tee -a $logf

# Start arrary db:
$HOME/arraydb/bin/aobstart 2>&1 | tee -a $logf
echo "Start aobserver, wait for 5 sec..."
sleep 5

$HOME/arraydb/bin/adbstart 2>&1 | tee -a $logf
echo "start adbserv, wait for 5 sec."
sleep 5

echo "Now run aydbFunc.sql:" 2>&1 | tee -a $logf
echo "#####################" 2>&1 | tee -a $logf 

ps -ef |grep adbserv 2>&1 | tee -a $logf
ps -ef |grep aobserv 2>&1 | tee -a $logf

adb -u user_myArrayDB1 -p password -d myArrayDB1  -h 127.0.0.1:8888 -v yes < arraydbFunc.sql 2>&1 | tee -a $logf

exit


# Basic Data Query performance Test

echo "" 2>&1 | tee -a $logf
echo "##################################################################" 2>&1 | tee -a $logf
echo "Basic concurrent request and load performance test by \"abench\" "  2>&1 | tee -a $logf
echo "##################################################################" 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf

echo "1) Generate 10000 numbers randomly and insert record to abench table in the Server" 2>&1 | tee -a $logf
echo "###################################################################################" 2>&1 | tee -a $logf
echo "abench -r \"10000:0.0\" -c 4  " 2>&1 | tee -a $logf
abench -r "10000:0.0" -c 4 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf


echo "2) Query server 10000 times"   2>&1 | tee -a $logf
echo "#############################" 2>&1 | tee -a $logf
echo " abench -r \"0:0:10000\" "     2>&1 | tee -a $logf
abench -r "0:0:10000"				 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf


echo "3) 100% users data inset concurrently " 2>&1 | tee -a $logf
echo "#####################################" 2>&1 | tee -a $logf
echo "abench -r \"10000:0:0\" -c 4" 2>&1 | tee -a $logf
abench -r "10000:0:0" -c 4 2>&1 | tee -a $logf
echo "" 2>&1 | tee -a $logf

echo "4) 100% users data query concurrently " 2>&1 | tee -a $logf
echo "#####################################" 2>&1 | tee -a $logf
echo "abench -r \"0:0:10000\" -c 4" 2>&1 | tee -a $logf
abench -r "0:0:10000" -c 4 2>&1 | tee -a $logf

echo "" 2>&1 | tee -a $logf
echo "5) 20% users data insert and 80% user data selection concurrently " 2>&1 | tee -a $logf
echo "###############################################################" 2>&1 | tee -a $logf
echo "abench -r \"2000:0:8000\" -c 4 " 2>&1 | tee -a $logf
abench -r "2000:0:8000" -c 4 2>&1 | tee -a $logf


# More tests based on the https://github.com/exeray/arraydb/blob/master/ArrayDBProdIntro.pdf



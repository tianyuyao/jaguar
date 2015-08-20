#!/bin/bash

# Main test to control the batch sql

# Test 2: Performance test

logf="arraydbPerf_sql_`date +%Y%m%d_%H%M%S`.log"


echo "##### Main Performance Test  #####" 2>&1 | tee -a $logf  
echo "Now Running: Use adbadmin to create user, db, etc" 2>&1 | tee -a $logf
echo "#########################" 2>&1 | tee -a $logf
echo " " 2>&1 | tee -a $logf



# Stop adb is it's running:
$HOME/arraydb/bin/adbstop 2>&1 | tee -a $logf
echo "Stop adbstop...wait for 5 second"
sleep 5

$HOME/arraydb/bin/adbstop 2>&1 | tee -a $logf
echo "Stop adbstop...wait for 5 second"
sleep 5


# Performance test:

adbadmin dropdb myArrayDB_azhang 2>&1 | tee -a $logf
adbadmin createuser user_azhang:password 2>&1 | tee -a $logf
adbadmin createdb myArrayDB_azhang 2>&1 | tee -a $logf


# Start arrary db:
$HOME/arraydb/bin/aobstart 2>&1 | tee -a $logf
echo "Start aobserver, wait for 5 sec..."
sleep 5

$HOME/arraydb/bin/adbstart 2>&1 | tee -a $logf
echo "start adbserv, wait for 5 sec."
sleep 5


echo "Performance test start, it might take up to a few hours..." 2>&1 | tee -a $logf
adb -u user_azhang -p password -d myArrayDB_azhang -h 127.0.0.1:8888 -v yes < arraydbPerf.sql 2>&1 | tee -a  $logf




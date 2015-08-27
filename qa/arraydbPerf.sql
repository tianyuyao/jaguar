# Automation for ArrayDB Test Case for performance test
# File Name: arraydbProf.sql 
# Create on: 06/11/2015
# Updated on: 06/14/2015
# Created by: Andrew Zhang
# 
# Pre-condition: Run the "arraydbMainFunc.sh" first.
# Purpose: 
# 1. Run iperformance test: load and create index with large data set.


## Command Line:
# adb -u user_azhang -p password -d myArrayDB_azhang -h 127.0.0.1:8888 -v yes < arraydbProf.sql > testBatchSQL.log
#

# Test 1.  Create tables
###################
drop table table1_azhang;
drop table table2_azhang;
drop table table3_azhang;

create table table1_azhang ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table table2_azhang ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table table3_azhang ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );

show tables;

# Test 2: Load a 10k row text file:
###########################################
load file $HOME/arrardbTestHome/10kLine.txt into table1_azhang format H;

select * from table1_azhang where uid = FQfbHNKNcgPORWNs;
select count(*) from table1_azhang;
select * from table1_azhang where v2=c3BRPlD1BsNsnAT3;


# Test 3: load 3 million row text file:
############################################

load file $HOME/arrardbTestHome/3M-1.txt into table2_azhang format H;

select * from table2_azhang where v2=x8GjH1NIlSYoWBUB;

select * from table2_azhang where v3=Apple41234567890;

##############
# Test join
##############
select * join (table1_azhang, table2_azhang) limit 2;
 

# Test creating index:
######################
create index index1  on table2_azhang(v3 char(16));
select * from table2_azhang use index(index1) where v3=Apple41234567890;
select * from table2_azhang  where v3=Apple41234567890;



####################################
# Create index and search by values
#####################################

load file $HOME/arrardbTestHome/10M-1.txt into table3_azhang format H;
select count(*) from  table3_azhang;
create index index2  on table3_azhang(v3 char(16));

select * from table3_azhang use index(index2) where v3=Apple01234567890;
select * from table3_azhang where v3=Apple01234567890;

######################################
# Search by index for the second time:
######################################
select * from table3_azhang use index(index2) where v3=Apple01234567890;

quit;



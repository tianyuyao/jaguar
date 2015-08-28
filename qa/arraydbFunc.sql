# Automation1 for ArrayDB Acceptance Test 
# Create on: 06/11/2015
# Updated on: 08/28/2015
# Created by: Andrew Zhang
# Purpose: Minimum test cases covers all the basic SQL syntax for arraydb.
#
# Command Line:
#  adb -u user_myArrayDB1 -p password -d myArrayDB1 -h 127.0.0.1:8888 -v yes < mycommands.sql > testBatchSQL.log
# Updated on: 08/s4/2015

# Test 1-1. Create tables
#########################
drop table arraydbFunc1 ;
drop table arraydbFunc2 ;
drop table arraydbFunc3 ;
drop table arraydbFunc4:
drop table arraydbFunc5;

create table arraydbFunc1  ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table arraydbFunc2  ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table arraydbFunc3  ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table arraydbFunc4  ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );
create table arraydbFunc5  ( key: uid char(32), value: v1 char(16), v2 char(16), v3 char(16) );

show tables;

# Test 1-2.  Delete table
###########################
desc arraydbFunc1;
show tables;
drop table arraydbFunc1;
show tables;

# Test 1-3. Check table schema
desc arraydbFunc1;

# Test 2-1: Load a 10k row text file in foramt H:
#################################################
load file $HOME/jaguarTestData/10kLine.txt into arraydbFunc2 format H;

# Test 2-2: Basic query 
##########################
select * from arraydbFunc2 where uid = FQfbHNKNcgPORWNs;
select * from arraydbFunc2 where v2=c3BRPlD1BsNsnAT3;

# Test 3: Insert data and select
#################################
select count(*) from arraydbFunc2;
insert into arraydbFunc2 (uid, v1, v2, v3) values (4, 'xxx', 'yyyy', 'zzz');
select count(*) from arraydbFunc2;
## Expect 10006 rows found

select * from arraydbFunc2 where v2=yyyy;
select * from arraydbFunc2 where v3=zzz;
select * from arraydbFunc2 where uid=4;

######################
# Test 4: Update data
######################

update arraydbFunc2 set v2='v2 is From yyyy to y2y2y2' where uid=4;
select * from arraydbFunc2 where  uid=4;

create table user ( key: fname char(10), lname char(12), value: age int(3), address char(128) );
insert into user ( fname, lname, age, address) values ( 'Larry', 'Patterson', 40, 'lpat@yahoo.com' );
insert into user ( fname, lname, age, address) values ( 'Andrew', 'Zhang', 500, 'agz1117@hotmail.com' );
insert into user ( fname, lname, age, address) values ( 'Jason', 'Zhang', 18, 'agz1117@hotmail.com' );

update user set address = jason.zhang@gmail.com where  fname = Jason and lname = Zhang;
select * from user;

update user set age  = 50  where  fname = Andrew and lname = Zhang;
select * from user;

update user set fname  = Andy where  fname = Andrew and lname = Zhang;
select * from user;
select count(*) from user;

########################################
# Test 5-1: Delete data from table user
#######################################
delete from user;
select count(*) from user;
select * from user;

show tables;
drop table user;
show tables;

#################################################
# Test 5-2: Delete data from table arraydbFunc2
#################################################
select count(*) from arraydbFunc2
delete from arraydbFunc2 
select count(*) from arraydbFunc2

##############
# Test join
##############
insert into arraydbFunc3 (uid, v1, v2, v3) values (1, 't3_v1_L1', 't3_v2_L1', 't3_v3_L1');
insert into arraydbFunc3 (uid, v1, v2, v3) values (2, 't3_v1_L2', 't3_v2_L2', 't3_v3_L2');
insert into arraydbFunc3 (uid, v1, v2, v3) values (3, 't3_v1_L3', 't3_v2_L3', 't3_v3_L3');


insert into arraydbFunc4 (uid, v1, v2, v3) values (1, 't4_v1_L1', 't4_v2_L1', 't4_v3_L1');
insert into arraydbFunc4 (uid, v1, v2, v3) values (2, 't4_v1_L2', 't4_v2_L2', 't4_v3_L2');
insert into arraydbFunc4 (uid, v1, v2, v3) values (3, 't4_v1_L3', 't4_v2_L3', 't4_v3_L3');


insert into arraydbFunc5 (uid, v1, v2, v3) values (1, 't5_v1_L1', 't5_v2_L1', 't5_v3_L1');
insert into arraydbFunc5 (uid, v1, v2, v3) values (2, 't5_v1_L2', 't5_v2_L2', 't5_v3_L2');
insert into arraydbFunc5 (uid, v1, v2, v3) values (3, 't5_v1_L3', 't5_v2_L3', 't5_v3_L3');


select * from arraydbFunc3;
select * from arraydbFunc4;
select * from arraydbFunc5;

select * join (arraydbFunc3, arraydbFunc4, arraydbFunc5) ;


quit;



#!/bin/bash

host="-h localhost"
db="vegbien"
user="bien"
schema="analytical_db_dev"
table="gnrs"
pkcol="poldiv_full"
#pkcol="id"
quiet=""
noexit=""

source "zz_functions.sh"
# Also load main function script if required by function being tested 
source "../includes/functions.sh"

echo "Testing function check_pk:"
echo "  host:	$host"
echo "  db:	$db"
echo "  user:	$user"
echo "  sch:	$schema"
echo "  tbl:	$table"
echo "  col:	$pkcol"
echo "  q:	$quiet"
echo "  n:	$noexit"
echo ""

check_pk $quiet $noexit $host -u $user -d $db -s $schema -t $table -c $pkcol

echo ""
echo "Continuing..."
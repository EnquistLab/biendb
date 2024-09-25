#!/bin/bash

#########################################################################
# Purpose:	Back up table
#
# Backs up one tables from a single schema in a single database
#
# Notes: 
#	1. Must be restored using pg_restore utility.
#	2. Table MUST be owned by $user
#########################################################################

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads local parameters only if called by master script.
# Otherwise loads all parameters, functions and options
######################################################

# Get local working directory
DIR_LOCAL="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_LOCAL" ]]; then DIR_LOCAL="$PWD"; fi

# $local = name of this file
# $local_basename = name of this file minus ='.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
# if local data directory needed
local=`basename "${BASH_SOURCE[0]}"`
local_basename="${local/.sh/}"

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
fi

# Set custom process name & mail message header
pname_custom="Backup table"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

#########################################################################
# Local parameters
# Will over-ride existing paramaters from global and local params files.
# Comment out to use existing parameters.
#########################################################################

# Database
db="vegbien"

# Schema
# For schema public, either "public" or "" works
sch="analytical_db_dev"
#sch="analytical_db_test"

# Table to back up
tbl="view_full_occurrence_individual_dev"

# Append date+time to dumpfile name? (t|f)
use_date="t"

# Dumpfile extension
ext="pgd"

# Base name of dumpfile
dumpfile_basename="vfoi_dev_analytical_db_dev_BIEN4.2"
dumpfile_basename="vfoi_dev_analytical_db_test_BIEN4.2"
	
#########################################################################
# Set schema & dumpfile name
#########################################################################

if [ "$sch" == "" ]; then sch="public"; fi

datetime=""
if [ "$use_date" == "t" ]; then datetime="_$(date +%Y%m%d_%H%M%S)"; fi 
if [ ! "$ext" == "" ]; then ext="."$ext; fi
dumpfile_name="${dumpfile_basename}${datetime}${ext}"
dumpfile=$data_dir_local"/"$dumpfile_name

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Backup type:		Table only
	Database to backup:	$db$db_version_disp
	Schema:			$sch
	Table to backup:	$tbl
	User:			$user
	Dumpfile name: 		$dumpfile_name
	Dumpfile path: 		$data_dir_local/
	EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e ""
echoi $e "Executing module '$local_basename'"

# Check db exists
if ! psql -lqt | cut -d \| -f 1 | grep -qw $db; then
	echo; echo "ERROR: Required database '$db' missing"; echo 
	exit 1
fi

# Check schema exists
sch_exists=$(exists_schema_psql -d $db -u $user -s $sch )
if [[ $sch != 'public' && $sch_exists == "f" ]]; then
	echo "ERROR: schema '$sch' doesn't exist!"
	exit 1
fi

# Check schema exists
tbl_exists=$( exists_table_psql -u $user -d $db -s $sch -t $tbl )
if [[ $tbl_exists == "f" ]]; then
	echo "ERROR: table '$tbl' doesn't exist!"
	exit 1
fi

# Dump schema from source database
# Option -Fc forces custom pg_dump format, which is already compressed
# Must be restored using pg_restore utility
echoi $e -n "-- Creating dumpfile of schema '$sch' in db '$db'..."
schtbl="${sch}.${tbl}"
#echo ""; echo "Cmd: pg_dump -U ${user} -Fc --table ${schtbl} ${db} > ${dumpfile}"
pg_dump -U $user -Fc --table $schtbl $db > $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Echo final instructions, if running standalone
######################################################

if [ -z ${master+x} ]; then

msg_next_steps="$(cat <<-EOF

Dumpfile '$dumpfile_name' created. To restore, run the following command:

pg_restore -U [username] -d [database_to_restore_to] -n [schema_to_restore] $dumpfile_name

'database_to_restore_to' does not need to be the same as original db. 'schema_to_restore' must be the same, unless also edit dumpfile to change schema references.

EOF
)"
echoi $e "$msg_next_steps"

fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



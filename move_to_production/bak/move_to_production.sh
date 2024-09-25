#!/bin/bash

#########################################################################
# Purpose:	Simultaneously moves private and public analytical databases  
# 	to production. Note that existing production schema is renamed from 
# 	"production_schema_name" to "production_schema_name_bak". This can be
#	deleted manually once new production schema has been validated.
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
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

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

######################################################
# Set confirmation message and echo
######################################################



#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Verify all required databases and schemas
######################################################

dbs="
$db_private
$db_public
"
for db in $dbs; do
	if ! psql -lqt | cut -d \| -f 1 | grep -qw $db; then
		#echo; echo "ERROR: Database '$db' missing"; echo 
		echo "ERROR: Database '$db' missing"; echo 
		exit 1
	fi
done

dbschs="
$db_private,$dev_schema_adb_private
$db_private,$prod_schema_adb_private
$db_private,$dev_schema_users
$db_private,$prod_schema_users
$db_public,$dev_schema_adb_public
$db_private,$prod_schema_adb_public
"

for dbsch in $dbschs; do
	dbsch2=${dbsch//pattern/string}
	dbsch_arr=($dbsch2)
	db=${dbsch_arr[0]}
	sch=${dbsch_arr[1]}

	sch_exists=$(exists_schema_psql -u $user -d $db -s $sch)
	if [[ $sch_exists == "f" ]]; then
		echo "ERROR: Schema '$sch' doesn't exist in db '$db'!"
		exit 1
	fi
done

######################################################
# Replace private data schema
######################################################

echoi $e "- Replacing private schema \"$prod_schema_adb_private\" in database \"$db_private\":"


version=`psql -X -A -d $db_private -U $user -t -c "SELECT MAX(bien_metadata_id) FROM bien_metadata"`
prod_schema_bak=$prod_schema_adb_private"_"$version

echoi $e -n "-- Replacing schema..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -v prod_schema=$prod_schema_adb_private -v prod_schema_bak=$prod_schema_bak -f $DIR_LOCAL/sql/move_to_production.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Resetting version date..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_private -f $DIR_LOCAL/sql/reset_release_date.sql
source "$DIR/includes/check_status.sh"

######################################################
# Replace users schema
######################################################

prod_schema_bak=$prod_schema_users"_bak"

echoi -n $e "-- Replacing schema \"$prod_schema_users\" in database \"$db_private\":"
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_users -v prod_schema=$prod_schema_users -v prod_schema_bak=$prod_schema_bak -f $DIR_LOCAL/sql/move_to_production.sql
source "$DIR/includes/check_status.sh"

######################################################
# Replace public data schema
######################################################

echoi $e "- Replacing public schema \"$prod_schema_adb_private\" in database \"$db_public\":"

prod_schema_bak=$prod_schema_adb_public"_bak"

echoi $e -n "-- Replacing schema..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_public -v prod_schema=$prod_schema_adb_public -v prod_schema_bak=$prod_schema_bak -f $DIR_LOCAL/sql/move_to_production.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Resetting version date..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -f $DIR_LOCAL/sql/reset_release_date.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



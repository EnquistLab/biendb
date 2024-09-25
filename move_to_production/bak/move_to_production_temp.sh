#!/bin/bash

#########################################################################
# Purpose:	Simultaneously moves private and public analytical databases  
# 	to production. Note that existing production schema is renamed from 
# 	"production_schema_name" to "production_schema_name_bak". This can be
#	deleted manually once new production schema has been validated.
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

# Set parent directory if running independently & suppress main message
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

######################################################
# Verify all databases and schemas
######################################################

dbs="
$db_private
$db_public
"
for db in $dbs; do
	if ! psql -lqt | cut -d \| -f 1 | grep -qw $db; then
		echo; echo "ERROR: Database '$db' missing"; echo 
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

######################################################
# Get current database version numbers 
######################################################

ver=`psql -X -A -d $db_private -U $user -t -c "SELECT db_version FROM $prod_schema_adb_private.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM $prod_schema_adb_private.bien_metadata)"`
ver2=${ver//./_}
ver_priv="_"$ver2	# Private db

ver=`psql -X -A -d $db_private -U $user -t -c "SELECT db_version FROM $prod_schema_adb_private.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM $prod_schema_adb_private.bien_metadata)"`
ver2=${ver//./_}
ver_pub="_"$ver2		# Public db

######################################################
# Custom confirmation message. 
# Will only be displayed if running standalone 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will rename schemas as follows: 
	
	$db_private.$prod_schema_adb_private --> $db_private.$prod_schema_adb_private$ver_priv
	$db_private.$dev_schema_adb_private --> $db_private.$prod_schema_adb_private
	$db_private.$prod_schema_users --> $db_private.$prod_schema_users$ver_priv
	$db_private.$dev_schema_users --> $db_private.$prod_schema_users
	$db_public.$prod_schema_adb_public --> $db_public.$prod_schema_adb_public$ver_pub
	$db_public.$dev_schema_adb_public --> $db_private.$prod_schema_adb_public
	
EOF
	)"		
	confirm "$msg_conf"
fi

echoi $e "Executing module '$local_basename'"


######################################################
# Replace public data schema
######################################################

echoi $e "- Fixing public schema \"$prod_schema_adb_private\" in database \"$db_public\":"



# Append version to schema as backup schema name
prod_schema_bak=$prod_schema_adb_public$ver_pub

ver="4.0.3"
prod_schema_adb_public="public"
prod_schema_bak="public_4_0_3"



echoi $e -n "-- Setting versions dates for new database..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -v ver=$ver -f $DIR_LOCAL/sql/set_dates_new.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Setting versions dates for old database..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_bak -v ver=$ver -f $DIR_LOCAL/sql/set_dates_old.sql
source "$DIR/includes/check_status.sh"


######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
#!/bin/bash

#########################################################################
# Purpose:	Backs up entire schema, as specified in local params file
#
# Notes: 
#	1. Must be restored using pg_restore utility.
#	2. All tables in schema MUST be owned by user bien
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
pname_custom="Backup schema"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	
	
#########################################################################
# Get db version and compose dumpfile name
#########################################################################

# Get current db version & trim whitespace
db_version_text=""
db_version_disp=""
if [[ "$include_db_version" = "true" ]]; then 
	if [[ "$lookup_db_version" = "true" ]]; then
		# Get db version from database
		db_version=`psql -d $db -U $user -tq -c "SELECT db_version FROM ${dbv_sch}.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM ${dbv_sch}.bien_metadata)"`
		db_version="$(trim "${db_version}")"
	fi

	# If not looking up db version, parameters MUST be supplied in 
	# local params file
	db_version_disp=" (v"$db_version")"
	db_version_text="_v"$db_version

fi

# Compose name of backup file, including date
ext="pgd"		# Short for pg_dumpfile
dumpfile_basename=$db"."$sch$db_version_text"_$(date +%Y%m%d_%H%M%S)"
#dumpfile_basename=$db"."$db_version_text"_$(date +%Y%m%d_%H%M%S)"
dumpfile_name=$dumpfile_basename"."$ext
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
	
	Backup type:		Schema only
	Database to backup:	$db$db_version_disp
	Schema to backup:	$sch
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

# Check source db exists before starting
if ! psql -lqt | cut -d \| -f 1 | grep -qw $db; then
	echo; echo "ERROR: Required database '$db' missing"; echo 
	exit 1
fi

# Check source schema exists
sch_exists=$(exists_schema_psql -d $db -u $user -s $sch )
if [[ $sch != 'public' && $sch_exists == "f" ]]; then
	echo "ERROR: source schema '$sch' doesn't exist in db '$db'!"
	exit 1
fi

# Dump schema from source database
# Option -Fc forces custom pg_dump format, which is already compressed
# Must be restored using pg_restore utility
echoi $e -n "-- Creating dumpfile of schema '$sch' in db '$db'..."
pg_dump -U $user -Fc -n $sch $db > $dumpfile
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



#!/bin/bash
#su postgres		# Run as (superuser) postgres

#########################################################################
# Purpose:	Backs up entire database as plain SQL, then compresses to 
#	tarball
#
# Warning: $user must have permissions on all objects in database.
#
# Note: Must be restored using psql, not pg_restore.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
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
pname_custom="Backup database as plain SQL + tar.gz"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	
	
#########################################################################
# Params
#########################################################################

db="public_vegbien"

ext="sql"		# File extension (plain SQL)

# schema where db version table lives, if applicable
dbv_sch=$dev_schema_adb_public

#########################################################################
# Get db version and compose dumpfile name
#########################################################################

# Get current db version & trim whitespace
db_version_text=""
db_version_disp=""
if [[ "$include_db_version" = "true" ]]; then 
	db_version=`psql -d $db -U $user -t -c "SELECT db_version FROM ${dbv_sch}.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM ${dbv_sch}.bien_metadata)"`
	db_version="$(trim "${db_version}")"
	db_version_disp=" (v"$db_version")"
	db_version_text="_v"$db_version
fi


# Compose name of backup file, including date
dumpfile_basename=$db$db_version_text"_$(date +%Y%m%d_%H%M%S)"
dumpfile_name=$dumpfile_basename"."$ext
dumpfile=$data_dir_local"/"$dumpfile_name

tarball=$dumpfile".tar.gz"
tarball_name=$dumpfile_name".tar.gz"

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Backup type:		Complete database
	Database to backup:	$db$db_version_disp
	Dumpfile name: 		$tarball_name
	Dumpfile path: 		$data_dir_local/
	Dumpfile type:		Plain SQL, as tarball
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

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

# Dump schema from source database
# Option -Fc forces custom pg_dump format, which is already compressed
# Must be restored using pg_restore utility
echoi $e -n "-- Creating dumpfile of database '$db'..."
pg_dump -U $user $db > $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Compressing to tarball..."
tar -czf $tarball $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing uncompressed dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Echo final instructions, if running standalone
######################################################

if [ -z ${master+x} ]; then

msg_next_steps="$(cat <<-EOF

Dumpfile '$tarball_name' created. To restore, uncompress the tarball,  
then run the following command as user postgres:

psql -d [database_to_restore_to] -f $dumpfile_name

'database_to_restore_to' does not need to be the same as original db. 

EOF
)"
echoi $e "$msg_next_steps"

fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



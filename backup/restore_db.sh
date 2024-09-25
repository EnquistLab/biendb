#!/bin/bash

#########################################################################
# Purpose:	Restores entire database from compressed pgdump archive
#
# Notes:
#	1. All parameters set in params section below, does not use
#		external parameters file
#	2. Resulting dump file must be restored using pg_restore utility.
#	3. Must run script using sudo (see Usage, below)
#
# Usage:
# 	./restore_db.sh [options]
#
# Options (the usual):
#	-n	Non-interactive more, with screen echo
#	-s	Silent mode: non-interactive, no screen echo
#	-m	Send confirmation email
#
# WARNING!
# 	Owner of the database must have permission on all objects in 
# 	database. For postgis schemas (postgis, topology, typically 
#	owned by postgis), be sure to grant USAGE on the schema and 
#	SELECT on all tables and sequences to the main database owner.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Trigger sudo password request
# Should remain in effect for all sudo commands in this 
# script, regardless of sudo timeout
sudo pwd >/dev/null

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
	
#########################################################################
# Params
#########################################################################

# Target database where backed up database will be restored
db_new="gnrs_2_1"

# Dumpfile name
dumpfile_name="gnrs_20210826_170740.pgd"

# Directory where backup file was saved
# Omit trailing slash
backup_dir="/home/bien/backups"

# Confirmation email address
# Only used if option "-m" used
email="bboyle@email.arizona.edu"

#########################################################################
# Compose dumpfile name & path
#########################################################################

dumpfile=$backup_dir"/"$dumpfile_name

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Dumpfile name: 		$dumpfile_name
	Dumpfile path: 		$backup_dir/
	Target database:	$db_new (must exist!)
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
if ! psql -lqt | cut -d \| -f 1 | grep -qw $db_new; then
	echo; echo "ERROR: Target database '$db_new' missing"; echo 
	exit 1
fi

# Restore dumpfile to target db
echoi $e -n "-- Restoring dumpfile to database '$db_new'..."
sudo -Hiu postgres pg_restore -d $db_new $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
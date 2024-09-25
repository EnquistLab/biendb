#!/bin/bash

#########################################################################
# Purpose:	Backs up all postgres databases using pg_dumpall
#
# WARNING: MUST run as sudo
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
pname_custom="Postgres full backup"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	
	
#########################################################################
# Get db version and compose dumpfile name
#########################################################################

# Compose name of backup file, including date
ext="sql"			# pg_dumpall output is not compressed
dumpfile_basename="pgdumpall_$(date +%Y%m%d_%H%M%S)"
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
	
	Backup type:		Full: all pg databases using pg_dumpall
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

# Dump complete postgres data for all databases
# Must be run as sudo and user postgres
echoi $e -n "-- Creating raw dumpfile..."
sudo -u postgres pg_dumpall -U postgres > $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Compressing dumpfile..."
dumpfile_compressed=$dumpfile".tar.gz"
sudo tar -czf $dumpfile_compressed $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing raw dumpfile..."
sudo rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



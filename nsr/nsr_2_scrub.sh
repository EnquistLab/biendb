#!/bin/bash

#########################################################################
# Purpose: Validates species observation native/introduced status using
#	NSR. Assume input file already present in NSR data directory, as 
#	set in global params.sh
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
# $local_basename = name of this file minus '.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
local=`basename "${BASH_SOURCE[0]}"`
local_basename="${local/.sh/}"

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local_simple.sh"	

# Override selected parameters if requested & running standalone
if [[ "$params_override" == "t" && -z ${master+x} ]]; then
	source "$DIR_LOCAL/params_override.sh"
fi 

# Compose path + name of NSR input file
inputfile="${validation_app_data_dir}/${submitted_filename}"

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" == "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	NSR dir (app_dir):	${app_dir}
	NSR data dir: 		${validation_app_data_dir}
	NSR data file: 		${submitted_filename}
	Replace NSR cache?	$local_nsr_cache_replace
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

if [ -z ${master+x} ]; then 
	echoi $e "Executing module '$local_basename'"
fi

echoi $e -n "- Scrubbing observations with NSR..."

# # Save current working directory
# DIR_BAK=$(pwd)

# Run NSR with echo and interactive modes off
#cd $app_dir
php ${app_dir}/nsr_batch.php -e=false -i=false -f="${submitted_filename}" -l=unix -t=csv -r="$local_nsr_cache_replace"

# # Reset working directory
# DIR=$DIR_BAK
# cd $DIR

source "$DIR/includes/check_status.sh"	

# Restore overridden parameters if applicable
if [[ "$params_override" == "t" && -z ${master+x} ]]; then
	source "$DIR_LOCAL/params_override.sh"
fi 

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
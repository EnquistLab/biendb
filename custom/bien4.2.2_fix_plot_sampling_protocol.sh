#!/bin/bash

#########################################################################
# Purpose: Fixes badly formed morphospecies for plot observations only
# in vfoi and analytical_stem, both database. Also increments version
# number to 4.2.2
#
# Date: 4 Oct 2021
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	User:		$user
	Database:	Both	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "

echoi $e "Fixing morphospecies:"


echoi $e -n "Public database..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d public_vegbien --set ON_ERROR_STOP=1 -q -v sch='public' -f $DIR_LOCAL/sql/bien4.2.2_fix_plot_sampling_protocol.sql
source "$DIR/includes/check_status.sh"  

echoi $e -n "Private database..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d vegbien --set ON_ERROR_STOP=1 -q -v sch='analytical_db' -f $DIR_LOCAL/sql/bien4.2.2_fix_plot_sampling_protocol.sql
source "$DIR/includes/check_status.sh"  

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
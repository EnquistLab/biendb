#!/bin/bash

#########################################################################
# Purpose: Updates columns "is_cultivated_taxon" and 
# "is_cultivated_in_region" for the three main analytical tables
# part of BIEN db hotfix version 4.2.1
#
# Date: 24 June 2021
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
	
	Database:	$db
	Schema:		$sch
	User:		$user
	Data dir:	$data_dir
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "

echoi $e "- Updating table:"

echoi $e -n "- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/bien4.2.1_update_nsr_is_cultivated_columns_agg_traits.sql
source "$DIR/includes/check_status.sh"  

echoi $e -n "- analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/bien4.2.1_update_nsr_is_cultivated_columns_astem.sql
source "$DIR/includes/check_status.sh"  

echoi $e -n "- vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/bien4.2.1_update_nsr_is_cultivated_columns_vfoi.sql
source "$DIR/includes/check_status.sh"  

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
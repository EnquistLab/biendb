#!/bin/bash

#########################################################################
# Purpose: Updates trait summary tables
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads only local parameters if called by master script.
# Otherwise loads all parameters, functions and options
# Local parameters $db and $dev_schema used ONLY if
# running along, not called by master script
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
# Main
#########################################################################

echoi $e "Executing module '$local_basename' with parameters db='$db' & dev_schema='$dev_schema'"

echoi $e -n "- Creating table 'taxon_trait'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/taxon_trait.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Creating table 'trait_summary'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/trait_summary.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



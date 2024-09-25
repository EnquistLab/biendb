#!/bin/bash

#########################################################################
# Purpose: Install all required functions, procedures, extensions, etc, 
#	if not already present.
#
# Note: All functions are installed in schema public and must be called
# by reference this schema, e.g., public.f_empty2null()
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Import raw data
######################################################

echoi $e "- Installing functions:"

echoi $e -n "-- f_empty2null..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/f_empty2null.sql > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

echoi $e -n "-- geodistkm..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/geodistkm.sql > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

echoi $e -n "-- is_numeric..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/is_numeric.sql > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

echoi $e -n "-- is_date..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/is_date.sql > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



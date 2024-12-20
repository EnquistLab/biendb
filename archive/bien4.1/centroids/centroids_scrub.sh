#!/bin/bash

#########################################################################
# Purpose: TEMPORARY PLACEHOLDER UNTIL CENTROID VALIDATION READY!
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
source "$DIR/includes/startup_local.sh"	

#########################################################################
# Main
#########################################################################

if [ -z ${master+x} ]; then
	echoi $e "Executing module '$local_basename'"
else
	echoi $e "Executing module 'centroids'"
fi

#########################################################################
# Import centroid validation results 
#########################################################################

# create tnrs results tables
echoi $e "- Performing centroid validation...SKIPPING"

echoi $e -n "- Copying over existing centroid table (TEMP HACK)..."
source "$DIR/includes/check_status.sh"	


######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
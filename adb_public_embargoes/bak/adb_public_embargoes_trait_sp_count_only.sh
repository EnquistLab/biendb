#!/bin/bash

#########################################################################
# Purpose:	One-time shortcut fix to delete low-quality trait records
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

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

echoi $e -n "- Deleting traits with <$sp_count_min species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -v sp_count_min=$sp_count_min -f $DIR_LOCAL/sql/traits_species_count_embargo.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Updating taxon counts..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -f $DIR_LOCAL/sql/update_bien_taxonomy.sql
source "$DIR/includes/check_status.sh"

######################################################
# Echo final instructions if running solo
######################################################

if [ -z ${master+x} ]; then

msg_next_steps="$(cat <<-EOF

Script completed. 

Next steps:

1. Finish updating remaining metadata tables
2. Restore indexes & permissions on tables vfoi and agg_traits

EOF
)"
echoi $e "$msg_next_steps"

fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



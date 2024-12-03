#!/bin/bash

#########################################################################
# Purpose: Restores all indexes on live database, updating the main three
# tables only. 
# Use this method when updating analytical tables by copying to new tables
# with suffix "_new".
#
# NOTE: parameters $db and $sch MUST be set prior to calling this script!
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
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

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
fi

# Load startup script for local files
# Sets remaining parameters and options
source "$DIR/includes/startup_local_simple.sh"	
	
# Override selected parameters if requested & running standalone
if [[ "$params_override" == "t" && -z ${master+x} ]]; then
	source "$DIR_LOCAL/params_override.sh"
fi 

######################################################
# Custom confirmation message
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" == "true" && -z ${master+x} ]]; then 
	
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:		$db
	Schema:			$sch
	User:			$user
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

if [ -z ${master+x} ]; then
	# Only echo progress messages if running standalone
	echoi $e "Executing module '$local_basename'"
fi

#
# Drop indexes
#

echoi $e "- Dropping existing indexes, if any, on tables:"

echoi $e -n "-- view_full_occurrence_individual_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_new_drop_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_new_drop_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- analytical_stem_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_new_drop_indexes.sql
source "$DIR/includes/check_status.sh"

#
# Restore indexes
#

echoi $e "- Restoring indexes on tables:"

echoi $e -n "-- view_full_occurrence_individual_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_new_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_new_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- analytical_stem_new..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_new_restore_indexes.sql
source "$DIR/includes/check_status.sh"

#
# Create index summary view
#

# echoi $e -n "- Creating index summary view..."
# PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/index_views.sql
# source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

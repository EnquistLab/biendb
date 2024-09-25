#!/bin/bash

#########################################################################
# Purpose: Restores all indexes. The version assumes '_dev' versions of 
#	vfoi and analytical_stem
#
# NOTE: parameters $db and $dev_sch MUST be set prior to calling this script!
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

echoi $e "- Dropping existing indexes, if any, on tables:"
# Leaving original xxx_drop_indexes.sql scripts in places as they drop
# constraints, which are not covered by function drop indexes. However,
# original scripts are hard wired and may miss some regular indexes. 
# Function drop_indexes drops all regular indexes, so will mop up any 
# indexes missed by old scripts. 
# Long term: add option to drop_indexes to drop constraints as well

echoi $e -n "-- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_dev_drop_indexes.sql
drop_indexes -q -p -u $user -d $db -s $sch -t "view_full_occurrence_individual_dev"
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_drop_indexes.sql
drop_indexes -q -p -u $user -d $db -s $sch -t "agg_traits"
source "$DIR/includes/check_status.sh"

echoi $e -n "-- analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_dev_drop_indexes.sql
drop_indexes -q -p -u $user -d $db -s $sch -t "analytical_stem_dev"
source "$DIR/includes/check_status.sh"

echoi $e -n "-- bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/bien_taxonomy_drop_indexes.sql
drop_indexes -q -p -u $user -d $db -s $sch -t "bien_taxonomy"
source "$DIR/includes/check_status.sh"

echoi $e "- Restoring indexes on tables:"

echoi $e -n "-- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_dev_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_dev_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/bien_taxonomy_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Creating index summary view..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/index_views.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



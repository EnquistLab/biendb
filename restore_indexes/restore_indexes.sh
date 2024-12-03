#!/bin/bash

#########################################################################
# Purpose: Restores all indexes on live database
#
# NOTE: parameters $db and $dev_sch MUST be set prior to calling this script!
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
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"



### TEMP ####
echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# Start comment block
: <<'COMMENT_BLOCK_2'




#
# Drop indexes
#

echoi $e "- Dropping existing indexes, if any, on tables:"

echoi $e -n "-- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_drop_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_drop_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_drop_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/bien_taxonomy_drop_indexes.sql
source "$DIR/includes/check_status.sh"



# End comment block
COMMENT_BLOCK_2
### TEMP ####


#
# Restore indexes
#

echoi $e "- Restoring indexes on tables:"

echoi $e -n "-- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/vfoi_restore_indexes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/agg_traits_restore_indexes.sql
source "$DIR/includes/check_status.sh"


echoi $e -n "-- analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/analytical_stem_restore_indexes_TEMP.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/bien_taxonomy_restore_indexes.sql
source "$DIR/includes/check_status.sh"

#
# Create index summary view
#

echoi $e -n "- Creating index summary view..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch -f $DIR_LOCAL/sql/index_views.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

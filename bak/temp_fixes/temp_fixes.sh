#!/bin/bash

#########################################################################
# Purpose: One-time fixes to results of analytical db pipeline
# 		Not part of permanent pipeline.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 10 March 2017
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

# Copy view_full_occurrence, stripping indexes and adding & populating
# new column taxonomic_status
echoi $e -n "- Copying table 'vfoi' & adding new column taxonomic_status ..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/copy_table_vfoi.sql
source "$DIR/includes/check_status.sh"	

COMMENT_BLOCK_1

# Copy analytical_stem
echoi $e -n "- Copying table 'analytical_stem'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/copy_table_analytical_stem.sql
source "$DIR/includes/check_status.sh"

: <<'COMMENT_BLOCK_2'

# Add indexes needed to update plot_metadata_id in vfoi
echoi $e -n "- Indexing candidate key columns in table vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_index_candidate_keys.sql
source "$DIR/includes/check_status.sh"	

# Populate plot_metadata_id in vfoi
echoi $e -n "- Populating fkey plot_metadata_id in table vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_populate_fkey_plot_metadata_id.sql
source "$DIR/includes/check_status.sh"	

# Add indexes needed to update plot_metadata_id in analytical_stem
echoi $e -n "- Indexing joining columns in vfoi and analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/analytical_stem_index_columns.sql
source "$DIR/includes/check_status.sh"	

# Populate analytical_stemp.plot_metadata_id by joining to table vfoi
echoi $e -n "Populating fk plot_metadata_id in table 'analytical_stem'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/analytical_stem_update_fk_plot_metadata_id.sql
source "$DIR/includes/check_status.sh"

# Add remaining indexes to vfoi
echoi $e -n "Restoring remaining indexes on table vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_restore_indexes.sql
source "$DIR/includes/check_status.sh"

COMMENT_BLOCK_2

# Add remaining indexes to analytical_stem
echoi $e -n "Restoring remaining indexes on table analytical_stem..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/analytical_stem_restore_indexes.sql
source "$DIR/includes/check_status.sh"

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Final steps:

1.Grant select-only privilege on all tables in schema to user bien_private
2. Remove any comments from this script

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

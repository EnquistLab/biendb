#!/bin/bash

#########################################################################
# Purpose: Insert records from staging tables to main tables
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
## Start comment block
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# : <<'COMMENT_BLOCK_xxx'
#### TEMP ####

#### TEMP ####
## End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# No parameters, these must be set by calling script
######################################################
	
#########################################################################
# Main
#########################################################################

#echoi $e "Executing module '$local_basename'"

echoi $e "- Loading main tables from staging:"

# Retrieve last PK from metadata table
# Needed for error check, below
prev_datasource_id=$(psql -qtA -d $db_private -c "SELECT MAX(datasource_id) FROM ${dev_schema}.datasource")

echoi $e -n "-- datasource..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/append_from_staging_datasource.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/append_from_staging_plot_metadata.sql
source "$DIR/includes/check_status.sh"

echoi $e "-- view_full_occurrence_individual:"

echoi $e -n "--- Inserting records..."
if [[ "$use_datasource_staging_id" == "t" ]]; then
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/append_from_staging_vfoi_by_datasource_id.sql
else
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/append_from_staging_vfoi.sql
fi
source "$DIR/includes/check_status.sh"

echoi $e -n "--- Indexing foreign keys..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src=$src -f $DIR/import/sql/vfoi_index_fkeys.sql
source "$DIR/includes/check_status.sh"

# Causing trouble...may be legacy code not needed. Check carefully before delete
# echoi $e -n "--- Dropping temporary foreign key column fk_vfoi_staging_id..."
# PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/vfoi_drop_fk_vfoi_staging_id.sql
# source "$DIR/includes/check_status.sh"

tbl_stem_staging=$dev_schema".analytical_stem_staging"
stem_records=$( has_records_psql -d $db_private -u $user -t $tbl_stem_staging )
if [[ $stem_records == 't' ]]; then
	echoi $e -n "-- analytical_stem..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/append_from_staging_analytical_stem.sql
	source "$DIR/includes/check_status.sh"
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
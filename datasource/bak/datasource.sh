#!/bin/bash

#########################################################################
# Purpose: Creates analytical table datasource
#
# Usage: 
#		$ ./create_datasource.sh [options]
#  
# Purpose:
# Creates analytical table datasource with one record for each distinct
# proximate data_provider ("datasource") plus dataset combination in the
# BIEN database. Populates it with existing data source information, 
# as extracted from (1) analytical table plot_metadata (plot data only), 
# (2) view_full_occurrence_individual (vfoi; specimen data only), and (3) 
# local copy of Index Herbariorum (specimen data only). Table is then
# copied over to production database, and foreign keys added to tables
# plot_metadata, vfoi and analytical_stem. During this process, a CSV
# file of the contents of the completed table is exported, to be used
# to enter missing content manually. This information is then added to
# the production table in a separate step (update_datasource.sh).
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 17 Sept. 2016
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

# Start error log
echo "Error log
" > $DIR_LOCAL/log.txt

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Create table datasource
######################################################

echoi $i -n "- Creating table datasource..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_datasource.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Inserting existing information for plots..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_existing_plot_info.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Inserting existing information for specimens..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_existing_specimen_info.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Extracting proximate data providers..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/extract_proximate_providers.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Flag data sources which are also herbarium acronyms
######################################################

echoi $i -n "- Copying table 'ih' from schema 'herbaria' to '$dev_schema'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v src_schema='herbaria' -f $DIR_LOCAL/sql/copy_ih.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Updating table 'ih'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_ih.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Flagging herbarium data sources..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/flag_herbaria.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Indexing..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_datasource.sql
source "$DIR/includes/check_status.sh"

echoi $i -n "- Exporting table 'datasource' as csv file to data directory..." 
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v data_dir_local=$data_dir_local -f $DIR_LOCAL/sql/export_datasource.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Add foreign key to table plot_metadata
#########################################################################

echoi $i -n "- Adding FK to table plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/plot_metadata_add_fk.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Add foreign key to table vfoi
#########################################################################

echoi $i "- Adding foreign key to table 'view_full_occurrence_individual':"

# Index vfoi columns that will be used to join to plot_metadata
echoi $i -n "-- Indexing candidate keys..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_index_candidate_keys.sql
source "$DIR/includes/check_status.sh"	

# Populate foreign key
echoi $i -n "-- Populating FK 'datasource_id'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_populate_fkey.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Update table datasource from hand-edited file, if  
# requested in params file. Assumes this script has  
# already been run once, and export of table datasource  
# has been inspected, edited and re-imported as CSV
# file to local data directory
######################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

# START backup if...then
# Can't indent due to here-doc
if [ $apply_update  == "true" ]; then
	echoi $i "- Applying update from file:"

# Create datasource_upate, an empty copy of table datasource
echoi $i -n "-- Creating table datasource_update in schema $dev_schema..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_datasource_update.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "-- Importing spreadsheet..."
sql="
\COPY datasource_update FROM '${data_dir_local}/${update_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

# Index the primary key
echoi $i -n "-- Indexing table datasource_update..."
sql="
CREATE INDEX datasource_update_datasource_id_idx ON ${dev_schema}.datasource_update USING btree (datasource_id);
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

# Update the table by joining on PK, substituting contents of all
# columns from the imported spreadsheet
echoi $i -n "-- Updating datasource..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_datasource.sql
source "$DIR/includes/check_status.sh"	

fi
# END backup if...then

echoi $i -n "- Updating 'source_type'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_source_type.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Final fixes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/final_fixes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

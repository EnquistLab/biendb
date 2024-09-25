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

echoi $e "Executing module '$local_basename'"

######################################################
# Create table datasource
######################################################

echoi $e -n "- Creating table datasource..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_datasource.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Inserting existing information for plots..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_existing_plot_info.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Inserting existing information for specimens..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_existing_specimen_info.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Extracting proximate data providers..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/extract_proximate_providers.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Flag data sources which are also herbarium acronyms
######################################################

echoi $e -n "- Copying table 'ih' from schema 'herbaria' to '$dev_schema'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v src_schema='herbaria' -f $DIR_LOCAL/sql/copy_ih.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating table 'ih'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_ih.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Flagging herbarium data sources..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/flag_herbaria.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_datasource.sql
source "$DIR/includes/check_status.sh"

#########################################################################
# Add foreign keys
#########################################################################

echoi $e "- Adding FKs:"
echoi $e -n "-- Table plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/plot_metadata_add_fk.sql
source "$DIR/includes/check_status.sh"	

echoi $e "-- Table view_full_occurrence_individual:"
# Index vfoi columns that will be used to join to plot_metadata
echoi $e -n "--- Indexing candidate keys..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_index_candidate_keys.sql
source "$DIR/includes/check_status.sh"	

# Populate foreign key
echoi $e -n "--- Populating FK 'datasource_id'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/vfoi_populate_fkey.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating 'source_type'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_source_type.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Final fixes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/final_fixes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

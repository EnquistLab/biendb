#!/bin/bash

#########################################################################
# Purpose: Populates columns dataset, dataowner to analytical table  
# view_full_occurrence_individual  
#
# NOTE: Remove COMMENT_BLOCK surrounding last two steps to replace
#	original tables. If not removed, will only generate tables in 
#	development schema.
#
# Details:
#   "dataset": standard name or code for a group of related plots or
#		a collection of specimen observations. Can be NULL. Equivalent to  
# 		'project' in SALVIAS and BIEN2.
#	"dataowner": the (primary) person or institution who produced and/or
#		owns the data. Can be NULL.
#
# Assumes:
# 	Column "datasource" has been indexed. If not, this script will be
#	extremely slow.
#
# Usage: 
#		$ ./data_provenance.sh [options]
#  
# Warning #1:
# 	This information was largely omitted from the core database and must
# 	therefore be extracted in part from the original raw data imports. 
# 	Each import resides in its own schema in database vegbien. The name  
# 	of the schema is the same as its datasource code. Ideally, the core  
# 	database scripts should be refactored to add this information to table  
# 	vfoi at the time of creation.
# 
# Warning #2:
# 	This version currently works only on public_vegbien. Once all 
#	modifications currently restricted to public_vegbien have been
#	transferred over to vegbien, the operations in this script should
# 	only be carried out on vegbien.vfoi. The public version would be
# 	simply a copy of this, with embargoed records removed.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 8 Sept. 2016
# Latest update: 22 Mar 2017
#########################################################################

#########################################################################
# Set parameters, load functions & confirm operation
# 
# Loads local parameters only if called by master script.
# Otherwise loads all parameters, functions and options
#########################################################################

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

echoi $i "Executing module 'plot_provenance':"

# Update columns dataowner, dataset, plot_name and subplot
echoi $i -n "- Populating dataset for specimens and removing non-plot plot codes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/update_specimens_remove_nonplots.sql
source "$DIR/includes/check_status.sh"	

# Index columns needed for updating plot observations
echoi $i -n "- Indexing plot-related columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/index_plot_columns.sql
source "$DIR/includes/check_status.sh"	

# Create temporary table plot_provenance
echoi $i -n "- Creating table plot_provenance..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/create_table_plot_provenance.sql
source "$DIR/includes/check_status.sh"	

##########################################################
# Populate plot_provenance by querying original data for  
# each plot data source. Requires a custom script for each  
# datasource.
##########################################################

echoi $i "- Populating table plot_provenance:"

echoi $i -n "-- SALVIAS..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_salvias.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "-- TEAM..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_team.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "-- VegBank..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_vegbank.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "-- Remaining plot datasources..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_hardwired_sources.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "-- Final fixes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_last_fixes.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Update plot data sources in vfoi_temp by joining to table 
# plot_data_provenance and copying over to new table, vfoi_dev
#########################################################################

echoi $i -n "- Updating plot provenance in table 'view_full_occurrence_individual_dev'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/plot_provenance_vfoi_update.sql
source "$DIR/includes/check_status.sh"	

: <<'COMMENT_BLOCK_2'
COMMENT_BLOCK_2

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

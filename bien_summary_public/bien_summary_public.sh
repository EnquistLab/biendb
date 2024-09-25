#!/bin/bash

#########################################################################
# Purpose: Updates public bien summary table
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

######################################################
# Create table bien_summary_public in development schema
# if doesn't exist already in production schema, 
# else copy it.
######################################################

table_exists=$(exists_table_psql -d $db_public -u $user -s $prod_schema -t 'bien_summary_public' )

if [[ $table_exists == "f" || $force_create == "true" ]]; then	
	echoi $i -n "- Creating table bien_summary_public..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_bien_summary_public.sql
else
	echoi $i -n "- Copying existing table bien_summary_public from schema '$prod_schema'..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v prod_schema=$prod_schema -f $DIR_LOCAL/sql/copy_bien_summary_public.sql > /dev/null >> "/tmp/tmplog.txt"
fi

source "$DIR/includes/check_status.sh"

######################################################
# Insert new record with timestamp & current database  
# version.
######################################################

echoi $e -n "- Inserting new summary record....."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_new.sql
source "$DIR/includes/check_status.sh"

######################################################
# Populate count fields in the newly-inserted record.
######################################################

echoi $e -n "- Counting observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_obs.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting geovalid observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_obs_geovalid.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting specimen observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_specimens.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting plot observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_plot_obs.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting plots..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_plots.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_species.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



#!/bin/bash

#########################################################################
# Copies political division lookup tables from database geoscrub
# to analytical database
#
# UNDER CONSTRUCTION
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 23 May 2017
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
source "$DIR/includes/local_params.sh"	

#########################################################################
# Params
#########################################################################

# Reset process name here if applicable
pname_local=$pname_local

# Development schema where table will be created prior to moving to 
# production. Name will be same in both private and public databases.
# Do not use an existing schema name as it will be dropped and re-
# created.
target_sch=$prod_schema_adb_public	

#########################################################################
# Main
#########################################################################

# Confirm operation
pname_local_header="BIEN notification: process '"$pname_local"'"
source "$DIR/includes/local_confirm.sh"	

# Start error log
echo "Error log
" > $DIR_LOCAL/log.txt

echoi $e ""
echoi $e "Executing module '$local_basename'"
echoi $e ""

######################################################
# Import table countries from geoscrub database
######################################################

echoi $e "Copying table '$tbl' from db '$db_geoscrub' to schema '$target_sch' in db '$db_public':"

# Dump table from source databse
echoi $e -n "- Creating dumpfile..."
dumpfile=$data_dir_local"/countries.sql"
pg_dump -U $user -t $tbl $db_geoscrub > $dumpfile
source "$DIR/includes/check_status.sh"	

# Drop the table in core database if it already exists
echoi $e -n "- Dropping previous table, if any..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $target_sch.$tbl"
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "- Importing table from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_public < $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

: <<'COMMENT_BLOCK_1'

echoi $e -n "Indexing tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$target_sch -f $DIR_LOCAL/sql/indexes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "Adjusting permissions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$target_sch -f $DIR_LOCAL/sql/permissions.sql
source "$DIR/includes/check_status.sh"	


COMMENT_BLOCK_1
######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
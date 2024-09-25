#!/bin/bash

#########################################################################
# Purpose: Copies table "ranges" from "public.public_vegbien" to 
# "analytical_db_dev.vegbien"
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

echoi $e "Executing module '$local_basename':"

######################################################
# Abort if table already exits in destination database
######################################################

# Abort if source table missing from source database
src_table_exists=$(exists_table_psql -d $src_db -u $user -s $src_schema -t $tbl )

if [[ $src_table_exists == "f" ]]; then	
	echo
	echo "ERROR: source table '$tbl' missing from schema '$src_schema' of database '$src_db'!"
	echo 
	exit 1
fi 

# Abort if table already exits in destination database
target_table_exists=$(exists_table_psql -d $target_db -u $user -s $target_schema -t $tbl )

if [[ $target_table_exists == "t" ]]; then	
	echo
	echo "ERROR: Table '$tbl' already exists in target schema '$target_schema' of database '$target_db'. Please delete manually first if you wish to replace"
	echo 
	exit 1
fi 

######################################################
# Copy the table between databases & schemas
######################################################

echoi $e "- Copying table '$tbl' from db '$src_db' to schema '$target_schema' in db '$target_db':"

# Dump table from source database
echoi $e -n "-- Creating dumpfile..."
dumpfile=$data_dir_local"/"$tbl".sql"
pg_dump -U $user -t $tbl --schema=$src_schema $src_db > $dumpfile
source "$DIR/includes/check_status.sh"	

# Replace schema references. Be very conservative to avoid 
# corrupting data which matches schema name 
# Recommend stopping first time prior to point to inspect dumpfile
# to be sure that substitutions are correct
echoi $e -n "-- Editing dumpfile..."
SEARCH="SET search_path = "$src_schema", pg_catalog;"
REPLACE="SET search_path = "$target_schema", pg_catalog, postgis;"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="SET search_path = "$src_schema";"
REPLACE="SET search_path = "$target_schema", postgis;"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="SET search_path = "$src_schema","
REPLACE="SET search_path = "$target_schema","
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="Schema: "$src_schema";"
REPLACE="Schema: "$target_schema";"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH=$src_schema"."$tbl
REPLACE=$target_schema"."$tbl
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "-- Importing table from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $target_db < $dumpfile > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
rm $dumpfile".bak"
source "$DIR/includes/check_status.sh"	

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


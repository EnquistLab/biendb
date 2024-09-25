#!/bin/bash

#su postgres		# Run as (superuser) postgres

#########################################################################
# Purpose:	Copies table world_geom from public database to private 
#	analytical schema. 
#
# Note: Schemas MUST have the same name in both databases
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

############################################################
# Copy table from production schema to development schema
############################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

echoi $i -n "Copy table 'world_geom' from '$prod_schema_adb_public' to '$dev_schema_adb_public' in db 'db_public'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v prod_schema=$prod_schema_adb_public -v dev_schema=$dev_schema_adb_public -f $DIR_LOCAL/sql/copy_world_geom.sql 
source "$DIR/includes/check_status.sh"

############################################################
# Export dumpfile of analytical schema from private db
############################################################

# Compose dumpfile name
dumpfilename="world_geom.sql"
dumpfile=$data_dir_local"/"$dumpfilename

# Dump schema from source database
# Note that table is coming from public, not dev schema
echoi $e -n "-- Exporting dumpfile of table world_geom..."
pg_dump -U $user -t world_geom $db_public > $dumpfile
source "$DIR/includes/check_status.sh"	

############################################################
# Edit dump file
#  
# Changes schema references for geometry columns. In 
# private db, references point to schema postgis; in 
# public database, they point to schema public. 
#
# This is a hack! Necessary due to different installations
# of postgis extensions. Ultimately we need to make
# both the same. I favour how it is done in vegbien,
# with spatial reference tables in separate schema postgis.
############################################################

echoi $e -n "-- Editing dumpfile..."
SEARCH="SET search_path = public, pg_catalog;"
REPLACE="SET search_path = "$dev_schema_adb_private", pg_catalog, postgis;"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="Schema: public;"
REPLACE="Schema: "$dev_schema_adb_private";"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="ALTER TABLE public.world_geom_ogc_fid_seq"
REPLACE="ALTER TABLE "$dev_schema_adb_private".world_geom_ogc_fid_seq"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
SEARCH="ALTER TABLE public.world_geom"
REPLACE="ALTER TABLE "$dev_schema_adb_private".world_geom"
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
source "$DIR/includes/check_status.sh"	

############################################################
# Import dumpfile to public db
############################################################

# Check target schema exists before starting
sch_exists=$(exists_schema_psql -d $db_private -u $user -s $dev_schema_adb_private )
if [[ $sch_exists == "f" ]]; then
	echo "ERROR: target schema '$dev_schema_adb_private' doesn't exist in db '$db_private'!"
	exit 1
fi

# Restore table to target database
echoi $e -n "-- Restoring table world_geom to schema to db '$db_private'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user --set ON_ERROR_STOP=1 -q $db_private < $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

: <<'COMMENT_BLOCK_2'
COMMENT_BLOCK_2

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



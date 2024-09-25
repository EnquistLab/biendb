#!/bin/bash

#########################################################################
# Purpose: Creates and populates table observations_union in production
# 	private analytical schema, then copies to production anaytical
#	schema in public database.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 17 May 2017
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
pname_local=$pname_local_standalone

# Development schema where table will be created prior to moving to 
# production. Name will be same in both private and public databases.
# Do not use an existing schema name as it will be dropped and re-
# created.
dev_schema="observations_union_dev"	

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

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

######################################################
# Create tables in private analytical db
######################################################

prod_schema=$prod_schema_adb_private

echoi $e "Creating table observations_union in private database:"

# Add geom index to vfoi if not already present
idx="vfoi_geom_not_null_idx"
idx_exists=$(exists_index_psql -d $db_private -u $user -s $prod_schema -i $idx)

if [[ $idx_exists == "f" ]]; then
	echoi $e -n "- Indexing column 'geom' in table vfoi in schema '$prod_schema'..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$prod_schema -f $DIR_LOCAL/sql/index_vfoi_geom.sql
source "$DIR/includes/check_status.sh"	
fi

echoi $e -n "- Creating schema '$dev_schema'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_schema.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating & populating table species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v adb_schema=$prod_schema -f $DIR_LOCAL/sql/create_species.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating temp table observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v adb_schema=$prod_schema -f $DIR_LOCAL/sql/create_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating geometry column in observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/add_geometry_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating & populating table observations_union..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_observations_union.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Adjusting permissions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/permissions.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Create tables in public analytical db
#
# Can't just copy over from private database.
# Rebuilding based on vfoi in public database ensures
# that coordinates of embargoed species not included.
######################################################

prod_schema=$prod_schema_adb_public

echoi $e "Creating table observations_union in public database:"

# Add geom index to vfoi if not already present
idx="vfoi_geom_not_null_idx"
idx_exists=$(exists_index_psql -d $db_public -u $user -s $prod_schema -i $idx)

if [[ $idx_exists == "f" ]]; then
	echoi $e -n "- Indexing column 'geom' in table vfoi in schema '$prod_schema'..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema -f $DIR_LOCAL/sql/index_vfoi_geom.sql
	source "$DIR/includes/check_status.sh"	
fi

echoi $e -n "- Creating schema '$dev_schema'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_schema.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating & populating table species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v adb_schema=$prod_schema -f $DIR_LOCAL/sql/create_species.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating temp table observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v adb_schema=$prod_schema -f $DIR_LOCAL/sql/create_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating geometry column in observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/add_geometry_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating & populating table observations_union..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_observations_union.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Adjusting permissions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/permissions.sql
source "$DIR/includes/check_status.sh"	

############################################################
# Export dumpfile of schema from public db to geombien
############################################################

echoi $e "Copying schema '$dev_schema' from '$db_public' to '$db_geom':"

# Compose dumpfile name
dumpfilename=$dev_schema".sql"
dumpfile=$data_dir_local"/"$dumpfilename

# Dump schema from source database
echoi $e -n "- Creating dumpfile of schema '$dev_schema' from db '$db_public'..."
pg_dump -U $user -n $dev_schema $db_public > $dumpfile
source "$DIR/includes/check_status.sh"	

# Edit dumpfile
echoi $e -n "- Editing dumpfile..."
SEARCH="postgis."
REPLACE="public."
sed -i.bak -e "s/$SEARCH/$REPLACE/g" $dumpfile
source "$DIR/includes/check_status.sh"	

# Drop development schema in target database if it already exists
sch_exists=$(exists_schema_psql -d $db_geom -u $user -s $dev_schema )
if [[ $sch_exists == "t" ]]; then
	echoi $e -n "- Dropping previous schema $dev_schema in database db_geom..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_geom --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema CASCADE"
	source "$DIR/includes/check_status.sh"	
fi

# Restore
# The bit at the end "> /dev/null 2 >> log.txt" prevents screen echo
echoi $e -n "- Restoring schema '$dev_schema' to db '$db_geom'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user --set ON_ERROR_STOP=1 -q $db_geom < $dumpfile > /dev/null 2 >> log.txt
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Move both tables to production
######################################################

echoi $e "Moving completed tables to production:"

echoi $e -n "-- Database '$db_private..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v prod_schema=$prod_schema_adb_private -f $DIR_LOCAL/sql/ou_move_to_production.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Database '$db_public..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v prod_schema=$prod_schema_adb_public -f $DIR_LOCAL/sql/ou_move_to_production.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Database '$db_geom'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_geom --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v prod_schema=$prod_schema_geom -f $DIR_LOCAL/sql/ou_move_to_production.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Delete development schemas
# CASCADE not necessary as schemas should be empty. 
# This is safer.
######################################################

echoi $e "Removing development schemas:"

echoi $e -n "- Database '$db_private..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema "
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Database '$db_public..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema "
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Database '$db_geom..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_geom --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema "
source "$DIR/includes/check_status.sh"	

######################################################
# Update database version
######################################################

if [[ $update_db_verson == "true" ]]; then
	echoi $e "Updating database version to '$db_version':"

	echoi $e -n "- Database '$db_private..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_private -v db_version=$db_version -v version_comments=$version_comments -f $DIR_LOCAL/sql/update_db_version.sql
	source "$DIR/includes/check_status.sh"	

	echoi $e -n "- Database '$db_public..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -v db_version=$db_version -v version_comments=$version_comments -f $DIR_LOCAL/sql/update_db_version.sql
	source "$DIR/includes/check_status.sh"	
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
#!/bin/bash

#########################################################################
# Purpose:	Copies development analytical schema from private to public
#	database.
#
# Warning: May need to run as postgres, depending on the permission
#	settings required for restoring the dumpfile.
#
# Note: Schemas MUST have the same name in both databases
# 	Need to change this by editing dumpfile to allow different 
#	schema name in public database. todo!
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

# Trigger sudo password request.
sudo pwd >/dev/null

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

dev_schema=$dev_schema_adb_private

# Compose dumpfile name
dumpfilename=$dev_schema"_private.sql"
dumpfile=$data_dir_local"/"$dumpfilename





### TEMP ####
echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# Start comment block
: <<'COMMENT_BLOCK_1'

############################################################
# Export dumpfile of analytical schema from private db
############################################################

# Check source schema exists before starting
sch_exists=$(exists_schema_psql -u $user -d $db_private -s $dev_schema)
if [[ $sch_exists == "f" ]]; then
	echo "ERROR: source schema '$dev_schema' doesn't exist in db '$db_private'!"
	exit 1
fi

# Dump schema from source databse
echoi $e -n "- Creating dumpfile of schema '$dev_schema' in db '$db_private'..."
# pg_dump -U $user -n $dev_schema $db_private > $dumpfile
sudo -u postgres pg_dump -n $dev_schema $db_private > $dumpfile
source "$DIR/includes/check_status.sh"	
echoi $e "-- Saved to: $dumpfile"

# End comment block
COMMENT_BLOCK_1
### TEMP ####





: <<'COMMENT_BLOCK_2'
# Omit this next step as separate postgis schema now exists in public adb
# Remove completely if everything works properly

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

echoi $e -n "- Editing dumpfile..."
sed -i -e 's/postgis./public./g' $dumpfile
source "$DIR/includes/check_status.sh"	

COMMENT_BLOCK_2

############################################################
# Import dumpfile to public db
############################################################

# Drop development schema in public database if it already exists
sch_exists=$(exists_schema_psql -u $user -d $db_public -s $dev_schema )
if [[ $sch_exists == "t" ]]; then
	echoi $e -n "- Dropping previous development analytical schema in public database..."
# 	sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema CASCADE"
	sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_public --set ON_ERROR_STOP=1 -q -c "DROP SCHEMA IF EXISTS $dev_schema CASCADE"
	source "$DIR/includes/check_status.sh"	
fi

# Create empty development schema in the target database
# Run as postgres, not user bien
echoi $e -n "- Restoring schema '$dev_schema' to db '$db_public'..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q $db_public < $dumpfile > /dev/null >> $tmplog
# sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -U $user --set ON_ERROR_STOP=1 -q $db_public < $dumpfile > /dev/null >> $tmplog
#PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q $db_public < $dumpfile > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
#rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
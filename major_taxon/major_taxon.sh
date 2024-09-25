#!/bin/bash

#########################################################################
# Purpose: Imports table ncbi_taxa and populates column major_taxon
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo; echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Source database:	$src_db
	Source table:		$src_tbl
	Target database:	$db_private
	Target schema:		$dev_schema
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Import table from source database
######################################################

echoi $e "- Copying table '$src_tbl' from db '$src_db' to schema '$dev_schema' in db '$db_private':"

# Check if source database exists
if ! psql -lqt | cut -d \| -f 1 | grep -qw $src_db; then
	echo; echo "ERROR: Database '$src_db' missing"; echo 
	exit 1
fi

# Check if table exists
exists_tbl=$(exists_table_psql -u $user -d $src_db -s public -t $src_tbl)
if [ $exists_tbl == "f" ]; then
	echo; echo "ERROR: Table '$src_db.$src_tbl' missing"; echo; exit 1
fi

# Dump table from source databse
echoi $e -n "-- Creating dumpfile..."
dumpfile=$data_dir_local"/"$src_tbl".sql"
pg_dump -U $user -t $src_tbl $src_db > $dumpfile
source "$DIR/includes/check_status.sh"	

# Replace schema references. Be very conservative to avoid 
# corrupting data which matches schema name 
# Recommend stopping first time prior to point to inspect dumpfile
# to be sure that substitutions are correct
# NOTE USE OF DOUBLE QUOTES! VARIABLE $dev_schemaIS NOT TRANSLATED IF
# SINGLE QUOTES USED
echoi $e -n "-- Editing dumpfile..."
sed -i -e "s/public, pg_catalog/$dev_schema/g" $dumpfile
sed -i -e "s/Schema: public/Schema: $dev_schema/g" $dumpfile
sed -i -e "s/public.$src_tbl/$dev_schema.$src_tbl/g" $dumpfile 
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "-- Importing table from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $dev_schema.$src_tbl"
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_private < $dumpfile > /dev/null >> $tmplog
#source "$DIR/includes/check_status.sh"	

#echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Update major taxon field in tnrs table
######################################################

echoi $e "- Populating column \"major_taxon\" in table \"tnrs\":"

echoi $e -n "-- Adding columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/add_cols.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Updating \"major_taxon\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_major_taxon.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Correcting \"major_taxon\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/correct_major_taxon.sql
source "$DIR/includes/check_status.sh"

######################################################
# Populate major taxon field in main tables
######################################################

echoi $e "- Making changes to related records in remaining tables:"

echoi $e -n "-- Indexing major tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/major_tables_create_indexes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Deleting majority of non-embryophyte observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/delete_bad.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Updating taxon information for remaining non-embryophytes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_non_embryophytes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Dropping indexes on major tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/major_tables_drop_indexes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
#!/bin/bash

#########################################################################
# Purpose: Import new data, injecting directly into analytical database
#
# Main script imports all new sources. To import a source separately, 
# 	see script for that source (import_[source_name].sh, also in this
# 	directory.
#
# Requirements: custom function f_empty2null(), installed using module 
# 	install_dependencies
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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

# Pseudo error log, to absorb screen echo during import
tmplog="/tmp/tmplog.txt"
echo "Error log
" > $tmplog

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$pname_local'"

######################################################
# Import raw data
######################################################

echoi $e "- Creating raw data tables:"

# metadata table
echoi $e -n "-- Generic..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

# main data table
echoi $e -n "-- Source-specific..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

echoi $i "- Importing raw data to table:"
# Data
arr_tbls_raw=($tbls_raw)	# Turn table names into array
x=0		# Start the array element counter
for datafile in $files_raw; do
	tbl=$src"_"${arr_tbls_raw[$x]}
	echoi $i -n "-- '$datafile' --> $tbl..."
	sql="\COPY $tbl FROM '${data_dir_local}/${datafile}' DELIMITER ',' CSV NULL AS 'NULL' HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"
	x=$((x + 1))
done

# Metadata
tbl="datasource_raw"
datafile=$metadata_raw
echoi $i -n "-- '$datafile' --> $tbl..."

# Import full file
sql="\COPY $tbl FROM '${data_dir_local}/${datafile}' DELIMITER ',' CSV NULL AS 'NULL';"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"


######################################################
# Corrections that must be done on raw data, if any
######################################################

echoi $e "- Correcting raw data:"

echoi $e -n "-- Adding columns to harmonize table schemas..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/correct_raw.sql
source "$DIR/includes/check_status.sh"

echoi $e "-- Setting empty strings to null:"
for tbl_basename in $tbls_raw; do
	tbl=$src"_"$tbl_basename
	echoi $e -n "--- $tbl..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.${tbl}')" > /dev/null >> $tmplog
	source "$DIR/includes/check_status.sh"
done

######################################################
# Load raw data to staging tables
######################################################

echoi $e -n "- Creating staging tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_staging.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Loading staging tables:"

echoi $e -n "-- datasource_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/load_staging_datasource.sql
source "$DIR/includes/check_status.sh"

# Construct LIMIT clause if applicable (for testing only)
if [ $use_limit = "true" ]; then
	sql_limit=$sql_limit_global
else
	sql_limit=""
fi

echoi $e "-- vfoi_staging from table:"
for tbl_basename in $tbls_raw; do
	tbl=$src"_"$tbl_basename
	echoi $e -n "--- $tbl..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src=$src -v tbl="$tbl"  -v limit="$sql_limit" -f $DIR_LOCAL/sql/load_staging_vfoi.sql
	source "$DIR/includes/check_status.sh"
done

######################################################
# Correct data in staging tables
######################################################

echoi $e "- Correcting staging tables:"

echoi $e -n "-- view_full_occurrence_individual..."
# Insert corrections here
echoi $e "no corrections needed"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
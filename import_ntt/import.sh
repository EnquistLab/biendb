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

# Extract the CSV files
echoi $e "- Extracting MS Access tables to CSVs ($access_db):"
arr_tblnames_orig=($tblnames_orig)	# Turn table names into array
x=0		# Start the array element counter
for csv_basename in $csv_basenames; do
	tbl=${arr_tblnames_orig[$x]}
	datafile=$csv_basename".csv"
	echoi $i -n "-- $tbl --> '$datafile'..."
	mdb-export $data_dir_local/$access_db $tbl > $data_dir_local/csv/$datafile
	source "$DIR/includes/check_status.sh"
	x=$((x + 1))
done

echoi $i "- Importing raw data to table:"
# Data
for csv_basename in $csv_basenames; do
	tbl=$src"_"$csv_basename"_raw"
	datafile=$csv_basename".csv"
	echoi $i -n "-- '$datafile' --> $tbl..."
	sql="\COPY $tbl FROM '${data_dir_local}/csv/${datafile}' DELIMITER ',' CSV NULL AS 'NULL' HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"
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

echoi $e -n "-- Creating indexes and foreign key constraints..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/correct_raw.sql
source "$DIR/includes/check_status.sh"

# Import full file
echoi $e "-- Setting empty strings to null:"
tbl_basenames="
species
areas
sources
"
for tbl_basename in $tbl_basenames; do
	tbl_raw=$src"_"$tbl_basename"_raw"
	echoi $e -n "--- $tbl_raw..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.${tbl_raw}')" > /dev/null >> $tmplog
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

echoi $e -n "-- vfoi_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src=$src -v tbl="$tbl_raw"  -v limit="$sql_limit" -f $DIR_LOCAL/sql/load_staging_vfoi.sql
source "$DIR/includes/check_status.sh"

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
#!/bin/bash

#########################################################################
# Purpose: Imports complete raw trait data from CSV to table agg_traits,
#	then extract taxon occurrences (non-null taxon + geocoordinates) and 
# 	appends to table view_full_occurrence_individual
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Enable the following for strict debugging only:
#set -e

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

echoi $e "Executing module '$pname_local'"

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

#########################################################################
# Import raw data
#########################################################################

# Create main traits table and raw trait data table

echoi $e "- Creating tables:"

# metadata table
echoi $e -n "-- datasource_raw..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

# raw data table
echoi $e -n "-- $tbl_raw..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

# Main traits table
echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_agg_traits.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Importing data:"

# Data
# Import as comma-delimited file
tbl=$tbl_raw
datafile=$data_raw
echoi $i -n "-- '$datafile' --> $tbl..."

if [ $use_limit = "true" ]; then 
	# Import subset of records (development only)
	head -n $recordlimit $data_dir_local/$datafile | psql $db_private $user -q -c "COPY ${dev_schema}.${tbl} FROM STDIN CSV HEADER DELIMITER ',' NULL 'NA' QUOTE '\"'"
else
	# Import full file
	sql="\COPY $tbl FROM '${data_dir_local}/${datafile}' CSV HEADER DELIMITER ',' NULL 'NA' QUOTE '\"';"
	#echo; echo "sql:"; echo $sql; echo
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
fi
source "$DIR/includes/check_status.sh"

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
# Correct raw data
# Corrections that must be done on raw data, if any
######################################################

echoi $e -n "- Altering schema of table \"traits_raw\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/alter_raw.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Correcting raw data:"

echoi $e -n "-- Setting empty strings to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.traits_raw')" > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

echoi $i -n "-- Correcting misc errors..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/correct_raw.sql
source "$DIR/includes/check_status.sh"	

# Create not null indexes to speed up the next three operations
echoi $i "-- Creating not null index on column:"
cols="
elevation_m
visiting_date
observation_date
"
curr_tbl=$tbl_raw
for curr_col in $cols; do
	echoi $e -n "--- $curr_col..."
	idx=$curr_tbl"_"$curr_col"_notnull_idx"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$curr_tbl -v col=$curr_col -v idx=$idx -f $DIR/import/sql/add_index_notnull.sql
	source "$DIR/includes/check_status.sh"	
done

# Parse elevation
echoi $i -n "-- Parsing and correcting \"elevation_m\"..."
tbl=$tbl_raw
elev_col="elevation_m"	# verbatim (text) elevation column
elev_mean_col="elev_mean"	# integer mean elevation column
elev_max_col="elev_max"	# integer max elevation column
elev_min_col="elev_min"	# integer min elevation column
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$tbl_raw -v elev_col=$elev_col -v elev_mean_col=$elev_mean_col -v elev_max_col=$elev_max_col -v elev_min_col=$elev_min_col -f $DIR/import/sql/correct_raw_elev.sql
source "$DIR/includes/check_status.sh"	

echoi $i "-- Parsing and correcting dates:"

# Parse visiting date
tbl=$tbl_raw			# Name of table (for concatenation, below)
col_date="visiting_date" # Name of original concatenated date column
y_col="vdate_yr"			# Name of integer year column
m_col="vdate_mo"			# Name of integer month column
d_col="vdate_dy"			# Name of integer day column
col_date_idx=$tbl"_"$col_date"_idx"	# Name of index on original date column
y_idx=$tbl"_"$y_col"_idx"	# Name of index on integer year column
m_idx=$tbl"_"$m_col"_idx"	# Name of index on integer month column
d_idx=$tbl"_"$d_col"_idx"	# Name of index on integer day column
echoi $e -n "--- \"$col_date\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$tbl_raw -v col_date=$col_date -v y_col=$y_col -v m_col=$m_col -v d_col=$d_col -v col_date_idx=$col_date_idx -v y_idx=$y_idx -v m_idx=$m_idx -v d_idx=$d_idx -f $DIR/import/sql/correct_raw_ymd.sql
source "$DIR/includes/check_status.sh"

# Parse observation date
col_date="observation_date" # Name of original concatenated date column
y_col="obsdate_yr"			# Name of integer year column
m_col="obsdate_mo"			# Name of integer month column
d_col="obsdate_dy"			# Name of integer day column
col_date_idx=$tbl"_"$col_date"_idx"	# Name of index on original date column
y_idx=$tbl"_"$y_col"_idx"	# Name of index on integer year column
m_idx=$tbl"_"$m_col"_idx"	# Name of index on integer month column
d_idx=$tbl"_"$d_col"_idx"	# Name of index on integer day column
echoi $e -n "--- \"$col_date\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$tbl_raw -v col_date=$col_date -v y_col=$y_col -v m_col=$m_col -v d_col=$d_col -v col_date_idx=$col_date_idx -v y_idx=$y_idx -v m_idx=$m_idx -v d_idx=$d_idx -f $DIR/import/sql/correct_raw_ymd.sql
source "$DIR/includes/check_status.sh"

######################################################
# Load raw data to main traits table
######################################################

echoi $i -n "- Inserting raw data to main traits table (agg_traits)..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/load_agg_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Correcting name_submitted..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/correct_name_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $i "-- Dropping not null indexes:"
cols="
elevation_m
visiting_date
observation_date
"
curr_tbl=$tbl_raw
for curr_col in $cols; do
	echoi $e -n "--- $curr_col..."
	idx=$curr_tbl"_"$curr_col"_notnull_idx"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v idx=$idx -f $DIR/import/sql/drop_index.sql
	source "$DIR/includes/check_status.sh"	
done

######################################################
# Load trait observation to staging tables
######################################################

echoi $e -n "- Creating staging tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_staging.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Loading staging tables:"

echoi $e -n "-- datasource_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/load_staging_datasource.sql
source "$DIR/includes/check_status.sh"

# Load to vfoi any 'new' georeferenced trait observations, not
# previously extracted from vfoi
echoi $e -n "-- vfoi_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src=$src -f $DIR_LOCAL/sql/load_staging_vfoi.sql
source "$DIR/includes/check_status.sh"

######################################################
# Correct data in staging tables
######################################################

echoi $e "- Correcting staging tables:"

echoi $e -n "-- view_full_occurrence_individual..."
# Insert corrections here
echoi $e "no corrections needed"

#currscript=`basename "$0"`; echo "EXITING script $currscript"; exit 0

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

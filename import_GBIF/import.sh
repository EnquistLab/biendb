#!/bin/bash

#########################################################################
# Purpose: Import new data, injecting directly into analytical database
#
# Main script imports all new sources. To import a source separately, 
# 	see script for that source (import_[source_name].sh, also in this
# 	directory.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

# Set parent directory & source if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
	src="GBIF"	# Must set here if not supplied by master script
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

# Set final limit parameter
source "$DIR/includes/set_limit_local.sh"	

######################################################
# Prepare list of primary sources to be removed 
# from this provider
######################################################

# Form SQL of source codes
psrc_list=""
for primary_src in $primary_sources; do
	psrc_list=$psrc_list"'"$primary_src"',"
done
psrc_list="${psrc_list::-1}"

######################################################
# Set local source parameter and echo custom 
# confirmation message. 
#
# Only done if running as standalone script 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Record limit display
	if [[ "$limit_local" == "false" ]]; then
		limit_disp="false"
	else 
		limit_disp="true (limit="$recordlimit")"
	fi

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Source:		'$src'
	Data directory: $data_dir_local
	Occurrence file: $data_raw
	Database:	$db_private
	Schema:		$dev_schema
	Use record limit?		$limit_disp
	Omit datasets:	$psrc_list

EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$pname_local'"

######################################################
# Import raw data
######################################################

echoi $e "- Creating raw data tables:"
# Execute create raw tables SQL script in generic import directory
echoi $e -n "-- Generic..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

# Execute create raw tables SQL script in source import directory
echoi $e -n "-- Source-specific..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/create_raw.sql
source "$DIR/includes/check_status.sh"

echoi $i "- Importing raw data to table:"

# Data
tbl=$tbl_raw
datafile=$data_raw
echoi $i "-- '$datafile' --> $tbl:"

echoi $i -n "--- Importing data..."
if [[ "$limit_local" == "true" ]]; then 	
	echoi $i -n "[using recordlimit=$recordlimit]..."
	# Import subset of records (development only)
	head -n $recordlimit $data_dir_local/$datafile | psql $db_private $user -q -c "COPY ${dev_schema}.${tbl} FROM STDIN WITH (FORMAT 'text', NULL '' )"
else
	# Import full file
	sql="\COPY $tbl FROM '${data_dir_local}/${datafile}' WITH (FORMAT 'text', NULL '');"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
fi
source "$DIR/includes/check_status.sh"

# This step needed because can only use HEADER with CSV option, and 
# tab-version of CSV not working
echoi $e -n "--- Removing header..."
sql="DELETE FROM ${tbl_raw} WHERE ctid=(SELECT ctid FROM ${tbl_raw} ORDER BY ctid LIMIT 1);"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

######################################################
# Corrections done on raw data, if any
######################################################

# Add additional validation & scrubbing fields to raw data table
echoi $e -n "- Altering raw data table structure..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/alter_raw.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Processing dates:"

echoi $e -n "-- Populating integer Y, M, D columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/populate_raw_ymd.sql
source "$DIR/includes/check_status.sh"

##################################
# Correct integer Y, M, D columns 
# for eventDate
##################################
y_col="eventdate_yr"			# Name of integer year column
m_col="eventdate_mo"			# Name of integer month column
d_col="eventdate_dy"				# Name of integer day column
y_idx=$tbl"_"$y_col"_idx"	# Name of index on integer year column
m_idx=$tbl"_"$m_col"_idx"	# Name of index on integer month column
d_idx=$tbl"_"$d_col"_idx"	# Name of index on integer day column

echoi $e -n "-- Correcting dates from column \"eventDate\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$tbl_raw -v y_col=$y_col -v m_col=$m_col -v d_col=$d_col -v y_idx=$y_idx -v m_idx=$m_idx -v d_idx=$d_idx -f $DIR/import/sql/correct_ymd.sql
source "$DIR/includes/check_status.sh"

##################################
# Correct integer Y, M, D columns 
# for dateidentified
##################################
y_col="dateidentified_yr"			# Name of integer year column
m_col="dateidentified_mo"			# Name of integer month column
d_col="dateidentified_dy"				# Name of integer day column
y_idx=$tbl"_"$y_col"_idx"	# Name of index on integer year column
m_idx=$tbl"_"$m_col"_idx"	# Name of index on integer month column
d_idx=$tbl"_"$d_col"_idx"	# Name of index on integer day column

echoi $e -n "-- Correcting dates from column \"dateIdentified\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$tbl_raw -v y_col=$y_col -v m_col=$m_col -v d_col=$d_col -v y_idx=$y_idx -v m_idx=$m_idx -v d_idx=$d_idx -f $DIR/import/sql/correct_ymd.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Indexing raw data..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/index_raw.sql
source "$DIR/includes/check_status.sh"

######################################################
# Load raw data to staging tables
######################################################

echoi $e -n "- Creating staging tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/import/sql/create_staging.sql
source "$DIR/includes/check_status.sh"

echoi $e "- Loading staging tables:"

echoi $e -n "-- vfoi_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src=$src -v tbl_raw=$tbl_raw -v psrc_list="$psrc_list" -f $DIR_LOCAL/sql/load_staging_vfoi.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- datasource_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/load_datasource_staging.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Populating FK to datasource_staging..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/update_datasource_fks.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Dropping raw data indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/drop_indexes_raw.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



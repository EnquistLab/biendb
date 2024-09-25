#!/bin/bash

#########################################################################
# Purpose: Dump of vfoi for range modeling to file, using revised WHERE clause
# 
# Note: file is tab-delimited
# 
# See: http://bien.nceas.ucsb.edu/bien/biendata/bien-4/bien-4-range-modelling/
# Date of request: 25 June 2019
# Script start date: 26 June 2019
# Data extract completion date: 
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echoi $e; echoi $e "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Load external parameters & functions & confirm operation
# 
# IF called by master script in parent directory, loads 
# local parameters only. If running standalone, loads
# all parameters (global and local) plus functions and 
# options. You may also set custom parameters, if any,
# in next section
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

# Set parent directory if running independently & suppress main message
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

######################################################
# Custom parameters
#  
# Parameters defined here will over-ride any parameters
# set previous in local (params.sh) and global 
# (../params.sh) parameters files
######################################################

# Db & schemas
db="vegbien"
src_sch="analytical_db"		# Source schema
target_sch="data_requests"	# Target schema where table will be created

# Target directory where files will be written
data_dir="/home/boyle/bien3/data_requests/cmerow"

# Name of temporary table to be created
temp_tbl="temp_data_dump_for_Cory_20190626"

# Name and location of file to which contents of 
# temp table will be dumped
outfile_name="bien_4.1.1_data_dump_for_Cory_20190626.txt"
outfile=$data_dir"/"$outfile_name

# SQL LIMIT parameter for testing with sample
# Set to empty string "" for production
limit=""
#limit=" LIMIT 12 "

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

# Display of limit param for conf message
limit_disp="$(echo -e "${limit}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [[ $limit == "" ]]; then limit_disp="(none)"; fi

# Change message code as needed
if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:			$db
	Source schema:			$src_sch
	Target schema:			$target_sch
	Temporary table:		$temp_tbl
	Output directory:		$data_dir
	Output file:			$outfile_name
	Record limit:			$limit_disp
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"; echoi $e ""

#########################################
# Custom code here
#########################################

echoi $e "Creating data extract:"

# Run query, saving results as new temp table
echoi $e -n "- Dumping query results to temp table $tbl_temp..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v src_sch=$src_sch -v target_sch=$target_sch -v tbl=$temp_tbl -v limit="$limit" -f $DIR_LOCAL/sql/data_dump_for_Cory_20190626.sql
source "$DIR/includes/check_status.sh"  

# Dump temp table to file
# Note write to STDOUT to avoid having to run as sudo
echoi $e -n "- Dumping temp table to file in output directory..."
sql="COPY (SELECT * FROM ${target_sch}.${temp_tbl} ) TO STDOUT WITH ( FORMAT csv, DELIMITER E'\t', HEADER )" 
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -c "$sql" > $outfile
source "$DIR/includes/check_status.sh"

echoi $e -n "- Compressing file to archive..."
zip -jq $outfile".zip" $outfile 
source "$DIR/includes/check_status.sh"

echoi $e -n "- Deleteing uncompressed file..."
rm $outfile
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
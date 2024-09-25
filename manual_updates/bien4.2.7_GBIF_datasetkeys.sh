#!/bin/bash

#########################################################################
# Purpose: Adds column datasetkey to analytical tables vfoi and 
# analytical_stem and populates it by batches by joining on the original
# raw GBIF occurrence tabled
# 
# BIEN DB hotfix update version 4.2.7
#
# NOTE: 
#	You will need to run this script four times: once for each of the
# 	two main analytical tables (view_full_occurrence_individual and
#	analytical_stem) in each of the two databases.
#
# Date: 20 Oct 2022
# Author: Brad Boyle (bboyle@email.arizona.edu)
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

# Test only (t/f)
# If "t", will extract a sample of vfoi to table "vfoi_test" and use that
testing="f"

# Resume? (t/f)
# If "f", adds columns datasetkey and updated, first dropping if they already exist
# If "t", skips drop/add of new columns, keeping any records already updated
resume="t"

# rows per update batch
BATCHSIZE=10000

# Record limit of test table
# Ignored if using actual vfoi
TESTLIMIT=1000

# Db and schema to validate
DB="vegbien"; SCH="analytical_db"
# DB="public_vegbien"; SCH="public"

# Table to alter/update + name of primary key
# Pipe-delimited
# Choose one per run
#TBLPK="analytical_stem|analytical_stem_id"
TBLPK="view_full_occurrence_individual|taxonobservation_id"

# Amount in GB of temporary working memory increase for queries 
# Format: "##GB"
# Set to "" to disable
WORK_MEM="16GB"
WORK_MEM=""

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

# Any parameters over-ridden by the external parameters files
# can be reset here if necessary


######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [ "$testing" == "t" ]; then
	TBLPK="vfoi_test|taxonobservation_id"
	runtype="test"
	recordlimit=$TESTLIMIT
else
	runtype="production"
	recordlimit="All"
fi

if [ "$WORK_MEM" == "" ]; then
	workmem_disp="Default"
else 
	workmem_disp=$WORK_MEM
fi


TBL=$(echo "$TBLPK"|cut -d "|" -f 1)
PK=$(echo "$TBLPK"|cut -d "|" -f 2)


if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:	$DB
	User:		$user
	Schema:		$SCH
	Table:		$TBL
	Primary key:	$PK
	Run type:	$runtype
	Batch size:	$BATCHSIZE
	Record limit:	$recordlimit
	Resume:		$resume
	WORK_MEM:	$workmem_disp
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing update '$local_basename'"
echoi $e " "

# Prepare working memory SET/RESET commands
if [ "$WORK_MEM" == "" ]; then
	WORK_MEM_SET=""
	WORK_MEM_RESET=""
else
	WORK_MEM_SET="SET work_mem = '${WORK_MEM}';"
	WORK_MEM_RESET="RESET work_mem;"
fi

# For testing only
if [ "$testing" == "t" ]; then
	echoi $e -n "Creating table \"$TBL\"..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $DB --set ON_ERROR_STOP=1 -q -v TESTLIMIT="$TESTLIMIT" -f $DIR_LOCAL/sql/bien4.2.7_GBIF_datasetkeys_create_vfoi_test.sql
	source "$DIR/includes/check_status.sh"  
fi

if [ "$resume" == "f" ]; then
	# Add columns datasetkey & updated to target table
	# Will be dropped and re-added if they already exist
	echoi $e -n "Adding columns to table \"$TBL\"..."
	IDX_NAME="${TBL}_updated_idx"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $DB --set ON_ERROR_STOP=1 -q -v SCH="$SCH" -v TBL="$TBL" -v IDX_NAME="$IDX_NAME" -v WORK_MEM_SET="$WORK_MEM_SET" -v WORK_MEM_RESET="$WORK_MEM_RESET" -f $DIR_LOCAL/sql/bien4.2.7_GBIF_datasetkeys_add_cols.sql
	source "$DIR/includes/check_status.sh"  
fi

# echoi $e -n "Indexing column \"catalog_number\" in table \"$TBL\"..."
# IDX_NAME="${TBL}_catalog_number_idx"
# PGOPTIONS='--client-min-messages=warning' psql -U $user -d $DB --set ON_ERROR_STOP=1 -q -v SCH="$SCH" -v TBL="$TBL" -v IDX_NAME="$IDX_NAME" -f $DIR_LOCAL/sql/bien4.2.7_GBIF_datasetkeys_index.sql
# source "$DIR/includes/check_status.sh"  

##################################################
# Set parameters for batch processing
##################################################

# Get total number of records to process
OBS=$( psql -U $user -d $DB -t -q -c "select count(*) from ${SCH}.${TBL} where updated is null" )
OBS=$(trim_ws ${OBS})

# Estimate number of batches, increasing to next higher integer if a fraction
BATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")
BATCHESdec=$(bc <<< "scale=1;$OBS/$BATCHSIZE")
INTBATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")".0"
if [ $BATCHESdec != $INTBATCHES ]; then
	BATCHES=$(bc <<< "scale=0;($OBS/$BATCHSIZE)+1")
fi

COUNTER=1
tottime=0

echoi $e "Processing $OBS records in batches of $BATCHSIZE:"
echoi $e -r "- 1 of $BATCHES"

##################################################
# Process the table by batches
##################################################
someleft='t'

while [ "$someleft" == "t" ]; do 

	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $DB --set ON_ERROR_STOP=1 -q -v SCH="$SCH" -v TBL="$TBL" -v PK="$PK" -v BATCHSIZE="$BATCHSIZE" -v WORK_MEM_SET="$WORK_MEM_SET" -v WORK_MEM_RESET="$WORK_MEM_RESET" -f $DIR_LOCAL/sql/bien4.2.7_GBIF_datasetkeys_update.sql

	# Report time for this batch and average time per batch
	# and reset the start time
	# Each message replaces previous to avoid clutter
	elapsed=$(etime $prev); prev=`date +%s%N`
	tottime=$(bc <<< "scale=1;$tottime+$elapsed")
	avgtime=$(bc <<< "scale=2;$tottime/$COUNTER")
	echoi $e -r "- $COUNTER of $BATCHES ($elapsed sec; avg: $avgtime sec/batch)       "

	# Reset or increment counters and indexes
	lastCOUNTER=$COUNTER
	let COUNTER=COUNTER+1
	
	someleft=$( psql -U $user -d $DB -t -q -c "select exists (SELECT ${PK} FROM ${SCH}.${TBL} WHERE updated IS NULL LIMIT 1)" )
	someleft="$(echo -e "${someleft}" | tr -d '[:space:]')"

#echo "someleft: '"$someleft"'                      "

done

# Echo total time for all batches
echoi $e "- $lastCOUNTER of $BATCHES (avg: $avgtime sec/batch; total: $tottime sec)       "

echoi $e -n "Finishing up..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $DB --set ON_ERROR_STOP=1 -q -v SCH="$SCH" -v TBL="$TBL" -f $DIR_LOCAL/sql/bien4.2.7_GBIF_datasetkeys_finish.sql
source "$DIR/includes/check_status.sh"  

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
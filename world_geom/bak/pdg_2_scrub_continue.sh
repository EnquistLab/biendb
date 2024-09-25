#!/bin/bash


#########################################################################
#########################################################################
# WARNING!!!
#
# One-time hack to resume processing.
# Delete this script when finished!!!
#########################################################################
#########################################################################


#########################################################################
# Purpose: Performs point-in-polygon validation of geocoordinates by 
#	joining to declared political divisions. 
#  
# Notes: 
#	1. This script and pdg_1_prepare.sh are provision solutions only. To be
# 		replaced by single script, pdg.sh, which will use standalone pdg  
#		scripts in separate repository and external pdg reference database.
#	2. Run pdg_1_prepare.sh first.
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
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Target table display
	tbls_disp=""
	if [[ "$target_tbls" == "" ]]; then
		tbls_disp="[No tables specified]"
	else
		for target_tbl in $target_tbls; do
			tbls_disp=$tbls_disp", "$target_tbl
		done
		tbls_disp="${tbls_disp/', '/''}"
	fi

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:	$db_private
	Schema:		$dev_schema
	Target tables:	$tbls_disp
	Batch size:	$BATCHSIZE
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

# Loop through each target table
for curr_tbl in $target_tbls; do	# START table loop

	echoi $e "- Processing table: \"$curr_tbl\":"

	############################################################
	# Index JOIN columns of table in preparation for validation
	# Spatial column geom must already be present, populated, and 
	# indexed!!!
	############################################################
	
	# Construct names of primary key and its sequence
	pkey_name=$curr_tbl"_pkey"
	seq_name=$curr_tbl"_"$pk_temp"_seq"




	####################################
	# HACK1. Don't redo PK for vfoi
	####################################
	
	# Create primary key
	exists_col=$(exists_column_psql -u $user -d $db_private -s $dev_schema -t $curr_tbl -c $pk_temp)
	if [ $exists_col == "f" ]; then
	
		if [ "$curr_tbl" == "agg_traits" ]; then
		
			echoi $e -n "-- Adding temporary integer primary key..."
			PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$curr_tbl -v id=$pk_temp -v pkey_name=$pkey_name -v seq_name=$seq_name -f $DIR_LOCAL/sql/add_integer_pk.sql
			source "$DIR/includes/check_status.sh"	
			
		fi
		
	fi

	####################################
	# END HACK1
	####################################



	# Columns to be indexed
	col_list="
	country
	state_province
	county
	"
	
	echoi $e -n "-- Indexing political division columns..."
	for col in $col_list; do
		idx_name=$curr_tbl"_"$col"_idx"
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$curr_tbl -v col=$col -v idx_name=$idx_name -f $DIR_LOCAL/sql/add_index_tbl_col.sql
	done
	source "$DIR/includes/check_status.sh"	

	##################################################
	# Make political division lists for subset loops
	##################################################

	# Get min and max id values, and total number of records
	MIN_ID=$( psql -U ${user} -d ${db_private} -t -c "select min($pk_temp) from $dev_schema.$curr_tbl" )
	MIN_ID=$(trim_ws ${MIN_ID})
	MAX_ID=$( psql -U ${user} -d ${db_private} -t -c "select max($pk_temp) from $dev_schema.$curr_tbl" )
	MAX_ID=$(trim_ws ${MAX_ID})
	OBS=$( psql -U $user -d $db_private -t -c "select count(*) from $dev_schema.$curr_tbl" )
	OBS=$(trim_ws ${OBS})

	# Estimate number of batches, increasing to next higher integer if a fraction
	BATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")
	BATCHESdec=$(bc <<< "scale=1;$OBS/$BATCHSIZE")
	INTBATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")".0"
	if [ $BATCHESdec != $INTBATCHES ]; then
		BATCHES=$(bc <<< "scale=0;($OBS/$BATCHSIZE)+1")
	fi

	# Set initial values
	FIRST_ID=$MIN_ID
	COUNTER=1
	ACTUALCOUNTER=1
	tottime=0
	
	
	#########################
	# HACK 2
	# Reset FIRST_ID for vfoi only
	#########################
	
	if [ "$curr_tbl" == "view_full_occurrence_individual_dev" ]; then
		FIRST_ID=27300001
		ACTUALCOUNTER=274
	fi
	
	

	echoi $e "-- Processing $OBS records in batches of $BATCHSIZE:"

	##################################################
	# Process the table by batches
	##################################################

	while [  $FIRST_ID -lt $MAX_ID ]; do 
		LAST_ID=$((FIRST_ID + BATCHSIZE))
		
		# Set the batch criterion. MUST end with " AND "
		subset_where=" $pk_temp>=$FIRST_ID AND $pk_temp<=$LAST_ID AND "

		##################################################
		# Run the validation for each political division
		##################################################

		# Country
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v wm_mb="$wm_mb" -v sch=$dev_schema -v target_tbl=$curr_tbl -v ref_tbl="$ref_tbl" -v subset_where="$subset_where" -f $DIR_LOCAL/sql/pdg_country.sql

		# State/province
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v wm_mb="$wm_mb" -v sch=$dev_schema -v target_tbl=$curr_tbl -v ref_tbl="$ref_tbl" -v subset_where="$subset_where" -f $DIR_LOCAL/sql/pdg_state.sql

		# County
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v wm_mb="$wm_mb" -v sch=$dev_schema -v target_tbl=$curr_tbl -v ref_tbl="$ref_tbl" -v subset_where="$subset_where" -f $DIR_LOCAL/sql/pdg_county.sql
		
		##################################################
		# Update is_geovalid
		##################################################
	
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v target_tbl=$curr_tbl  -v subset_where="$subset_where" -f $DIR_LOCAL/sql/is_geovalid.sql

		# Report time for this batch and average time per batch
		# and reset the start time
		# Each message replaces previous to avoid clutter
		elapsed=$(etime $prev); prev=`date +%s%N`
		tottime=$(bc <<< "scale=1;$tottime+$elapsed")
		avgtime=$(bc <<< "scale=2;$tottime/$COUNTER")
		echoi $e -r "--- $COUNTER ($ACTUALCOUNTER) of $BATCHES ($elapsed sec; avg: $avgtime sec/batch)       "
	
		# Reset or increment counters and indexes
		let FIRST_ID=LAST_ID+1
		lastCOUNTER=$COUNTER
		lastACTUALCOUNTER=$ACTUALCOUNTER
		let COUNTER=COUNTER+1
	done

	# Echo total time for all batches
	echoi $e "--- $lastCOUNTER ($lastACTUALCOUNTER) of $BATCHES (avg: $avgtime sec/batch; total: $tottime sec)       "

	############################################################
	# Remove indexes and PK
	############################################################
	
	echoi $e -n "-- Dropping temporary primary key..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl=$curr_tbl -v id=$pk_temp -v pkey_name=$pkey_name -v seq_name=$seq_name -f $DIR_LOCAL/sql/drop_integer_pk.sql
	source "$DIR/includes/check_status.sh"	

	echoi $e -n "-- Dropping temporary indexes..."
	for col in $col_list; do
		idx_name=$curr_tbl"_"$col"_idx"
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v idx_name=$idx_name -f $DIR_LOCAL/sql/drop_index_tbl_col.sql
	done
	source "$DIR/includes/check_status.sh"	

done	# END table loop

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
#!/bin/bash

#########################################################################
# Purpose: Flags observations of individual cultivated plants
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
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
source "$DIR/includes/startup_local.sh"	

# Start error log
echo "Error log
" > /tmp/log.txt

#########################################################################
# Main
#########################################################################

##################################################
# Flag by keywords in locality or specimen 
# description suggestion plant is cultivated
##################################################

echoi $e -n "- Flagging by keywords in locality..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/flag_by_locality.sql
source "$DIR/includes/check_status.sh"	

##################################################
# Flag by coordinates any sites which are close
# to a herbarium (and possibly botanical garden)
# and therefore possibly planted
##################################################

echoi $e "- Flagging by proximity to herbarium:"

echoi $i -n "-- Exporting list of herbarium countries..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -t -c "SELECT DISTINCT country FROM ${dev_schema}.cultobs_herbaria WHERE country IS NOT NULL ORDER BY country" > $data_dir_local_abs/herb_country.txt
source "$DIR/includes/check_status.sh"

# Process by batches, joining by country+state, then the remainder by
# country. This avoids memory overload due to massive SQL cross product
MIN_ID=$( psql -U ${user} -d ${db_private} -t -q -c "select min(cultobs_id) from ${dev_schema}.cultobs" )
MIN_ID=$(trim_ws ${MIN_ID})
MAX_ID=$( psql -U ${user} -d ${db_private} -t -q -c "select max(cultobs_id) from ${dev_schema}.cultobs" )
MAX_ID=$(trim_ws ${MAX_ID})
OBS=$( psql -U ${user} -d ${db_private} -t -q -c "select count(*) from ${dev_schema}.cultobs" )
OBS=$(trim_ws ${OBS})

# Increment batches size if not an integer
	BATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")
	BATCHESdec=$(bc <<< "scale=1;$OBS/$BATCHSIZE")
	INTBATCHES=$(bc <<< "scale=0;$OBS/$BATCHSIZE")".0"
	if [ $BATCHESdec != $INTBATCHES ]; then
		BATCHES=$(bc <<< "scale=0;($OBS/$BATCHSIZE)+1")
	fi

# BATCHSIZE set in params file for this application
FIRST_ID=0
COUNTER=1
tottime=0

echoi $i "-- Processing $OBS records in batches of $BATCHSIZE:"

# Process by batch
while [  $FIRST_ID -lt $MAX_ID ]; do 

	# Get the next sample of observations
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v first_id=$FIRST_ID -v reclimit=$BATCHSIZE -v batch=$COUNTER -f $DIR_LOCAL/sql/get_sample.sql

	# Process by country
	while read COUNTRY; do
		# Only do if country is in sample
		sql_country_exists="SELECT EXISTS ( SELECT cultobs_id FROM ${dev_schema}.cultobs_sample WHERE country='${COUNTRY}') AS a"
		country_exists=`psql -U $user -d $db_private -lqt -c "$sql_country_exists" | tr -d '[[:space:]]'`
	
		if [[ $country_exists == "t" ]]; then 
			#echoi $i "---- Processing country='$COUNTRY'"
			# Dump list of states for this country
			PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -t -c "SELECT DISTINCT state_province FROM ${dev_schema}.cultobs_herbaria WHERE country='${COUNTRY}' AND state_province IS NOT NULL ORDER BY state_province" > $data_dir_local_abs/herb_state.txt
			
			# Process by states within the current country
			while read STATE; do
			
				# Process by state 
				sql_state_exists="SELECT EXISTS ( SELECT cultobs_id FROM ${dev_schema}.cultobs_sample WHERE country='${COUNTRY}' AND state_province='${STATE}') AS a"
				state_exists=`psql -U $user -d $db_private -lqt -c "$sql_state_exists" | tr -d '[[:space:]]'`
	
				if [[ $state_exists == "t" ]]; then 
					#echoi $i "----- State='$STATE'"
					PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v ctry="$COUNTRY" -v state="$STATE" -v herb_min_dist=$HERB_MIN_DIST -f $DIR_LOCAL/sql/flag_by_herbarium_state.sql
		
				fi
			done < $data_dir_local_abs/herb_state.txt
		
			# Process remainder by country, if not matched by 
			# state or state missing
			#echoi $i "----- Country='$COUNTRY'"
			PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v ctry="$COUNTRY" -v herb_min_dist=$HERB_MIN_DIST -f $DIR_LOCAL/sql/flag_by_herbarium_country.sql
		fi
		
	done < $data_dir_local_abs/herb_country.txt
	
	# Report time for this batch and reset the start time
	# Each message replaces the previous one to avoid cluttering
	# the screen display
	elapsed=$(etime $prev); prev=`date +%s%N`
	tottime=$(bc <<< "scale=1;$tottime+$elapsed")
	echoi $i -r "--- Batch $COUNTER of $BATCHES ($elapsed sec)       "
	
	# Reset or increment counters and indexes
	MAX_ID_SAMPLE=$( psql -U ${user} -d ${db_private} -t -q -c "select max(cultobs_id) from ${dev_schema}.cultobs_sample" )
	let FIRST_ID=MAX_ID_SAMPLE+1
	lastCOUNTER=$COUNTER
	let COUNTER=COUNTER+1
done

# Echo total time for all batches
echoi $i "--- Batch $lastCOUNTER of $BATCHES...done (total $tottime sec)       "

echoi $e -n "- Transferring validation results to table cultobs..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v herb_min_dist=$HERB_MIN_DIST -f $DIR_LOCAL/sql/update_cultobs.sql
source "$DIR/includes/check_status.sh"	


######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


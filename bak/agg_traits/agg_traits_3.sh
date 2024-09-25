#!/bin/bash

#########################################################################
# Purpose: Import TNRS results, merges with table agg_traits
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 24 Feb. 2017
# Date first release: 
#########################################################################

# Enable the following for strict debugging only:
#set -e

###########################################################
# Get options
#   -n  No confirm. All interactive warnings suppressed
#   -s  Silent mode. Suppresses screen echo.
#   -m	Send email notification. Must supply valid email 
#		in params file.
###########################################################

i="true"						# Interactive mode on by default
e="true"						# Echo on by default

while [ "$1" != "" ]; do
    case $1 in
        -n | --nowarnings )		i="false"
        						;;
        -s | --silent )			e="false"
        						;;
        -m | --mail )         	m="true"
                                ;;
        * )                     echo "invalid option!"; exit 1
    esac
    shift
done

######################################################
# Load parameters & functions
######################################################

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters file
source "$DIR/$functions_path/params.sh"

# Load db configuration params
if [[ "$db_config_path" == "" ]]; then
	source "$DIR/db_config.sh"
else
	source "$db_config_path/db_config.sh"	
fi

# Load functions
if [[ $functions_path == /* ]]; then
	# Absolute path
	source "$functions_path/functions.sh"
else
	#Relative path
	source "$DIR/$functions_path/functions.sh"
fi

# Set data directory
if [[ $data_dir != /* ]]; then
	#Set relative path
	$data_dir="$DIR/$data_dir"
fi

# Set process name
pname=$pname_3

######################################################
# Confirmation operation
# (interactive mode only)
######################################################

if [[ "$i" = "true" ]]; then
	# Confirm operation
	continue="false"
	echo; echo "Run process '$pname' on database '$db_private'? "
	echo "  Warning: SLOW...Run in 'screen' session!"	
	read -p "Continue? (Y/N): " -r

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		continue="true"
	fi

	if [[ "$continue" == "false" ]]; then
		echo "Operation cancelled"
		exit 0
	fi
fi

######################################################
# Set start time & send email
######################################################

echoi $e ""; echoi $e "------ Begin operation ------"
# Get start time
start=`date +%s%N`
prev=$start

# Send notification if requested
if [[ "$m" = "true" ]]; then
	# Check sure valid email supplied in params file
	checkemail $email; result=$?

	if [[ $result -eq 0 ]]; then
		#Set mail parameters
		starttime=`date`
		process="BIEN notification: process "$pname
		subject=$process" started"
		subjectfail=$process" FAILED!"
		msg="Process PID "$$" started: "$starttime
		msgfail="Process PID "$$" failed at "
		
		echo "$msg" | mail -s "$subject" $email
	elif [[ $result -eq 1 ]]; then
		echo "Bad email (using -m option)"
		#exit 1
	else
		echo "No email supplied (using -m option)"
		#exit 1
	fi
	
fi

#########################################################################
# Import TNRS results 
#########################################################################

# create tnrs results tables
echoi $e -n "Creating TNRS tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_private -f $DIR/sql/create_tnrs_tables.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

# Import parsing results
echoi $i -n "Importing TNRS parsing results..."
sql="\COPY taxon_verbatim_parsed FROM '${data_dir}/data/taxon_verbatim_parsed.txt' DELIMITER E'\t' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_private;
$sql
EOF
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

echoi $i -n "Importing TNRS resolution results..."
sql="\COPY taxon_verbatim_scrubbed FROM '${data_dir}/data/taxon_verbatim_scrubbed.txt' DELIMITER E'\t' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_private;
$sql
EOF
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

#########################################################################
# Merge TNRS results with endangered species table
#########################################################################

echoi $e -n "Preparing table taxon_verbatim_parsed..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_private -f $DIR/sql/prepare_taxon_verbatim_parsed.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

echoi $e -n "Preparing table taxon_verbatim_scrubbed..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_private -f $DIR/sql/prepare_taxon_verbatim_scrubbed.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

# Updating TNRS results to main table
echoi $e -n "Applying TNRS results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_private -f $DIR/sql/apply_tnrs_results.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed seconds)"
fi

######################################################
# Report total elapsed time and exit
######################################################

# Get time elapsed since start
elapsed=$(etime $start)

# Send notification if requested
if [[ "$m" = "true" ]]; then
	endtime=`date`
	subject=$process" completed"
	msg="Process PID "$$" completed: $endtime"
	echo "$msg" | mail -s "$subject" $email
fi

echoi $e "" 
echoi $e "------ Operation complete in $elapsed seconds ------"
echoi $e ""
exit 0
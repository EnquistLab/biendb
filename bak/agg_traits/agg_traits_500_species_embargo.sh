#!/bin/bash

#########################################################################
# Purpose: One time fix. Applies 500-species embargo. Not part of pipeline.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 15 May 2017
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
pname=$pname_500species

######################################################
# Confirmation operation
# (interactive mode only)
######################################################

if [[ "$i" = "true" ]]; then
	# Confirm operation
	continue="false"
	echo; echo "Run process '$pname' on database '$db_public'? "
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

# Start error log to prevent unwanted screen echo
echo "Error log
" > $DIR/log.txt

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
		msg="Process PID "$" started: "$starttime
		msgfail="Process PID "$" failed at "
		
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
# Rebuild metadata tables, then move all tables to production schema
#########################################################################

echoi $i -n "Applying 500 taxon embargo..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=public -f $DIR/sql/apply_embargo_500_species.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
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
	msg="Process PID "$" completed: $endtime"
	echo "$msg" | mail -s "$subject" $email
fi

echoi $e "" 
echoi $e "------ Operation complete in $elapsed seconds ------"
echoi $e ""
exit 0
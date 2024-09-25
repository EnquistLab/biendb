#!/bin/bash

#########################################################################
# Purpose: Indexes completed table agg_traits and copies to production  
#	schema in private database, replacing original table. Backs up  
#	original table to development schema before replacing. Rebuilds  
# 	metadata tables based on agg_traits
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 2 March 2017
# Date first release: 2 March 2017
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
pname=$pname_4

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

# Start error log to prevent unwanted screen echo
echo "Error log
" > $DIR/log.txt

tbl="agg_traits"

#########################################################################
# Rebuild indexes on completed table
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

echoi $i -n "Building remaining indexes on table agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_private -f $DIR/sql/restore_indexes.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

#########################################################################
# Back up original table in core schema
#########################################################################

sql_tbl_exists="SELECT EXISTS ( SELECT table_name FROM information_schema.columns WHERE table_name='$tbl' AND table_schema='$prod_schema_private') AS exists_tbl"
tbl_exists=`psql -U $user -d $db_private -lqt -c "$sql_tbl_exists" | tr -d '[[:space:]]'`

if [[ $tbl_exists == "t" ]]; then

	tbl_bak="agg_traits_bak_$(date +%Y%m%d_%H%M%S)"

	echoi $i -n "Backing up table agg_traits as $tbl_bak in schema $dev_schema_private..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v src_schema=$prod_schema_private -v src_tbl=$tbl -v target_schema=$dev_schema_private -v target_tbl=$tbl_bak -f $DIR/sql/backup_table.sql
	if [[ $? != 0 ]]; then 
		if [[ "$m" = "true" ]]; then
			echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
		fi
		exit $rc
	else
		elapsed=$(etime $prev); prev=`date +%s%N`
		echoi $i "done ($elapsed seconds)"
	fi

fi

#########################################################################
# Replace original table in core schema, then copy over to analytical
# schema, replacing original table if it exists
#########################################################################

echoi $i -n "Moving table '$tbl' to core schema '$prod_schema_private'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v prod_schema=$prod_schema_private  -v dev_schema=$dev_schema_private -f $DIR/sql/replace_original_table_core.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

#########################################################################
# Replace original table in analytical schema by copying from core schema,  
# then rebuild dependent analytical metadata tables #########################################################################
: <<'COMMENT_BLOCK_2'
COMMENT_BLOCK_2

echoi $i -n "Rebuilding table 'taxon_trait'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v src_schema=$prod_schema_private  -v target_schema=$analytical_schema_private -f $DIR/sql/taxon_trait.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

echoi $i -n "Rebuilding table 'trait_summary'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v src_schema=$prod_schema_private  -v target_schema=$analytical_schema_private -f $DIR/sql/trait_summary.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

echoi $i -n "Copying table '$tbl' to analytical schema '$analytical_schema_private'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v src_schema=$prod_schema_private  -v target_schema=$analytical_schema_private -f $DIR/sql/replace_original_table_analytical.sql
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
	msg="Process PID "$$" completed: $endtime"
	echo "$msg" | mail -s "$subject" $email
fi

echoi $e "" 
echoi $e "------ Operation complete in $elapsed seconds ------"
echoi $e ""
exit 0
#!/bin/bash

#########################################################################
# Purpose: Copies table agg_traits from analytical schema in private db  
#	to development schema of public db. Executes embargoes & copies   
#	table to public schema, replacing original table, if any. Rebuilds  
#	dependent metadata tables & updates database version information.
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
pname=$pname_5

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
# Copy table from private database to dev schema of public database
#########################################################################
tbl="agg_traits"
#tbl="taxon_trait_test"	# for testing only

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

echoi $i -n "Copying table '$tbl' from '$db_private.$analytical_schema_private' to '$db_public.$dev_schema_public'..."

dumpfile=$data_dir"/data/"$tbl".sql"
#echo "dumpfile: "$dumpfile

# Dump the table
pg_dump -U $user -t $analytical_schema_private.$tbl $db_private > $dumpfile

# edit the file
# Double quotes and escape used due to unix variables in command
sed -i -e "s/$analytical_schema_private/$dev_schema_public/g" $dumpfile

# Drop the table in destination database & schema if it already exists
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $dev_schema_public.$tbl"

# Create and populate the table
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_public < $dumpfile

# clean up 
rm $dumpfile

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
# Back up existing table in production schema
#########################################################################

sql_tbl_exists="SELECT EXISTS ( SELECT table_name FROM information_schema.columns WHERE table_name='$tbl' AND table_schema='$prod_schema_public') AS exists_tbl"
tbl_exists=`psql -U $user -d $db_public -lqt -c "$sql_tbl_exists" | tr -d '[[:space:]]'`

if [[ $tbl_exists == "t" ]]; then

	tbl_bak="agg_traits_bak_$(date +%Y%m%d_%H%M%S)"

	echoi $i -n "Backing up table agg_traits as $tbl_bak in schema $dev_schema_public..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v src_schema=$prod_schema_public -v src_tbl=$tbl -v target_schema=$dev_schema_public -v target_tbl=$tbl_bak -f $DIR/sql/backup_table.sql
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
# Rebuild metadata tables, then move all tables to production schema
#########################################################################

echoi $i -n "Applying embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_public -f $DIR/sql/apply_embargoes.sql
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
# Rebuild metadata tables, then move all tables to production schema
#########################################################################

echoi $i -n "Rebuilding table 'taxon_trait'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v src_schema=$dev_schema_public  -v target_schema=$prod_schema_public -f $DIR/sql/taxon_trait.sql
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
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v src_schema=$dev_schema_public -v target_schema=$prod_schema_public -f $DIR/sql/trait_summary.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

echoi $i -n "Replacing original table $tbl in public schema '$prod_schema_public'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_public  -v prod_schema=$prod_schema_public -f $DIR/sql/replace_original_table_core.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi

: <<'COMMENT_BLOCK_2'
######################################################
# Update database version
######################################################

echoi $i -n "Updating database version..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_public  -v db_version=$db_version  -v db_msg="$db_msg" -f $DIR/sql/update_db_version.sql
if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		echo "$msgfail"`date` | mail -s "$subjectfail" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $i "done ($elapsed seconds)"
fi


COMMENT_BLOCK_2

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
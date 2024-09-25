#!/bin/bash

#########################################################################
# Copies political division lookup tables from GNRS database
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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
#source "$DIR/includes/local_params.sh"	
source "$DIR/includes/startup_local.sh"	

######################################################
# Set local source parameter and echo custom 
# confirmation message. 
#
# Only done if running as standalone script 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Task:			Import political division tables from database GNRS
	Target database:	$db_private
	Target schema:		$target_sch
EOF
	)"		
	confirm "$msg_conf"
fi

: <<'COMMENT_BLOCK_1'


#########################################################################
# Params
#########################################################################

# Reset process name here if applicable
pname_local=$pname_local

# Confirm operation
pname_local_header="BIEN notification: process '"$pname_local"'"
source "$DIR/includes/local_confirm.sh"	


COMMENT_BLOCK_1

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Import political division tables from db geoscrub 
######################################################

echoi $e "- Copying political division tables from db '$db_gnrs' to schema '$target_sch' in db '$db_private':"

# Dump table from source databse
dumpfile=$data_dir_local"poldiv_tables.sql"
echoi $e "-- Creating dumpfile:"
echoi $e -n "--- '$dumpfile'..."
pg_dump -U $user -t country -t country_name -t state_province -t state_province_name -t county_parish -t county_parish_name $db_gnrs > $dumpfile
source "$DIR/includes/check_status.sh"	

# Replace schema references. Be very conservative to avoid 
# corrupting data which matches schema name 
# Recommend stopping first time prior to point to inspect dumpfile
# to be sure that substitutions are correct
# NOTE USE OF DOUBLE QUOTES! VARIABLE $target_schIS NOT TRANSLATED IF
# SINGLE QUOTES USED
echoi $e -n "--- Editing dumpfile..."
sed -i -e "s/Schema: public/Schema: $target_sch/g" $dumpfile
sed -i -e "s/public, pg_catalog/$target_sch/g" $dumpfile
sed -i -e "s/public.country_name/$target_sch.country_name/g" $dumpfile 
sed -i -e "s/public.country/$target_sch.country/g" $dumpfile 
sed -i -e "s/public.state_province_name/$target_sch.state_province_name/g" $dumpfile 
sed -i -e "s/public.state_province/$target_sch.state_province/g" $dumpfile 
sed -i -e "s/public.county_parish_name/$target_sch.county_parish_name/g" $dumpfile 
sed -i -e "s/public.county_parish/$target_sch.county_parish/g" $dumpfile 
source "$DIR/includes/check_status.sh"	

# Drop the table in core database if it already exists
echoi $e -n "-- Dropping previous tables, if any..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$target_sch -f $DIR_LOCAL/sql/drop_poldiv_tables.sql
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db
echoi $e -n "-- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_private < $dumpfile > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

# Remove unnecessary columns
echoi $e -n "-- Altering tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$target_sch -f $DIR_LOCAL/sql/alter_tables.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

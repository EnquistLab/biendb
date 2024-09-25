#!/bin/bash

#########################################################################
# Purpose: Sets zero or negative plot areas to NULL in tables plot_metadata,
#	analytical_stem and view_full_occurrence_individual
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Enable the following for strict debugging only:
#set -e

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

######################################################
# Alias key parameters
# Allows change for testing without meddling with
# main params file
######################################################

db_priv=$db_private
db_priv_sch=$prod_schema_adb_private
db_pub=$db_public
db_pub_sch=$prod_schema_adb_public

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

# Get current version number from private database
db_ver_curr=`psql -d $BIEN_METADATA_DBV_DB -U $BIEN_METADATA_DBV_USER -t -c "SELECT db_version FROM ${BIEN_METADATA_DBV_SCH}.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM ${BIEN_METADATA_DBV_SCH}.bien_metadata)"`
db_ver_curr="$(trim "${db_ver_curr}")"

# Set process name for emails and echo
pname_master="$pname"
pname_header="$pname_header_prefix"" '""$pname""'"

if [[ $appendlog == "true" ]]; then
	replacelog="false"
else
	replacelog="true"
fi

startup_msg_opts="$(cat <<-EOF
	Private DB:		$db_priv
	Private DB schema:	$db_priv_sch
	Public DB:		$db_pub
	Public DB schema:	$db_pub_sch
	
	Current DB version:	$db_ver_curr
	New DB version:		$BIEN_METADATA_DB_VERSION_NEW
	
	Logfile:		$glogfile
	Replace logfile:	$replacelog
	
	Steps:
	1. Set zero/negative plot areas to NULL
	2. Increment DB version to $BIEN_METADATA_DB_VERSION_NEW
EOF
)"		
source "$DIR/includes/confirm.sh"

#########################################################################
# Main
#########################################################################

######################################################
# Private DB
######################################################
echoi $e "Updating database \"$db_priv\":"

echoi $e -n "- Setting zero, negative plot areas to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_priv --set ON_ERROR_STOP=1 -q -v sch=$db_priv_sch -f $DIR/manual_fixes/bien4.1.1/fix_negative_plot_areas.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Incrementing DB version..."
# Reset module parameters specific to private db
BIEN_METADATA_DB_TO_UPDATE=$db_priv		# Db to update
BIEN_METADATA_SCH_TO_UPDATE=$db_priv_sch	# Sch to update
BIEN_METADATA_DBV_DB=$db_priv				# Db to lookup current ver #
BIEN_METADATA_DBV_SCH=$db_priv_sch			# Sch to lookup current ver #
i_bak=$i; e_bak=$e			# Backup current echo options
i="false"; e="false"		# Turn off confirmations & screen echoes 
source "$DIR/bien_metadata/db_version_update.sh"
i=$i_bak; e=$e_bak	# Reset echo/confirmation options
echoi $e "done"

######################################################
# Public DB
######################################################
echoi $e "Updating database \"$db_pub\":"

echoi $e -n "- Setting zero, negative plot areas to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_pub --set ON_ERROR_STOP=1 -q -v sch=$db_pub_sch -f $DIR/manual_fixes/bien4.1.1/fix_negative_plot_areas.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Incrementing DB version..."
# Reset module parameters specific to private db
BIEN_METADATA_DB_TO_UPDATE=$db_pub		# Db to update
BIEN_METADATA_SCH_TO_UPDATE=$db_pub_sch	# Sch to update
BIEN_METADATA_DBV_DB=$db_pub				# Db to lookup current ver #
BIEN_METADATA_DBV_SCH=$db_pub_sch			# Sch to lookup current ver #
i_bak=$i; e_bak=$e			# Backup current echo options
i="false"; e="false"		# Turn off confirmations & screen echoes 
source "$DIR/bien_metadata/db_version_update.sh"
i=$i_bak; e=$e_bak	# Reset echo/confirmation options
echoi $e "done"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname="$pname_master"
source "$DIR/includes/finish.sh"

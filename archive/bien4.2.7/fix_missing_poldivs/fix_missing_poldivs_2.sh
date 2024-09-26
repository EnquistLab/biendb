#!/bin/bash

#########################################################################
# Purpose: Populates missing verbatim political division for plot data 
#	source TEAM in legacy table vfoi and plot_metadata
#
# Notes:
#	1. Only updates vfoi & plot_metadata; poldiv info transferred to 
#		analytical_stem from vfoi
# 	2. Must run AFTER generating table plot_metadata, as column dataset
#		required
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
suppress_main="true"	# Suppress default startup message
source "$DIR/includes/startup_local.sh"	

# Set record limit & display
if [ "$reclim" = "" ]; then
	reclim_disp="None"
else
	reclim_disp=$reclim
	reclim=" LIMIT "$reclim
fi

######################################################
# Prepare and echo custom confirmation message. 
#
# Only done if running as standalone script 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 		
	
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Task:			Apply hotfix #$hf_num
	Target database:	$curr_db
	Target schema:		$curr_sch
	Record limit:		$reclim_disp
EOF
	)"		
	confirm "$msg_conf"
fi

tmplog="/tmp/tmplog.txt"
touch $tmplog

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " - Parameters:"
echoi $e " -- \$curr_db='"$curr_db"'"
echoi $e " -- \$curr_sch='"$curr_sch"'"

echoi $e -n "- Creating temporary indexes on vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/sql/create_indexes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Populating political divisions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/sql/populate_poldivs_team.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Dropping the temporary indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/sql/drop_indexes.sql
source "$DIR/includes/check_status.sh"	


######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

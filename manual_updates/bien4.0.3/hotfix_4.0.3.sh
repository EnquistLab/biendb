#!/bin/bash

#########################################################################
# Executes one-time hotfix specific to particular db version
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

echoi $e -n "- Creating table fia_plot_codes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -v reclim="$reclim" -f $DIR_LOCAL/$hf_dir/fix_fia_1_create_fia_plot_codes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating table vfoi_dev with revised FIA plot codes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -v reclim="$reclim" -f $DIR_LOCAL/$hf_dir/fix_fia_2_fix_fia_plot_codes.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Create new version of plot_metadata with updated plot codes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -v reclim="$reclim" -f $DIR_LOCAL/$hf_dir/fix_fia_3_update_plot_metadata.sql  > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Update FK plot_metadata_id in table vfoi_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/$hf_dir/fix_fia_4_update_fks_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating table astem_dev with revised FIA plot codes and FKs..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -v reclim="$reclim" -f $DIR_LOCAL/$hf_dir/fix_fia_5_update_astem.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Restoring permissions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/$hf_dir/fix_fia_6_restore_permissions.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing vfoi_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/$hf_dir/fix_fia_7_index_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing astem_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $curr_db --set ON_ERROR_STOP=1 -q -v sch=$curr_sch -f $DIR_LOCAL/$hf_dir/fix_fia_8_index_astem.sql
source "$DIR/includes/check_status.sh"	


######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Operation completed. Next steps:

1. Verify results in tables vfoi_dev & plot_metadata_dev
2. Commit all code changes and tag code version
3. For each database (private & public):
   a. Manually execute 'fix_fia_9_rename_tables.sql'
   b. Manually execute 'fix_fia_10_cleanup.sql'
   c. Update db & code version numbers (run bien_metadata/db_version_update.sh)

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

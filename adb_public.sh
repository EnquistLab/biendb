#!/bin/bash

#########################################################################
# Purpose: Copies private analytical_db to public database and applies  
#	embargoes. 
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Trigger sudo password request.
sudo pwd >/dev/null

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

# Set process name for emails and echo
pname_header=$pname_header_prefix" '"$pname"'"

#########################################################################
# Echo key settings and confirm operation
#########################################################################

if [[ "$i" = "true" ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Source db:	$db_private
	Source schema: 	$dev_schema_adb_private
	Target db:	$db_public
	Target schema: 	$dev_schema_adb_public
	
	WARNING: Recommend run with sudo, otherwise may abort.
EOF
	)"		
	confirm "$msg_conf"
fi

# Send notification mails if requested, but suppress main message
suppress_main="true"
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################




### TEMP ####
echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# Start comment block
: <<'COMMENT_BLOCK_1'






# Copy complete private adb schema to development public schema
source "$DIR/adb_public_copy/adb_public_copy.sh"

# Set permissions
# Changes DB ownership from postgres to bien so following steps
# can work without modification
cp $DIR/set_permissions/params.sh.public_adb_dev $DIR/set_permissions/params.sh
source "$DIR/set_permissions/set_permissions.sh"

# Strip indexes from major tables
# This is essential to avoid hanging server for days
db=$db_public; sch=$dev_schema_adb_public
source "$DIR/restore_indexes/drop_indexes.sh"

# Apply embargoes 
source "$DIR/adb_public_embargoes/adb_public_embargoes.sh"

# And a second time to be sure
db=$db_public; sch=$dev_schema_adb_public
echoi $e "- Dropping indexes from tables:"
tbls="
view_full_occurrence_individual
analytical_stem
agg_traits
bien_taxonomy
"

for tbl in $tbls; do
	echoi $e -n "-- ${tbl}..."
	drop_indexes -q -p -u $user -d $db_public -s $dev_schema_adb_public -t "${tbl}"
	echoi $e "done"
done



# End comment block
COMMENT_BLOCK_1
### TEMP ####



# Restore indexes on tables previously stripped of indexes
# Parameters critical
db=$db_public; sch=$dev_schema_adb_public
source "$DIR/restore_indexes/restore_indexes.sh"

# KEEPING THE FOLLOWING FOR NOW
# REMOVE ONCE CONFIRM ONLY NEEDED AT END
# Set permissions for public database
# Activate appropriate version of params file
#cp $DIR/set_permissions/params.sh.public_adb_dev $DIR/set_permissions/params.sh
#source "$DIR/set_permissions/set_permissions.sh"

# Set parameters for remaining operations
db=$db_public; dev_schema=$dev_schema_adb_public
tbl_vfoi="view_full_occurrence_individual"

# Rebuild metadata tables with counts potentially affected 
# by embargoes
source "$DIR/trait_metadata/trait_metadata.sh"
source "$DIR/bien_species_all/bien_species_all.sh"
source "$DIR/bien_summary_public/bien_summary_public.sh"

# Rebuild observations union table
# Merges species observations into one postgis spatial object per species
source "$DIR/observations_union/observations_union.sh"

# Set permissions
cp $DIR/set_permissions/params.sh.public_adb_dev $DIR/set_permissions/params.sh
source "$DIR/set_permissions/set_permissions.sh"

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. 

Next steps:

1. Validate public analytical database
2. Run adb_move_to_production.sh
3. Run vacuum/vacuum.sh on public analytical database

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"

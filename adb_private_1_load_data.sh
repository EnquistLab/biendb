#!/bin/bash

#########################################################################
# Purpose: Step 1 of BIEN database pipeline. 
#
# Details: Loads legacy data & all new data sources, performs basic 
# standardizations & exports CSV files for validation by TNRS, GNRS
# and CDS
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Enable the following for strict debugging only:
#set -e

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
export master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

# Set process name for emails and echo
pname_master="$pname"
pname_header="$pname_header_prefix"" '""$pname""'"

# Set default targets for confirmation message
db_main=$db_private
sch_main=$dev_schema_adb_private

# Source list display
sources_disp=""
if [[ "$sources" == "" ]]; then
	sources_disp="[No sources specified]"
else
	for src in $sources; do
		sources_disp=$sources_disp", "$src
	done
	sources_disp="${sources_disp/', '/''}"
fi

# Record limit display
if [[ "$use_limit" == "true" ]]; then
	limit_disp="true (limit="$recordlimit")"
else
	limit_disp="false"
fi

if [[ "$appendlog" == "true" ]]; then
	replacelog="false"
else
	replacelog="true"
fi

echoi $e ""
startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Sources:		$sources_disp
	Load phylogenies:	$load_phylo
	Use record limit?:	$limit_disp
	Logfile:		$glogfile
	Replace logfile:	$replacelog
	\$user:			$user
	\$db_private: 	$db_private
	\$pwd: 	$pwd
EOF
)"		
source "$DIR/includes/confirm.sh"	

#########################################################################
# Main
#########################################################################

# Pointless command to trigger sudo password request
sudo pwd >/dev/null

echoi $e "Start: $(date)"
echoi $e " "

# Prompt to replace dev schema exists before starting
# Safer to do this manually
sch_exists=$(exists_schema_psql -d $db_private -u $user -s $dev_schema_adb_private )
if [[ $sch_exists == "t" ]]; then
	echo "WARNING: Schema '$dev_schema_adb_private' already exists! Drop first before running this script."
	echo; exit 1
fi

# Create development schema
# Hard wired to avoid errors
echoi $e -n "Creating schema '$dev_schema_adb_private'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "CREATE SCHEMA $dev_schema_adb_private;"
source "$DIR/includes/check_status.sh"	

######################################################
# Install custom functions, etc.
######################################################
 
source "$DIR/install_dependencies/install_dependencies.sh"

######################################################
# Import legacy data and restructure
######################################################

echoi $e "-----------------------------------"
source "$DIR/copy_core_tables/copy_core_tables.sh"

# Populate country for legacy datasources 'CVS', 'NVS' and 'Madidi'
echoi $e "-----------------------------------"
source "$DIR/fix_missing_poldivs/fix_missing_poldivs_1.sh"

# Extract table plot_metadata from legacy data
echoi $e "-----------------------------------"
source "$DIR/data_provenance/data_provenance.sh"

echoi $e "-----------------------------------"
source "$DIR/plot_metadata/plot_metadata.sh"

# Extract table datasource from legacy data
echoi $e "-----------------------------------"
source "$DIR/datasource/datasource_1_load_legacy.sh"

# Populate country for legacy datasource 'TEAM'
echoi $e "-----------------------------------"
source "$DIR/fix_missing_poldivs/fix_missing_poldivs_2.sh"

######################################################
# Prepare vfoi for insert: set PK to autoincrement
######################################################

echoi $e "-----------------------------------"
echoi $e "Executing module 'Prepare vfoi for inserts':"

# Add autoincrement primary key to table vfoi
echoi $e -n "- Adding autoincrement primary key..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR/import/sql/vfoi_enable_primary_key.sql  > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

######################################################
# Import new data sources
######################################################

#use_limit='false'		# For testing
for src in $sources; do
	echoi $e "-----------------------------------"
	source "$DIR/import_"$src"/import.sh"
	source "$DIR/import/load_from_staging.sh"
done

# FK to staging table no longer needed
echoi $e -n "Dropping staging table fkey from table vfoi..."
sql="DROP INDEX IF EXISTS vfoi_fk_vfoi_staging_id_idx"
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e "-----------------------------------"
source "$DIR/checks/count_rows.sh"

######################################################
# Remove secondary (redistributed) records of any
# primary sources. Example: MO is giving us all
# specimen records directly; we therefore remove all 
# MO specimen records redistributed by other sources.
######################################################


# WARNING: this step commented out for BIEN 4.2! 
# echoi $e "-----------------------------------"
# source "$DIR/remove_sources/remove_secondary_sources.sh"

######################################################
# Export completed table datasource for manual editing
# Manual edits are loaded to database in step 3
# See module datasource/
######################################################
echoi $e "-----------------------------------"
source "$DIR/datasource/datasource_2_export.sh"

######################################################
# Build endangered species table and extract taxon
# names for scrubbing with TNRS
######################################################

echoi $e "-----------------------------------"
source "$DIR/endangered_taxa/endangered_taxa_1_prepare.sh"

######################################################
# TNRS: Extract file of taxon names for scrubbing  
######################################################

echoi $e "-----------------------------------"
source "$DIR/tnrs/tnrs_1_prepare.sh"
#  source "$DIR/tnrs/tnrs_2_scrub.sh"

######################################################
# GNRS: extract political division names for scrubbing]
######################################################

echoi $e "-----------------------------------"
source "$DIR/gnrs/gnrs_1_prepare.sh"	
# source "$DIR/gnrs/gnrs_2_scrub.sh"	

######################################################
# CDS: extract geocoordinates for scrubbing
######################################################

echoi $e "-----------------------------------"
source "$DIR/cds/cds_1_prepare.sh"	
#source "$DIR/cds/cds_2_scrub.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Next steps:

1. Submit TNRS input for scrubbing
2. Submit GNRS input for scrubbing
3. Submit CDS input for scrubbing
4. After steps 1-3 complete, continue with adb_private_2_import_validations_1.sh

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"

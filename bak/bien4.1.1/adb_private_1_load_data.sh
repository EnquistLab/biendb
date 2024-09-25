#!/bin/bash

#########################################################################
# Purpose: Step 1 of BIEN database pipeline. 
#
# Details: Loads legacy data & all new data sources, performs basic 
# standardizations & exports CSV files for  validation by TNRS, centroid 
# app & point-in-polygon app (geovalidion).
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

startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Sources:		$sources_disp
	Load phylogenies:	$load_phylo
	Use record limit?:	$limit_disp
	Logfile:		$glogfile
	Replace logfile:	$replacelog
EOF
)"		
source "$DIR/includes/confirm.sh"	

#########################################################################
# Main
#########################################################################

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
# Import new adb data
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
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"

######################################################
# Remove secondary (redistributed) records of any
# primary sources. Example: MO is giving us all
# specimen records directly; we therefore remove all 
# MO specimen records redistributed by other sources.
######################################################

echoi $e "-----------------------------------"
source "$DIR/remove_sources/remove_secondary_sources.sh"

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
# Extract file of taxon names for scrubbing with TNRS 
######################################################

echoi $e "-----------------------------------"
source "$DIR/tnrs/tnrs_1_prepare.sh"
source "$DIR/tnrs/tnrs_2_scrub.sh"
source "$DIR/tnrs/tnrs_3_update.sh"

######################################################
# Validate and standardize political division names
# using the GNRS
######################################################
pname_bak="$pname" 	# Save main process name from change by external app
DIR_BAK=$DIR		# Save current value of $DIR

echoi $e "-----------------------------------"
source "$DIR/gnrs/gnrs_1_prepare.sh"	# Export poldivs for scrubbing
DIR=$DIR_BAK
source "$DIR_BAK/gnrs/gnrs_2_scrub.sh"	# Process poldivs with GNRS
DIR=$DIR_BAK
source "$DIR_BAK/gnrs/gnrs_3_update.sh"	# Import results to BIEN DB

DIR=$DIR_BAK		# Restore $DIR
pname="$pname_bak"	# Restore main process name

######################################################
# Import political division reference tables
# Needed to fix FIA plot codes in next step
######################################################

echoi $e "-----------------------------------"
source "$DIR/poldiv_tables/poldiv_tables.sh"

######################################################
# Fix plot codes in legacy FIA data
#
# Run after GNRS to allow use of standardized 
# political division fields
######################################################

echoi $e "-----------------------------------"
source "$DIR/fix_fia/fix_fia.sh"

######################################################
# Extract file of political divisions and coordinates
# for point-in-polygon geovalidation & centroids
# 
# Currently not used for geovalidation now that this 
# is done in pipeline by module pdg. May be deprecated
# in future once centroids added to pipeline as well.
######################################################
echoi $e "-----------------------------------"
source "$DIR/geovalid/geovalid_1_prepare.sh"

######################################################
# Echo final instructions
######################################################
echoi $e "-----------------------------------"

msg_next_steps="$(cat <<-EOF

Script completed. 

Next steps:

I. TNRS

1. Compress file 'tnrs_submitted.csv' in tnrs data directory*
2. SCP & extract file 'tnrs_submitted.csv' to tnrs_batch data directory on TNRSbatch server (currently, toad.iplantc.org)
3. Set working directory as TNRSbatch/src/ and issue TNRSbatch command, as described in tnrs_batch/documentation/tnrs_batch_instructions.txt
4. When ready, compress results file (tnrs_scrubbed.csv) to tnrs_scrubbed.csv.tar.gz and copy to tnrs data directory on this server. Do not extract. See tnrs_batch params file to make sure tnrs_scrubbed file name is correct.

II. Centroids

1. Process centroid input file with centroid validation app
2. Place centroid results file in centroid data directory

III.  Continue building analytical database with script adb_private_2.sh

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname="$pname_master"
source "$DIR/includes/finish.sh"

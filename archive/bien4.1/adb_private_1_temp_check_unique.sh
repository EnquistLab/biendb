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
master=`basename "$0"`

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
pname=$pname_1
pname_master=$pname
pname_header=$pname_header_prefix" '"$pname"'"

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


startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Sources:		$sources_disp
	Load phylogenies:	$load_phylo
	Use record limit?:	$limit_disp
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
# Import legacy tables to development schema
# Add and populate missing metadata and new columns
#echoi $e "-----------------------------------"
echoi $e "------ Importing legacy data ------"
source "$DIR/copy_core_tables/copy_core_tables.sh"
source "$DIR/validations/check_pk_vfoi.sh"



# Populate country for legacy datasources 'CVS', 'NVS' and 'Madidi'
source "$DIR/fix_missing_poldivs/fix_missing_poldivs_1.sh"
source "$DIR/validations/check_pk_vfoi.sh"

# Extract table plot_metadata from legacy data
source "$DIR/data_provenance/data_provenance.sh"
source "$DIR/validations/check_pk_vfoi.sh"
source "$DIR/plot_metadata/plot_metadata.sh"
source "$DIR/validations/check_pk_vfoi.sh"

# Extract table datasource from legacy data
source "$DIR/datasource/datasource_1_load_legacy.sh"
source "$DIR/validations/check_pk_vfoi.sh"

# Populate country for legacy datasource 'TEAM'
source "$DIR/fix_missing_poldivs/fix_missing_poldivs_2.sh"
source "$DIR/validations/check_pk_vfoi.sh"

######################################################
# Remove completely from legacy tables sources that 
# will be loaded from scratch later in pipeline
######################################################

$DIR/remove_sources/remove_duplicate_sources.sh -n -d $db_private -c $dev_schema_adb_private
source "$DIR/validations/check_pk_vfoi.sh"

######################################################
# Import other adb data
######################################################

# Comment out for development if too slow
echoi $e "-----------------------------------"
if [[ $load_phylo == "true" ]]; then
	source "$DIR/phylogeny/phylogeny.sh"
else
	echoi $e "Loading phylogenies...SKIPPING THIS STEP"
fi

######################################################
# Prepare vfoi for insert: set PK to autoincrement
######################################################

echoi $e "-----------------------------------"
echoi $e "Preparing table vfoi for imports:"

# Add autoincrement primary key to table vfoi
echoi $e -n "- Adding autoincrement primary key..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR/import/sql/vfoi_enable_primary_key.sql  > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"
source "$DIR/validations/check_pk_vfoi.sh"

######################################################
# Import new adb data
######################################################

#use_limit='false'		# For testing
for src in $sources; do
	echoi $e "-----------------------------------"
	source "$DIR/import_"$src"/import.sh"
source "$DIR/validations/check_pks.sh"
	source "$DIR/import/load_from_staging.sh"
source "$DIR/validations/check_pks.sh"
done

######################################################
# Remove secondary (redistributed) records of any
# primary sources. Example: MO is giving us all
# specimen records directly; we therefore remove all 
# MO specimen records redistributed by other sources.
######################################################

echoi $e "-----------------------------------"
$DIR/remove_sources/remove_secondary_sources.sh -n -d $db_private -c $dev_schema_adb_private

######################################################
# Export completed table datasource for manual editing
# Manual edits are loaded to database in step 3
# See module datasource/
######################################################
echoi $e "-----------------------------------"
source "$DIR/datasource/datasource_2_export.sh"
source "$DIR/validations/check_pks.sh"

######################################################
# Build endangered species table and
# extract taxa for scrubbing with TNRS
######################################################
echoi $e "-----------------------------------"

# Import endangered species data and extract taxon names
# for scrubbing by TNRS
source "$DIR/endangered_taxa/endangered_taxa_1_prepare.sh"
source "$DIR/validations/check_pks.sh"

######################################################
# Validate and standardize political division names
# using the GNRS
######################################################
echoi $e "-----------------------------------"
source "$DIR/gnrs/gnrs_1_prepare.sh"	# Export poldivs for scrubbing
source "$DIR/gnrs/gnrs_2_scrub.sh"	# Process poldivs with GNRS
source "$DIR/gnrs/gnrs_3_update.sh"	# Import results to BIEN DB
source "$DIR/validations/check_pks.sh"

######################################################
# Import political division reference tables
# Needed to fix FIA plot codes in next step
######################################################

source "$DIR/poldiv_tables/poldiv_tables.sh"
source "$DIR/validations/check_pks.sh"

######################################################
# Fix plot codes in legacy FIA data
#
# Run after GNRS to allow use of standardized 
# political division fields
######################################################

source "$DIR/fix_fia/fix_fia.sh"
source "$DIR/validations/check_pks.sh"

######################################################
# Extract file of political divisions and coordinates
# for point-in-polygon geovalidation & centroids
# 
# Currently not used for geovalidation now that this 
# is done in-pipeline by module pdg. May be deprecated
# in future once centroids included in-pipeline as well.
######################################################
echoi $e "-----------------------------------"
source "$DIR/geovalid/geovalid_1_prepare.sh"

######################################################
# Extract file of taxon names for scrubbing with TNRS 
######################################################
echoi $e "-----------------------------------"
source "$DIR/tnrs_batch/tnrs_batch_1_prepare.sh"

######################################################
# Echo final instructions
######################################################
echoi $e "-----------------------------------"

msg_next_steps="$(cat <<-EOF

Script completed. 

Next steps:

I. TNRS

1. Upload file 'tnrs_submitted.csv' from tnrs data directory* to TNRS website.
2. Submit file for parsing using 'Parse only' option.
3. When notified, download results as 'taxon_parsed.txt' and save to tnrs
	data directory. Download option: 'Encoding'='UTF-8'.
4. Upload file 'tnrs_parsed' from data directory* to TNRS website.
5. Submit file for name resolution using default options.
6. When notified, download results as 'tnrs_scrubbed' and save to tnrs
	data directory. Download options: 'Results to download'='All matches',  
	'Download format'='Detailed', 'Encoding'='UTF-8'.

II. Centroids

1. Process centroid input file with centroid validation app
2. Place centroid results file in centroid data directory

III. Geovalidation

1. Process geovalidation input file with geovalidation app
2. Place geovalidation results file in geovalidation data directory

IV. Continue building analytical database with script adb_private_2.sh

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"

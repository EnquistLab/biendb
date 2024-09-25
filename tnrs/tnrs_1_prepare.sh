#!/bin/bash

#########################################################################
# Purpose: Prepares TNRS tables and extracts all verbatim taxon names for 
#	scrubbing.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

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
source "$DIR/includes/startup_local.sh"	

#########################################################################
# Main
#########################################################################

echoi $e "Executing module 'tnrs'"

#########################################################################
# Import TNRS results 
#########################################################################

# Create tnrs tables
echoi $e -n "- Creating TNRS tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_tnrs_submitted.sql
source "$DIR/includes/check_status.sh"	

# Extract verbatim names
echoi $e "- Extracting verbatim names:"

echoi $e -n "-- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/tnrs_vfoi_extract.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/tnrs_agg_traits_extract.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- endangered_taxa..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/tnrs_endangered_extract.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Pre-processing names..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_tnrs_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Extracting unique names and adding ID column..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/name_submitted_unique.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Exporting names file '$data_dir_local/$tnrs_submitted_filename'..."
sql="\copy (select name_id, name_submitted from tnrs_submitted) to ${data_dir_local}/${tnrs_submitted_filename} delimiter '|' csv "
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

# No idea why the following names cause TNRS to fail, but they have to go
echoi $e -n "- Deleting offending names from CSV..."
sed -i '/Lamiaceae Agastache pallidiflora (Heller) Rydb. spp. pallidiflora var. gilensis R. W. Sanders/d' $data_dir_local/$tnrs_submitted_filename
sed -i '/Lamiaceae Agastache pallidiflora spp. neomexicana var. neomexicana/d' $data_dir_local/$tnrs_submitted_filename
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
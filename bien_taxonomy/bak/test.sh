#!/bin/bash

#########################################################################
# Purpose: Creates & populate complete table bien_taxonomy
#
# Details:
#   Table bien_taxonomy is an extract of all distinct taxa, including
#   authors and morphospecies, from main bien analytical database
#   'view_full_occurrence_individual'. Other columns added include 
#   (1) Integer primary key, (2) higher taxa, and (3) taxonomic status
#   of the final resolved name.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 23 July 2016
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
# $local_basename = name of this file minus ='.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
# if local data directory needed
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

echoi $e "Executing module 'test table exists'"

######################################################
# Check if required taxonomic databases exist
######################################################

# Check if tnrs & genus databases present
mydb="junk"
echoi $e -n "- Checking if required database $mydb exists..."
if [ $(exists_db_psql $tnrs_db) == 'f' ]; then 
	echo "ERROR: Required database '$mydb' missing"; echo 
	exit 1
fi
source "$DIR/includes/check_status.sh"	

######################################################
# Populate remaining higher taxa
# Note that all operation in this step are in TNRS db
######################################################

# Check if required table 'higher_taxa' exists in development schema  
# of TNRS database
d=$tnrs_db
s="analytical_db_dev"
t="higher_taxa"
echoi $e -n "- Checking if table '$t' exists in schema '$s' of db '$d'..."

table_exists=$(exists_table_psql -d $d -u $user -s $s -t 'higher_taxa' )

echo "table_exists="$table_exists

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
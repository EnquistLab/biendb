#!/bin/bash

#########################################################################
# Purpose: Submits extracted names to TNRS for scrubbing
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

echoi $e -n "- Processing names with TNRS..."

infile="${data_dir_local}/${tnrs_submitted_filename}"
outfile="${data_dir_local}/${tnrs_scrubbed_filename}"

# Delete previous results file, if any
rm -f $outfile

# Submit names file to tnrs batch app
# Suppress application echo, except for errors
"$tnrs_dir"/controller.pl -in "$infile"  -out "$outfile" -sources "tropicos,ildis,gcc,tpl,usda,ncbi" -class tropicos -nbatch $tnrs_batchsize -d t &>/dev/null
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
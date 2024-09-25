#!/bin/bash

#########################################################################
# Purpose: Scrubs prepared political division using CDS
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################



##### UNDER CONSTRUCTION! ##########
# In process of being adapted from gnrs_2_scrub.sh




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

# Start error log
echo "Error log
" > $DIR_LOCAL/log.txt

#########################################################################
# Main
#########################################################################

# Back up current value of $DIR, process name and echo settings
# As these will be reset by validation app
DIR_BAK=$DIR		
pname_bak=$pname
e_bak=$e
i_bak=$i

echoi $e -n "- Scrubbing political divisions with GNRS..."
e=""; i=""	# Turn off application screen echo
source "$gnrs_dir/gnrs_import.sh" -s -n		# Import data to GNRS db
source "$gnrs_dir/gnrs.sh" -s				# Process poldivs with GNRS
source "$gnrs_dir/gnrs_export.sh" -s		# Export GNRS results

# Restore settings
DIR=$DIR_BAK
pname=$pname_bak
e=$e_bak
i=$i_bak

source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


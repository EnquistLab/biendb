#!/bin/bash

#########################################################################
# Purpose:	Backs up single schema, according to parameter set in local  
# 	params file
#
# Note: Must be restored using pg_restore utility.
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

echoi $e "Executing module '$local_basename'"

# Check source schema exists before starting
sch_exists=$(exists_schema_psql -d $db -u $user -s $sch )
if [[ $sch_exists == "f" ]]; then
	echo "ERROR: source schema '$sch' doesn't exist in db '$db'!"
	exit 1
else 
	echo "Schema '$sch' exists!"
fi

# Compose name of backup file, including date
ext="pgd"
dumpfile_basename=$db"."$sch"_$(date +%Y%m%d_%H%M%S)"
dumpfile_name=$dumpfile_basename"."$ext
dumpfile=$data_dir"/"$dumpfile_name

# Dump schema from source database
# Option -Fc forces custom pg_dump format; must be restored using
# pg_restore utility
echoi $e -n "-- Creating dumpfile of schema '$sch' in db '$db'..."
pg_dump -U $user -Fc -n $sch $db > $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Dumpfile '$dumpfile_name' created in directory '$data_dir'. To restore, run the following command:

pg_restore -U [username] -d [database_to_restore_to] -n [schema_to_restore] $dumpfile_name

'database_to_restore_to' does not need to be the same as original db. 'schema_to_restore' must be the same.

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



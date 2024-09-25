#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Validation results file
# Input file is produced by module geovalid, therefore not
# included here
#results_filename="centroids_returned_bien4.1.csv" 
results_filename="centroids_returned.test.csv" 

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/centroids/data"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set to true to import subsample of data only, otherwise false
# Will over-ride $use_local setting in main params file
# In turn, use_limit_local='false' is over-ridden if global
# parameter $force_limit='true'
use_limit_local='true'

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "centroids_scrub" ]; then
	pname_local="Import centroid validation results"
elif [ "$local_basename" == "centroids_update" ]; then
	pname_local="Import centroid validation results (part 2)"
else
	echo "ERROR: \"$local_basename\" - Incorrect process name, check params file"; exit 1
fi
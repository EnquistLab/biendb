#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

#########################################################################
# Params for testing to be moved to params file
#########################################################################

# Size of batches to be processed
# Strongly recommend 100000; gives fastest overall processing time
BATCHSIZE=100000

# Tables to be validated
# All validation fields MUST be the same in all tables
# Each line is a table name, no comma at end of line
target_tbls="
view_full_occurrence_individual_dev
agg_traits
"

# Projection to use; 4326 is WGS84
SRID="4326"

# Name of temporary integer PK
# Will be added to each table for calculating batches, then 
# removed after operation complete. Make sure name does not
# conflict with any existing column in any target table
pk_temp="super_temporary_pk"

# Drop temporary PK?
# Set to 't' to keep if following operation can use it, otherwise 'f'
keep_pk_temp='t'

# column to index when building not-null partial index on latitude and  
# longitude. Actual column doesn't, but best to use an integer column  
# with few values and many nulls for faster performance.
# Column MUST be present in all tables listed in $target_tbls
idx_col_latlong_notnull="is_geovalid"

# Drop spatial indexes and constraints after column is populated?
# true/false
# Normally set to false.
# Set to 'true' if indexes/constraints would slow down subsequent updates
# of very large tables
drop_indexes="false"
	
# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/vfoi_geom"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Add geometry columns to tables"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
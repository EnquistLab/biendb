#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Relative distance threshold
# Distance from observation point to nearest centroid, divided by
# distance from that same centroid to farthest point on political
# Only observations with distances <= to this value are set to 
# is_centroid=1
# division boundary. centroid_likelihood is 1 minus this value.
REL_DIST_MAX=0.002

# CDS file names
submitted_filename="cds_submitted.csv"	# Validation input file
results_filename="cds_submitted_scrubbed.csv"		# Validation results file

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
validation_app_data_dir=$CDS_DATA_DIR	# Defined in main params file
data_dir_local=$validation_app_data_dir	# Don't ask; backward compatibility

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names
pname_1="CDS"
pname_2="CDS: import results"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private

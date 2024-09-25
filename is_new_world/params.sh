#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# TNRS file names
#submitted_filename="geovalid_submitted.csv"	# File submitted validation
#results_filename="geovalidation_returned_2_5_18.csv" 	# Validation results

# For testing with sample only:
submitted_filename="geovalidation_submitted_example.csv"
results_filename="geovalidation_results_example.csv" 	# Validation results

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/geovalid/data"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names
pname_1="Geovalid 1: export"
pname_2="Geovalid 1: import results"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private

# IN list of New World countries
nw_countries="
'Anguilla',
'Antigua and Barbuda',
'Argentina',
'Aruba',
'Bahamas',
'Barbados',
'Belize',
'Bermuda',
'Bolivia',
'Bonaire, Saint Eustatius and Saba',
'Brazil',
'British Virgin Islands',
'Canada',
'Cayman Islands',
'Chile',
'Cocos Islands',
'Colombia',
'Costa Rica',
'Cuba',
'Curacao',
'Dominica',
'Dominican Republic',
'Ecuador',
'El Salvador',
'French Guiana',
'Greenland',
'Grenada',
'Guadeloupe',
'Guatemala',
'Guyana',
'Haiti',
'Honduras',
'Jamaica',
'Mexico',
'Montserrat',
'Nicaragua',
'Panama',
'Paraguay',
'Peru',
'Puerto Rico',
'Saint Barthelemy',
'Saint Kitts and Nevis',
'Saint Lucia',
'Saint Martin',
'Saint Pierre and Miquelon',
'Saint Vincent and the Grenadines',
'Sint Maarten',
'Suriname',
'Trinidad and Tobago',
'Turks and Caicos Islands',
'Uruguay',
'U.S. Virgin Islands',
'Venezuela'
"


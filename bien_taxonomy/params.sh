#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Special taxonomic databases, must be present
genus_family_db="gf_lookup"	# Genus-family lookup table database
tnrs_db="tnrs4"				# TNRS database

# Set to true to force replacement of table higher_taxa  
#higher_taxa_force_replace="false"
# NOW SET IN MAIN PARAMS FILE

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/bien_taxonomy/data"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="bien_taxonomy"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private


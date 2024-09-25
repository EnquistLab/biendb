#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
# Parameter $src passed from master script
##############################################################

# Name of the MS Access db file to be extracted
access_db='NeotropTree.accdb'

# Names of extracted raw csv files, minus the .csv extension
# One per line
csv_basenames="
species
areas
sources
species_areas
sources_areas
"

# Original table names in Access database, for use with mdb-export 
# command. MUST be listed in same order as in csv_basenames above,
# Enclose in single quotes if contain spaces or special characters such as '-'
tblnames_orig="
Species
Areas
TheSources
Species-Area
TheSources-Areas
"

# Name of metadata file
metadata_raw="datasource_metadata.csv"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/data/"$src

# Determines method of joining to datasource when loading from
# staging table to main vfoi table
use_datasource_staging_id="f"

# production and development schemas for anaytical db
prod_schema=$prod_schema_adb_private
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Import "$src

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private

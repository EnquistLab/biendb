#!/bin/bash

##############################################################
# Global application parameters
# Check and change as needed
##############################################################

# BIEN base directory 
# CRITICAL! Most paths depend on this parameter.
# Absolute path to base directory for all BIEN applications
# Omit trailing slash
BIEN_BASE_DIR="/home/boyle/bien"

# BIENDB application base directory
# CRITICAL! Most paths depend on this parameter.
# Absolute path to base directory containing all components 
# of the biendb application (except submodules). Equals
# parent directory of repo, not the repo subdirectory.
APP_BASE_DIR=$BIEN_BASE_DIR"/biendb"

# Main analytical table name as variable: development and production versions
VFOI_PROD="view_full_occurrence_individual"
VFOI_DEV=$VFOI_PROD"_dev"

# Set which of the above names to use
VFOI=$VFOI_PROD

# Code of each new source to import
# The code MUST be the same as:
# a) suffix of the import directors (e.g., import_<source_code>) AND
# b) subdirectory in the data directory in which raw data are 
# stored AND
# c) value of in column datasource for each record from this source
# in table view_full_occurrence_individual AND
# d) value of column source_name in table datasource.
# One source code per line, no commas or quotes
sources="
traits
alaus
chilesp
dryflor
gillespie
ntt
rainbio
schep
GBIF
"

# Sources for which records in legacy data will be removed because source
# will be re-imported directly.
# Even if same as parameter $sources, setting separately allows this 
# parameter to be modified on the fly without affecting original parameter.
#dup_sources=$sources
dup_sources="
GBIF
Cyrille_traits
traits
"

# Datasources (primary data providers to BIEN) which should not 
# appear as secondary data sources. Any secondary-source specimen records
# for these providers will be removed. These should all be acronyms of 
# herbaria that provide data directly to BIEN, as these are only sources
# likely to have standardized abbreviation in aggregator/indexer source
# databases
# Format same as for '$sources', above
primary_sources="
ARIZ
BRIT
HVAA
MO
NCU
NY
TEX
U
UNCC
"

# Schema names
# CRITICAL! 
dev_schema_adb_private="analytical_db_dev" 	# Schema of the new DB you will build
prod_schema_adb_private="analytical_db"		# Schema of the existing DB
dev_schema_adb_public=$dev_schema_adb_private	# Must be identical (WHY???)
prod_schema_adb_public="public"
prod_schema_geom="public"
postgis_schema="postgis"	# Main postgis schema, may be different from adb schema
dev_schema_users="users_dev"
prod_schema_users="users"

# true to load phylogenies, false to skip
# Set to false for development purposes only (to speed up)
load_phylo='true'

# Set to true to force replacement of table higher_taxa 
# This happens in step 2 during TNRS updates
# Slow, set to false during development to recycle old version
# Set=true for production run to rebuild from latest TNRS database
higher_taxa_force_replace="false"

# Set to 'true' to move raw data tables to their own schemas
# named after each source. Set to false to delete raw data.
archive_raw='false'

# Path to database configuration file (db_config.sh)
# Recommend keep outside app working directory
# Use absolute path
# Omit trailing slash
db_config_path=$APP_BASE_DIR"/config"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path="/home/boyle/includes"
functions_path="includes"

# Path to data directory
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
#data_base_dir="data"		 # Relative path
data_base_dir=$APP_BASE_DIR"/data"

# Global record limit, for testing
# Applied if use_limit="true"
# Can be over-ridden for any one source by setting sql_limit_local,
# unless sql_limit_force="true"
recordlimit=100

# Limit records imported to large tables, for testing only
# Set 'true' for testing, 'false' for production
# CRITICAL! Make sure this is set to false for production run!
use_limit="true"	# true,false; use sql_limit_global

# Use these options to over-ride limit settings
force_limit="true"	# true,false; enforces global use_limit setting, 
					# over-riding local settings if any
if [[ $use_limit == "true" ]]; then
	sql_limit_global=" LIMIT "$recordlimit" "
else 
	sql_limit_global=" "
fi

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"
email="ojalaquellueva@gmail.com"

# Set process names, for notification and screen echo
if [ -n "$master" ]; then 
	master_basename="${master/.sh/}"
	pname="BIEN DB process: '$master_basename'"

	# Global logfile for this operation
	export glogfile="log/logfile_"$master_basename".txt"
fi

# Temp log file for redirecting unwanted screen echo
tmplog="/tmp/tmplog.txt"
touch $tmplog

# General process name prefix for email notifications
# PROBABLY NOT NEEDED BY KEEP FOR NOW
pname_header_prefix="BIEN notification: process"

##############################################################
# Data dictionary settings
##############################################################

# Set to true to import table, column and value descriptions from 
# previous version of database. Will reuse descriptions for any
# tables and columns which match between the two versions. All 
# value descriptions will be imported.
# Previous version must exist!
# [true/false]
dd_import_previous='true'

# Data dictionary source schema
# Schema to use if recycling content from previous version of
# data dictionary. Can be previous production schema, 
# or development schema (if making successive edits and 
# wish to keep content added thus far)
# Ignored if $dd_import_previous='false'
#dd_src_sch=$dev_schema_adb_private
dd_src_sch=$prod_schema_adb_private

##############################################################
# Validation application parameters
# Omit trailing slash from paths
##############################################################

# Absolute path to TNRS root application & data directories
tnrs_dir=$BIEN_BASE_DIR"/tnrs/TNRSbatch/src"
tnrs_data_dir=$BIEN_BASE_DIR"/tnrs/data/user"

# Absolute path to GNRS root application & data directories
# Path to GNRS DB required for extracting political division tables
#gnrs_dir="/home/boyle/bien3/repos/gnrs/gnrs"
#gnrs_data_dir="/home/boyle/bien3/gnrs/user_data"
gnrs_dir=$BIEN_BASE_DIR"/gnrs/src"
gnrs_data_dir=$BIEN_BASE_DIR"/gnrs/data/user"
db_gnrs="gnrs"

# Absolute path to CDS root application & data directories
CDS_DIR=$BIEN_BASE_DIR"/cds/src"
CDS_DATA_DIR=$BIEN_BASE_DIR"/cds/data"

# Absolute path to CODS root application & data directories
CODS_DIR=$BIEN_BASE_DIR"/cods/src"
CODS_DATA_DIR=$BIEN_BASE_DIR"/cods/data"

# Absolute path to NSR root application & data directories
NSR_DIR=$BIEN_BASE_DIR"/nsr/src"
NSR_DATA_DIR=$BIEN_BASE_DIR"/nsr/data/user"

# Replace NSR cache?
# Should be set to false unless the NSR database or algorithm
# has changed. If true, scrubbing will take much longer as 
# names must be check from scratch and the cache rebuilt.
NSR_CACHE_REPLACE="false"

##############################################################
# Module "bien_metadata.sh":
# DB version parameters
##############################################################

# New database version details
# Complete these if $insert_new='true'
BIEN_METADATA_DB_VERSION_NEW='4.3'
BIEN_METADATA_VERSION_COMMENTS="Update major validations & GBIF refresh"

# DB code version associated with this db release
# Only add this tag after full build completed and moved
# to production
BIEN_METADATA_DB_CODE_VERSION='4.2'

# Latest rbien version associated with this 
BIEN_METADATA_RBIEN_VERSION='1.2.3'

# Latest rtodobien version associated with this release
BIEN_METADATA_RTODOBIEN_VERSION='1.2.3'

# Version of TNRS used to scrub names for this release
BIEN_METADATA_TNRS_VERSION='5.0'

# Set to true to reuse existing bien_metadata from production schema. 
# Will create new table if doesn't already exist.
# If "false" will merely append new record to existing table in 
# current schema
BIEN_METADATA_REPLACE_TABLE="true"

# Insert record for new db version
# Applies to new bien_metadata table only (BIEN_METADATA_REPLACE_TABLE="true")
BIEN_METADATA_INSERT_NEW="true"

# Which development schema to use ($dev_schema_adb_private from 
# main params file)
BIEN_METADATA_DEV_SCHEMA=$dev_schema_adb_private

# Database & schema where main current db version table lives.
# Used only for determining current version.
# May or may not be same as $sch
# Private production DB
BIEN_METADATA_DBV_DB="vegbien"
BIEN_METADATA_DBV_USER="bien"
BIEN_METADATA_DBV_SCH=$prod_schema_adb_private
## Public production DB
#BIEN_METADATA_DBV_DB="public_vegbien"
#BIEN_METADATA_DBV_USER="bien"
#BIEN_METADATA_DBV_SCH="public"

# Database & schema where bien_metadata will be updated.
# Applies to process "db_version_update" only.
# Private production DB
BIEN_METADATA_DB_TO_UPDATE="vegbien"
BIEN_METADATA_DB_TO_UPDATE_USER="bien"
BIEN_METADATA_SCH_TO_UPDATE=$dev_schema_adb_private
# Public production DB
# BIEN_METADATA_DB_TO_UPDATE="vegbien"
# BIEN_METADATA_DB_TO_UPDATE_USER="bien"
# BIEN_METADATA_SCH_TO_UPDATE=$prod_schema_adb_private

##############################################################
# Current default WHERE FILTER for querying BIEN range model 
# observations from vfoi
#
# IMPORTANT: 
#	1. To deactivate this clause, set to " 1 " (=true), 
# not "" (empty string)! Otherwise queries that invoke it 
# will fail.
#	2. Omit 'WHERE' at start of clause
##############################################################

# NOTE: the clause for is_location_cultivated is TOO conservative; will exclude
# known good records where is_location_cultivated='f'. Clause should be:
# AND (is_location_cultivated='f' OR is_location_cultivated IS NULL)

base_where=" scrubbed_species_binomial IS NOT NULL AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND is_location_cultivated IS NULL AND is_invalid_latlong=0 AND is_geovalid = 1 AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) AND (georef_protocol is NULL OR georef_protocol<>'county_centroid') AND (is_centroid IS NULL OR is_centroid=0) AND ( EXTRACT(YEAR FROM event_date)>=1970 OR event_date IS NULL ) "

# Addition WHERE citeria to add to the base where clasue
optional_where="AND (is_introduced=0 OR is_introduced IS NULL) AND observation_type IN ('plot','specimen','literature','checklist')  "

SQL_WHERE_DEFAULT="${base_where} ${optional_where}"
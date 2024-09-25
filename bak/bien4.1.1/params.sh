#!/bin/bash

##############################################################
# Global application parameters
# Check and change as needed
##############################################################

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
dev_schema_core_private="vegbien_dev"
prod_schema_core_private="public"
dev_schema_adb_private="analytical_db_dev2"
prod_schema_adb_private="analytical_db"
dev_schema_adb_public=$dev_schema_adb_private	# these two must be identical!
prod_schema_adb_public="public"
prod_schema_geom="public"
postgis_schema="postgis"	# Main postgis schema
dev_schema_users="users_dev"
prod_schema_users="users"

# true to load phylogenies, false to skip
# Set to false for development purposes only (to speed up)
load_phylo='true'

# Set to true to force replacement of table higher_taxa 
# This happens in step 2 during TNRS updates
higher_taxa_force_replace="false"

# Set to 'true' to move raw data tables to their own schemas
# named after each source. Otherwise, set to false to just drop
# raw data tables.
archive_raw='false'

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="/home/boyle/bien3/analytical_db"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path="functions/sh"
functions_path="/home/boyle/functions/sh"

# Path to data directory
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
#data_base_dir="/home/boyle/bien3/analytical_db/private/data"
data_base_dir="data"		 # Relative path

# Global record limit, for testing
# Applied if use_limit="true"
# Can be over-ridden for any one source by setting sql_limit_local,
# unless sql_limit_force="true"
recordlimit=1000
use_limit="false"	# true,false; use sql_limit_global
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

# Set process names, for notification and screen echo
if [ -n "$master" ]; then 
	master_basename="${master/.sh/}"
	if [ "$master_basename" == "adb_private_1_load_data" ]; then
		pname="Build Private ADB - Step 1"
	elif [ "$master_basename" == "adb_private_2_update_taxa" ]; then
		pname="Build Private ADB - Step 2"
	elif [ "$master_basename" == "adb_private_3_update_metadata" ]; then
		pname="Build Private ADB - Step 3"
	elif [ "$master_basename" == "adb_private_4_final_updates" ]; then
		pname="Build Private ADB - Step 4"
	elif [ "$master_basename" == "adb_public" ]; then
		pname="Build Public ADB"
	elif [ "$master_basename" == "adb_move_to_production" ]; then
		pname="Move to production"
	elif [ "$master_basename" == "adb_private_2_update_taxa_TEMP_restart" ]; then
		pname="Build Private ADB - Step 2 (_TEMP_restart)"
	elif [ "$master_basename" == "adb_private_3_update_metadata_pt2_custom_major_taxon_bien4.1" ]; then
		pname="Build Private ADB - Step 3, part 2 (custom: major_taxon)"
	elif [ "$master_basename" == "adb_private_3_update_metadata_pt2_custom_major_taxon_bien4.1_resume" ]; then
		pname="Build Private ADB - Step 3, part 2 (resume)"
	elif [ "$master_basename" == "adb_private_3_update_metadata_rebuild_bien4.1" ]; then
		pname="Build Private ADB - Step 3 (rebuild)"
	else
		pname="$master_basename"
	fi

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
# Omit trailing slash
##############################################################

# Relative path to GNRS root application directory & data directory
gnrs_dir="../../../gnrs_v1.1.1/gnrs"
db_gnrs="gnrs"
gnrs_data_dir="/home/boyle/bien3/gnrs/userdata"

# Relative path to NSR root application directory
nsr_dir="../../../nsr"
db_nsr="nsr"

##############################################################
# Module "bien_metadata.sh":
# DB version parameters
##############################################################

# New database version details
# Complete these if $insert_new='true'
BIEN_METADATA_DB_VERSION_NEW='4.1.1'
BIEN_METADATA_VERSION_COMMENTS="Minor update: set zero/negative plot areas to NULL"

# DB code version associated with this db release
# Only add this tag after full build completed and moved
# to production
BIEN_METADATA_DB_CODE_VERSION='v4.2.1'

# Latest rbien version associated with this 
BIEN_METADATA_RBIEN_VERSION='1.2.3'

# Latest rtodobien version associated with this release
BIEN_METADATA_RTODOBIEN_VERSION='1.2.3'

# Version of TNRS used to scrub names for this release
BIEN_METADATA_TNRS_VERSION='4.0'

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

# Database & schema where main current db version table lives
# These parameters used only for determining current version.
# May or may not be same as $sch
# Private production DB
BIEN_METADATA_DBV_DB="vegbien"
BIEN_METADATA_DBV_USER="bien"
BIEN_METADATA_DBV_SCH=$prod_schema_adb_private
## Public production DB
#BIEN_METADATA_DBV_DB="public_vegbien"
#BIEN_METADATA_DBV_USER="bien"
#BIEN_METADATA_DBV_SCH="public"

# Database & schema where version information in table bien_metadata
# will be updated. Applies to process "db_version_update" only
## Private production DB
BIEN_METADATA_DB_TO_UPDATE="vegbien"
BIEN_METADATA_DB_TO_UPDATE_USER="bien"
BIEN_METADATA_SCH_TO_UPDATE=$prod_schema_adb_private
# Public production DB
# BIEN_METADATA_DB_TO_UPDATE="vegbien"
# BIEN_METADATA_DB_TO_UPDATE_USER="bien"
# BIEN_METADATA_SCH_TO_UPDATE=$prod_schema_adb_private
#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Name of the raw data file to be imported. 
# Place in the designated data directory
raw_traits_file="new_trait_table_8_29_2017.csv"

# DB version & comment
# For updating db version table at final step
#db_version="3.4.4"
#db_msg="New version of traits table (from file: traits_3_21_2017_utf8.csv)"

# Parent directory for this application
app_dir="agg_traits"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/data/traits"

# Short name for this operation, for screen echo and 
# notification emails
pname_1="Refresh traits: Import"
pname_3="Refresh traits: TNRS"
pname_4="Refresh traits: replace original (private)"
pname_5="Refresh traits: replace original (public)"
pname_500species="Execute 500 species embargo on table agg_traits"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=$pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
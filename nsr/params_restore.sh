#!/bin/bash

##############################################################
# Restores any parameters overridden in params_override.sh
# Only loaded if $params_override="t" (set in params.sh
# for this module)
#
# Note:
# * Original values were backed up previously as <param>_orig in 
# params_override.sh
##############################################################

db=$db_orig
sch=$sch_orig
submitted_filename=$submitted_filename_orig
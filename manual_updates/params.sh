#!/bin/bash

##############################################################
# Local parameters
# Check and change as needed
# In case of name collision with global parameters (in
# ../params.sh) local over-rides global
##############################################################

# Data directory
# Temp files saved here
data_dir="data"

# Set process names, for notification and screen echo,
# depending on which is being run

if [ "$local_basename" == "custom_script_template" ]; then
	pname_local="Example of a custom process name"
elif [ "$local_basename" == "bien4.1_data_dump_for_Cory_20181018" ]; then
	pname_local="Custom data dump for Cory"
else
	pname_local="$local_basename"
fi
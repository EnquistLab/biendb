#!/bin/bash

#########################################################################
# Extracts process names and times from log file to tab-delimited file
#
# Purpose: Delimited file enables quick import to spreadsheet for 
# 	benchmarking/performance analysis.
#
# Usage:
# 	logtime [-s] -l <logfile_path_and_name> [-t <timingfile_path_and_name>] 
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

######################################################
# Params
######################################################

# Activate this parameter to use instead of command line parameter
#logfile="logfile_adb_private_1_load_data.txt"

######################################################
# Functions
######################################################

trim() {
	##########################################
	# Trims leading and trailing whitespace
	##########################################

    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   
    echo -n "$var"
}


###########################################################
# Get options
#   -s  Silent mode. Suppresses confirmation message and screen echo.
#   -l	Name of logfile from which timing data will be parsed
# 	-t 	Name of file where timing data will be saved
###########################################################

i=true		# Interactive mode on by default

while [ "$1" != "" ]; do
    case $1 in
        -s | --silentmode )		i=false	# interactive mode off
        						;;
        -l | --logfile )        shift
                                logfile=$1
                                ;;
        -t | --timefile )        shift
                                timefile=$1
                                ;;
        * )                     echo "Error: bad parameters"; exit 1
    esac
    shift
done

if [ -z ${logfile+x} ]; then
	echo "Error: no logfile name"; exit 1
elif [ -z ${timefile+x} ]; then
	# Base name of timing file on logfile if no name given
	logfile_basename="${logfile/.txt/}"
	timefile=$logfile_basename"_time.tsv"
fi

if [ "$i" = true ]; then
	echo "Extract timing data from log file?

	Log file = $logfile
	Timing file = $timefile
	"
	read -p "Continue? (Y/N): " -r
	
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		continue="true"
	else 
		echo "Operation cancelled"; exit 0
	fi
fi

# Check logfile exists
if [ ! -f "$logfile" ]; then
	# file not found
	echo "File $logfile does not exist!"; exit 1	
fi

######################################################
# Main
######################################################

# Make new timing file
rm -f $timefile
touch $timefile
echo -e "Module""\t""Task""\t""Sec" >> $timefile	# Insert header

# Read through log file one line at a time
count=1
lines=$(wc -l < "$logfile")
module=""

while read -r line
do
	if [ "$i" = true ]; then echo -en "\rProcessing line "$count" of "$lines; fi
	
	# get indent level
	line=$(trim ${line})
	line_arr=($line) 	# Split the line on spaces
	tok1=${line_arr[0]}	# Get first token
	ilevel=0
	if [[ "$tok1" == "-" ]]; then
		ilevel=1
	elif [[ "$tok1" == "--" ]]; then
		ilevel=2
	elif [[ "$tok1" == "---" ]]; then
		ilevel=3
	else 
		ilevel=4
	fi
	
	# Remove the indent symbol
	if [ "$ilevel" -eq "1" ] || [ "$ilevel" -eq "2" ] || [ "$ilevel" -eq "3" ]; then
		line="${line/$tok1/}"
	fi
	line=$(trim ${line})
		
	if [[ "$line" =~ "module" ]]; then
		# Get name of module
		line="${line/module/|}"	# Turn 'module' into delimiter
 		IFS='|'; line_arr=($line); unset IFS;	# Split into array
 		x=${line_arr[1]}	# Get element after the delimiter
 		x=$(trim ${x})		# Trim whitespace
 		x="${x//\'/}"		# Remove single quotes
 		x="${x//:/}"		# Remove colon
 		module=$(trim ${x})		# Trim whitespace again
	
	elif [[ "$line" =~ "sec)" ]]; then
		# Get task and time in sec
		line="${line/...done/}"
		line="${line/\(/|}"		# Turn '(' into delimiter
		line="${line/sec\)/|}"	# Turn 'sec)' into delimiter
 		IFS='|'; line_arr=($line); unset IFS;	# Split into array
 		task=${line_arr[0]}; t=${line_arr[1]}
 		
 		# Get last token in case also have text in parentheses
 		t="${t//\(/|}"	# Turn all "(" into delimiters
 		IFS='|'; t_arr=($t); unset IFS;	# Split into array again
 		t=${t_arr[-1]}	# Get last element 
 		
 		task=$(trim ${task}); t=$(trim ${t})
 		
 		# Add higher level settings
 		if [ "$ilevel" -eq 1 ]; then
 			h1=""; h2=""; h3=""
 		elif [ "$ilevel" -eq 2 ]; then
 			h2=""; h3=""
 		elif [ "$ilevel" -eq 3 ]; then
 			h3=""
		fi 		
		header=$h1" "$h2" "$h3
		task=$header" "$task
		task=$(trim ${task})
		 		
 		printline="t"
	else
		# Line is task header without time, but not a module
		if [ "$ilevel" -eq "1" ]; then
			h1="$line"; h2=""; h3=""
		elif [ "$ilevel" -eq "2" ]; then
			h2="$line"; h3=""
		elif [ "$ilevel" -eq "3" ]; then
			h3="$line"
		fi
	fi
	
	if [[ "$printline" == "t" ]]; then
		echo -e "$module""\t""$task""\t""$t" >> $timefile
		printline="f"
	fi
	
	lastcount=$count
	let count=count+1
done < "$logfile"

if [ "$i" = true ]; then echo -en "\rProcessing line "$lastcount" of "$lines"...done"; echo ""; fi

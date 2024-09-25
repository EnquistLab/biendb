#!/bin/bash

check_pk() {
	##################################################
	# Check if candidate primary key column is unique
	#
	# Requires functions:
	#  exists_db_psql()
	#  exists_schema_psql()
	#  exists_table_psql()
	#  exists_column_psql()
	#
	# Parameters:
	#	n	No quit: don't exit on error (default: false)
	#	q	Quiet: no progress echo unless error (default: false)
	#	h	Host (default: localhost)
	#	u	User 
	#	d	Database 
	#	s	Schema 
	#	t	Table 
	#	c	Column to check
	#	
	# Usage:
	#	check_pk [-q] [-n] [-h $host] -u $user -d $db -s $sch -t $tbl -c $col
	##################################################

	local host='localhost'
	local e='f'

	# Dummy values double as automatic error messages 
	# Also prevent dangerous parameter skipping
	local user='no-user-defined'
	local db='no-db-defined'
	local sch='no-schema-defined'
	local tbl='no-table-defined'
	local col='no-column-defined'
	local exit_on_error='t'
	local quiet='f'

	# Get parameters
	while [ "$1" != "" ]; do
		# Get options, treating final 
		# token as message		
		#send="false"
		case $1 in
			-h )			shift
							host=$1
							;;
			-u )			shift
							user=$1
							;;
			-d )			shift
							db=$1
							;;
			-s )			shift
							sch=$1
							;;
			-t )			shift
							tbl=$1
							;;
			-c )			shift
							col=$1
							;;
			-n )			exit_on_error='f'
							;;
			-q )			quiet='t'
							;;
		esac
		shift
	done	
	
	# Validate parameters
	if [[ $(exists_db_psql $db) == "f" ]]; then
		echo "$db: no such database (func drop_all_indexes)"; exit 1
	fi
	if [[ $(exists_schema_psql -h $host -u $user -d $db -s $sch) == "f" ]]; then
		echo "$sch: no such schema in db $db (func check_pk)"; exit 1
	fi
	if [[ $(exists_table_psql -h $host -u $user -d $db -s $sch -t $tbl) == "f" ]]; then
		echo "$tbl: no such table in schema $sch (func check_pk)"; exit 1
	fi
	if [[ $(exists_column_psql -h $host -u $user -d $db -s $sch -t $tbl -c $col) == "f" ]]; then
		echo "$col: no such column in table ${sch}.${tbl} (func check_pk)"; exit 1
	fi

	if [ "$quiet" == "f" ]; then
		echo -n "- Checking candidate pkey ${col} in table ${tbl}..."
	fi
	
	sql_is_unique="SELECT NOT EXISTS ( SELECT ${col}, COUNT(*) FROM ${sch}.${tbl} GROUP BY ${col} HAVING COUNT(*)>1 ) AS a"
	is_unique=`psql -h $host -U $user -d $db -qt -c "$sql_is_unique" | tr -d '[[:space:]]'`
	if [[ "$is_unique" == "f" ]]; then
		echo "ERROR: Column \"$col\" NOT UNIQUE!"
		if [ "$exit_on_error" == "t" ]; then
			exit 1
		fi
	else
		if [ "$quiet" == "f" ]; then
			echo "OK"
		fi
	fi

}

drop_indexes() {
	##################################################
	# Drops all indexes on table $table in schema $sch
	# of database $db
	#
	# Requires functions:
	#  echoi()
	#  exists_db_psql()
	#  exists_schema_psql()
	#  exists_table_psql()
	#
	# Parameters:
	#	q	quiet, no confirmation or progress echoes
	#	p	drop primary key (default: false)
	#	h	host (default: localhost)
	#	u	user name
	#	d	database name
	#	s	schema name
	#	t	table name
	#	
	# Usage:
	#	drop_all_indexes [-q] [-p] [-i] [-h $host] -u $user -d $db -s $schema -t $table
	##################################################

	local host='localhost'
	local quiet='f'
	local e='true'
	local drop_pk='f'
	local what='all indexes'

	# Dummy values double as automatic error messages 
	# and prevent dangerous parameter skipping
	local user='no-user-defined'
	local db='no-db-defined'
	local sch='no-schema-defined'
	local tbl='no-table-defined'

	# Get parameters
	while [ "$1" != "" ]; do
		# Get options, treating final 
		# token as message		
		#send="false"
		case $1 in
			-h )			shift
							host=$1
							;;
			-u )			shift
							user=$1
							;;
			-d )			shift
							db=$1
							;;
			-s )			shift
							sch=$1
							;;
			-t )			shift
							tbl=$1
							;;
			-q )			quiet='t'
							e=''
							;;
			-p )			drop_pk='t'
							;;
		esac
		shift
	done	
	
	if [ "$drop_pk" == "t" ]; then
		what="primary key and $what"
	fi 
	
	if [ "$quiet" == "f" ]; then
		read -p  "Drop ${what} on table ${tbl} in schema ${sch} of db ${db}? (Y/N): " -r

		if ! [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "Operation cancelled"
			exit 0
		fi
	fi
	
	# Validate parameters
	if [[ $(exists_db_psql $db) == "f" ]]; then
		echo "$db: no such database (func drop_all_indexes)"; exit 1
	fi
	if [[ $(exists_schema_psql -u $user -d $db -s $sch) == "f" ]]; then
		echo "$sch: no such schema in db $db (func drop_all_indexes)"; exit 1
	fi
	if [[ $(exists_table_psql -u $user -d $db -s $sch -t $tbl) == "f" ]]; then
		echo "$tbl: no such table in schema $sch (func drop_all_indexes)"; exit 1
	fi

	echoi $e "Dropping indexes:"
	local sql_indexes="select indexname from pg_indexes where schemaname='${sch}' and tablename='${tbl}' and indexname not like '%_pkey%' order by indexname"
	for idx in $(psql -h localhost -U $user -d $db -qt  -c "$sql_indexes"); do
		echoi $e -n "  "$idx"..."
		local sql_drop_idx="DROP INDEX IF EXISTS ${idx}"
		PGOPTIONS='--client-min-messages=warning' psql -h $host -U $user -d $db -q << EOF
		\set ON_ERROR_STOP on
		SET search_path TO $sch;
		$sql_drop_idx
EOF
		echoi $e "done"
	done
	
	if [ "$drop_pk" == "t" ]; then
		echoi $e "Dropping primary key:"
		local sql_indexes="select indexname from pg_indexes where schemaname='${sch}' and tablename='${tbl}' and indexname like '%_pkey%' order by indexname"
		for idx in $(psql -h localhost -U $user -d $db -qt  -c "$sql_indexes"); do
			echoi $e -n "  "$idx"..."
			local sql_drop_idx="ALTER TABLE ${tbl} DROP CONSTRAINT IF EXISTS ${idx}"
			PGOPTIONS='--client-min-messages=warning' psql -h $host -U $user -d $db -q << EOF
			\set ON_ERROR_STOP on
			SET search_path TO $sch;
			$sql_drop_idx
EOF
			echoi $e "done"
		done
	fi
	
}
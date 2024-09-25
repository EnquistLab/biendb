Perform the following generic changes to adapt scripts from repo backend:

1. Copy app directory & entire contents
2. Inside app direct, delete all files and directories except:
	- main app shell script
	- params.inc
	- sql/
	- data/ [only keep if data import involved]
3. In params file:
	- Remove any parameters already set properly by master parameters file
	- Define data_dir_local_abs if needed
	- Define any custom schema variables if needed
	- Add the following parameters:
		$pname_local
		$pname_header
		$db_main
4. In data directory, add any files specific to this component
5. In main application script:
	- Replace contents of parameters section with entire parameters section  
	  from model component script, 'copy_core_tables.sh'
	- Replace '$DIR/$app_dir/sql/' with '$DIR_LOCAL/sql/'
	- Replace '$DIR/sql/' with '$DIR_LOCAL/sql/'
	- Replace '${data_dir}/data/' with '${data_dir_local}/'
	- Inspect each variable $db[xxx] and replace with appropriate version 
		($db_private or $db_public). BE VERY CAREFUL!
	- In each SQL command, insert references to any schema parameters needed, 
		e.g., replace '-q -f' with '-q -v dev_schema=$dev_schema -f'
	- After each SQL command, replace entire exit status block (if..then..else)
		with the single-line 'source "$DIR/includes/check_status.sh"'
	- Replace "Report total elapsed time and exit" section at end with  
		single line command 'source "$DIR/includes/finish.sh"'. Add this  
		section if not already present
	- Replace instances of "echoi -i" with "echoi -e", if any
6. In SQL files:
	- Replace all hard-coded schema names with parameters
7. After testing:
	- Remove any limits added to SQL (e.g., 'LIMIT 100')
	- Remove block comments

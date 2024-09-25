# Creates data_dictionary tables listing names, data types, null attributes, comments and constrained values for all tables, columns and controlled  
vocabulary 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Creates tables data_dictionary_tables (table names and comments), data_dictionary_columns (column names, data types, null attributes, and comments) and data_dictonary_values (values and definitions for all column values which use controlled vocabulary).

In step 1 (create) tables are first created by querying the underlying postgres metadata for the current schema. Tables may then be optionally updated with comments from previous (production) version of the database. Finally, contents of each table are dumped to CSV files for manual revision.

In step 2 (update) data dictionary tables are updated from revised CSV files. Also transfers comments to postgres metadata.

### II. Requirements

UTF-8 CSV dump of spreadsheet must be present in the data directory specified in the params file. Revised file should have same name as original file dumped in step 1, with suffix "_revised" inserted between file name and extension.

### III. Usage

Can be sourced as part of main DB pipeline, or run standalone as follows.

Step 1: Create data dictionary tables, optionally update with comments from previous database, and dump CSV files for editing:

```
./data_dictionary_1_create.sh

```
Step 2: Update tables from revised CSV files, and commit comments to postgres information schema.

```
./data_dictionary_2_update.sh

```

* Options:  
  -m: Send notification emails  
  -s: Silent mode  


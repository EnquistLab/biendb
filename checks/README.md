# Checks integrity of primary keys 

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Overview

Miscelleaneous check for servicdes, databases, tables, etc., required for db pipeline to run successfully. Also includes checks on table integrity which may be run at various points to stop the pipeline in case of errors.

Each is a standalone script, but may require one or more parameters from the global params.sh file.

### I. Usage

#### check_pks.sh, 
* Checks that PK column values are unique and non-null
* Stops execution if violation found
* Use to confirm integrity after steps that require stripping indexes & keys
* Table and PK column name parameters set directly in file
* Must be called by higher level script using source command
* Does not accept arguments, parameters must already be defined inside calling script 
* Requires params $user, $db_private, $dev_schema_adb_private 

```
source "check_pks/check_pks.sh"
```

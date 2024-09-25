# BIEN Database Updates

## Overview

This directory contains scripts for between-major-version changes and updates to the BIEN database. In most cases, these updates are run as hotfixes on the live database, either by altering/updating the live production tables, or by altering/updating copy tables, which are then swapped out for the production tables inside a transaction block.

Updates are of two types: 

1. **Interactive**. Individual SQL scripts which are typically implemented by pasting the commands inside the interactive Postgres interface (or alternatively by invoking the entire script from the psql command line). The entire update may consist of a single script, or a series of scripts, invoked in a sequence described in a README within the update subdirectory. Interactive scripts are contained within a subdirectory bearing the version number of the update.
2. **Pipeline**. Pipeline updates consist of a single shell script bearing the name of the update, and one or more sql scripts (in subdirectory `sql/`), also named for the update version. The entire update is executed by invoking the shell script. The pipeline script typically invokes the global params file (in the bien db base directory, on directory above this one), and may also invoke a update-specific parameter file in this directory. The latter, if any, will be named `params_[UPDATE_VERSION].sh`.

## Versioning

Updates will always require a change in the version number, typically an increment in the minor version (third number: [major#].[minor#].[patch_or_hotfix#]). Some updates may be consequential enough to merit and increment of the minor version instead. Be sure to add a new record to the main metadata table (`bien_metadata`) at the conclusion of the update. Changes requiring an increment to the major version should be implemented via the main BIEN DB pipeline, never as updates.

## Apply updates to both databases!

Don't forget to apply the update to both BIEN databases: the private database (`vegbien.analytcal_db`) and the public database (`public_vegbien.public`).

## Usage

### Interactive updates

Execute the code in the sql files in the interactive update subdirectory. This is usually best done by pasting the commands in sequence into the interactive Postgres interface. If the commands can safely be executed by invoking the sql script or scripts from the psql command line, this should be explained in a README within the update directory. If >1 script, please indicate the sequence of execution in the update README.

As some manual adjustment of parameters is always required, please read the script carefully and adjust parameters as needed before running.

### Pipeline updates

Execute the main update shell script, after inspecting and adjusting any parameters. 
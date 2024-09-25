# BIEN analytical database pipeline

Contributors:   
* Brad Boyle (bboyle@arizona.edu)  
* Daniel Guaderrama   

Date created: 25 September 2024

### Contents

I. Background 
II. Overview  
III. System and software requirements  
IV. Dependencies  
V. Usage  
VI. Caveats  

### I. Background

This repository is based on the original BIEN database pipeline in repository EnquistLab/biendb.git. The latter was used to build BIEN databases up to and including version 4.2.7. The code pipeline in this repository builds BIEN database versions 5.0 and up.

### II. Overview

These scripts generate the complete BIEN private and public analytical databases (private ADB and public ADB, respectively) and the BIEN users database (user DB). T

The analytical database contains multiple, denormalized views (actually, tables and materialized views) of the BIEN core data, optimized for rapid read-only access. 

The private ADB and the user DB are schemas within PostGreSQL database "vegbien". The private DB is accessed by BIEN admin and collaborators using personal logins only. 

The public DB is a subset of the private DB from which non-public datasets have been removed and locality information for endangered species hidden. The public DB can be accessed using one of several BIEN read-only user, including anonymous user bien_public used by all instances of the RBien R package.

Top-level scripts in the base directory (private/) comprise an ordered pipelines that runs a series of modules, each of which performs a distinct task. Sequence of execution of top-level scripts is described below. A single global parameter file in the base directory is referenced by all top-level scripts and module master scripts. Directory functions/ contains shared functions. Directory includes contains shared utility shell scripts "sourced" by top-level and module scripts. 

Each module lives in its own subdirectory, and consists of the module master (shell) script, a local parameters file, a module-specific README file, and one or more SQL files in subdirectory sql/. SQL files are executed by the master script. In most cases the module master script bears the same name as the subdirectory. If the module contains more than one master script, the scripts will be named with a suffix indicating the order in which they should be executed. Master scripts reference the global params file in addition to the local params file. 

Database configuration files are stored externally to this repository, although templates are provided. All data are stored in a data directory and subdirectory external to this repository.

### III. System and software requirements

OS & utilities
Ubuntu 18.04
sed: bash-specific implementation

RDBMS
PostGreSQL 10+

Languages
Perl v5.22.
PHP 7+

Applications:
dos2unix

Shell commands:
iconv

### IV. Dependencies

1. Legacy table view_full_occurrence_individual in core BIEN schema vegbien.public. 

2. Genus-in-family lookup table "genus_family"

Table genus_family must be present in database gf_lookup. Table genus_family is a lookup of all accepted genus-in-family classifications from The Plant List. This table was prepared previously in PHP/MySQL in database gf_lookup on nimoy. Use this table rather than gf_lookup from the TNRS database; it is more comprehensive.

3. Database geoscrub

Database geoscrub must be present. Required for module gnrs/, plus tables countries, alt_country, state_province and county_parish are imported from this database to bien db. See module gnrs_db/ in repo gnrs (not part of bien db pipeline).

4. GNRS

Standalong application, called directly by BIEN DB pipeline. See modules gnrsdb/ and gnrs/ in repo gnrs.

5. NSR

Standalone application. Processing results required by BIEN DB pipeline. See repo nsr.

6. Geovalidation

Standalone application, verifies that coordinates fall within polygon of declared political divisions. Results required by BIEN DB pipeline. Currently in R only. Need to be ported to bash/postgres/postgis.

7. Centroids

Standalone application, calculates various statistics required for deciding if coordinate is a political division centroid rather than a directly-measured location of observation. Results required by BIEN DB pipeline. Currently in R only. Need to be ported to bash/postgres/postgis.

8. Database tnrs4

TNRS database tnrs4 must be present. Entire TNRS database is required to  
generate higher taxon lookup tables. 

9. TNRS

Standalone application. Currently uses tnrs_batch, Naim Matasci's multi-threaded port of core TNRS services. Results required by BIEN DB pipeline. 

### V. Usage

1. Generate endangered species tables. This is done in three steps. See scripts and documentation in directory make_endangered_species_tables/ for details. You MUST complete this operation before running the main script (build_adb_private.sh) as the latter requires endangered_species tables.

2. Generate analytical tables in development schema

```
$ /.build_adb_private.sh -m

```

3. Copy completed analytical tables from development to production schema, replacing original production tables. This step is kept separate to allow Q&E validations on tables in development schema prior to replacement. Assumes that scripts in make_endangered_species_tables/ have been run first. Scripts that update endangered species columns are part of this pipeline, and are found in directory update_endangered_species/.

```
$ /.replace_adb_private.sh [options]

```

3. General usage notes:

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * WARNING: Run from unix "screen" session; complete operation may take 
  	several days.

  * Options
	  -n  	No confirm. All interactive warnings suppressed
	  -s  	Silent mode. Suppresses screen echo.
	  -m	Send email notification. Must supply valid email 
	  		in params file.
	  -a	Append to existing logfile (=$glogfile). If not 
			provided, starts new logfile, replacing old if exists

### VI. Caveats

These scripts use as input the legacy analytical table vegbien.view_full_occurrence_individual, as generated from the core BIEN Database (in vegbien.public) by past BIEN developers. Ultimately, once the core database scripts have been revised, all ADB table will be generated directly from the core database and the legacy vegbien.view_full_occurrence_individual will not longer be used.   

# Creates table bien_summary in BIEN analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 11 Feb 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  
IV. Schema  
V. Notes 

### I. Overview

Creates table bien_summary, containing count of observations, plots, species, and other high-level metadata for the BIEN database. This table is used for displaying online summaries on the BIEN website.

Table is initially created in development schema, then copied to production schema if all preceeding operations successful. Subsequently, preserve summary information on past versions by copying existing table from production schema and appending updated summaries for new version.

### II. Requirements

Requires the following tables in the production public database:
  * view_full_occurrence_individual
  * bien_taxonomy
  * plot_metadata

### III. Usage

```
$ ./bien_summary.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from UNIX "screen" session, as complete 
    operation takes ~ half hour to run
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	
### IV. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
 bien_summary_id    | Integer primary key | not null auto-increment
 db_version         | database version    | not null
 summary_timestamp  | date summary record added | not null
 obs_count          | total observations                     | 
 obs_geovalid_count | total validly georeferenced observations | 
 specimen_count     | total specimen observations | 
 plot_obs_count     | total plot observations | 
 plot_count         | total plots             | 
 species_count      | total species           | 

### V. Notes

To refresh the table when changes are made to the underlying tables, just re-run the script.

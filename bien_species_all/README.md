# Creates analytical table bien_species_all

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 10 March 2017

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Create table bien_summary, containing counts (observations) of all unique species (binomials) in the BIEN database. 

### II. Schema

| Column | Meaning | Values (if constrained)
| ------ | ------- | -----------------------
 species    | All unique scrubbed species binomials | not null
 observations	| Total observations per species, from table view_full_occurrence_individual    | not null
 

### III. Usage

```
$ ./bien_species_all.sh 

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	

# Install required functions, extensions, etc.

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  

### I. Overview

Install all required functions, procedures, extensions, etc, if not already present.

#### Extensions

tablefunc - crosstabs/pivot tables
fuzzystrmatch - fuzzy matching using Levenshtein algorithm
pg_trgm - fuzzy matching using trigrams

#### Triggers


#### Procedures





### II. Usage


```
$ /.install_dependencies.sh -m

```
  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.

# Flags and removes non-embryophyte observations

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Imports table ncbi_species from database ncbi and flags non-plant taxa in bien database by joining to non-plant names. Species names in ncbi_names are matched to binomials in bien database using exact match only. Stores results of matching in column major_taxon in tables taxon, bien_taxonomy, vfoi, analytical_stem and agg_traits. 

### II. Dependencies

Postgres database "ncbi", containing derived table "ncbi_species". Run all scripts in separate repo "ncbi" to prepare these objects.

### III. Usage

```
$ ./major_taxon.sh [options]
```

Options:
  -s	silent mode  
  -m	send start, completion and error emails to email in params file
    

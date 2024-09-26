# Populates missing political division names for plot data sources in legacy table view_full_occurrence_individual 

#***DEPRECATED***  

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Deprecation notice
II. Overview  
III.Standalone usage  

### I. Deprecation notice

This legacy module is not longer needed as the problem has been resolved in the most recent versions of the BIEN database.

### II. Overview

1. fix_missing_poldivs_1.sh. Populates country for plot data sources CSV, NVS and Madidi. This step done before creating table plot_metadata.

2. fix_missing_poldivs_2.sh. Populates country for plot data source TEAM. Must be executed after creating table plot_metadata as column dataset required.

Temporary fix only. Won't be necessary once these sources are imported from scratch. 

### III. Standalone usage

```
$ ./fix_missing_poldivs_1.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


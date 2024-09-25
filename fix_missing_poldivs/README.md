# Populates missing political division names for plot data sources in legacy table view_full_occurrence_individual 

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents


I. Overview  
II.Standalone usage  

### I. Overview

1. fix_missing_poldivs_1.sh. Populates country for plot data sources CSV, NVS and Madidi. This step done before creating table plot_metadata.

2. fix_missing_poldivs_2.sh. Populates country for plot data source TEAM. Must be executed after creating table plot_metadata as column dataset required.

Temporary fix only. Won't be necessary once these sources are imported from scratch. 

### II. Standalone usage

```
$ ./fix_missing_poldivs_1.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


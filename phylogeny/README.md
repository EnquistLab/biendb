# BIEN3 phylogenies

Branch author: Brad Boyle
bboyle@email.arizona.edu

### Overview

Contains scripts which populate table 'phylogeny' within the BIEN Analytical 
Database.  Each row contains an alternative newick-format phylogeny, stored as 
a TEXT object, plus associated metadata. 

### Data

The following files must be in the data directory:

bien_conservative_phy.tre
bien_grafted_phy_rep_1.tre
bien_grafted_phy_rep_2.tre
bien_grafted_phy_rep_3.tre

etc.

### Usage

```
$ ./phylogeny.sh
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

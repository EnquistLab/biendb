# Uploads new version of trait raw data file BIEN databases  

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  

### I. Overview

Creates agg_traits in development schema of private db and appends complete
new set of trait data from CSV. After populating traits table, extracts 
all trait records with non-null taxon and geocoordinates and appends to 
observation table (view_full_occurrence_individual) as observation_type 'trait observation'.


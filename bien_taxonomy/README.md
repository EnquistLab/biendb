# Builds table bien_taxonomy

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Version: v1.1  
Release date: 10 Aug 2016  

### Contents

I. Overview  
II. Schema  
III. Version Details	  
IV. Dependencies  
V. Preparation  
VI.	Usage  
VII. Sources  
VIII. Literature Cited  

### I. Overview

Creates & populates table bien_taxonomy in db public_vegbien.   
Table bien_taxonomy contains a select distinct of all unique TNRS-scrubbed  
taxon names in view_full_occurrence_individual (vfoi), including author,  
family, morphospecies & higher_plant_group.  

Integer FK bien_taxonomy_id is added to vfoi, allowing names to be linked  
back to the original records in which they occur.   

Missing families are added using a lookup table of all genus-in-family  
classifications extracted from The Plant List. Higher taxa above the level  
of family are populated using the Tropicos version of APG III from the TNRS  
database. 

Column scrubbed_taxonomic_status refers to the taxonomic status of the final  
resolved name, not the matched name (in contrast to vfoi, in which column  
taxonomic_status refers to the status of the matched name).  
Scrubbed_taxonomic_status is populated by tagging all names for which   
the TNRS was able to provide an accepted name (i.e., all names in vfoi where   
taxonomic_status equals "accepted" or "synonym"). For all other names, the  
verbatim value of vfoi.taxonomic_status is used. 

### II. Schema

| Column | Contents
| ------ | --------
bien_taxonomy_id            | Integer primary key
higher_plant_group          | Copied from vfoi. Some missing values populated.
division                    | APG III higher taxon
class                       | APG III higher taxon
subclass                    | APG III higher taxon
superorder                  | APG III higher taxon
order                       | APG III higher taxon
scrubbed_family             | Copied from vfoi. Some missing values populated.
scrubbed_genus              | Copied verbatim from vfoi
scrubbed_species_binomial   | Copied verbatim from vfoi
scrubbed_taxon_name_no_author    | Copied verbatim from vfoi
scrubbed_author             | Copied verbatim from vfoi  
scrubbed_species_binomial_with_morphospecies    | Copied verbatim from vfoi  
scrubbed_taxonomic_status   | Taxonomic status of resolved name according to TNRS  
observations                | Number of observations for this name in vfoi  

### III. Version details

This version (1.1) builds bien_taxonomy as a single, automated operation  
by executing master script bien_taxonomy.sh. Switch -m sends start, stop  
and error emails. Parameters set in db_config.sh and params.sh.  

### IV. Dependencies

1. Genus-in-family lookup table

Table genus_family must be present in database gf_lookup. 

Table genus_family is a lookup of all accepted genus-in-family   
classifications from The Plant List. This table was prepared previously in   
PHP/MySQL in database gf_lookup on nimoy. Use this table rather than gf_lookup  
from the TNRS database; it is more comprehensive.

2. TNRS database

TNRS database tnrs4 must be present. Entire TNRS database is required to  
generate higher taxon lookup tables. 

### V. Preparation

1. Get table genus_family

  (a) Copy MySQL database gf_lookup from nimoy.nceas.ucsb.edu to postgres on  
  vegbiendev
  * Recommend using FromMySqlToPostgreSql
  * Source: https://github.com/AnatolyUss/FromMySqlToPostgreSql). 
  * See separate documentation on configuring MySQL and Postgres to use this  
  application.
  
  (b) Change ownership of database and tables

	```
	ALTER DATABASE gf_lookup OWNER TO bien;
	ALTER TABLE family OWNER TO bien;
	ALTER TABLE genus OWNER TO bien;
	ALTER TABLE genus_family OWNER TO bien;
	ALTER TABLE homonym_genera OWNER TO bien;
	ALTER TABLE readme OWNER TO bien;
	```

  (c) Copy table "genus_family" from "gf_lookup" to DB "public_vegbien":

	```
	$ pg_dump -t genus_family gf_lookup | psql public_vegbien
	```

  (d) Grant SELECT permission to public_vegbien:

	```
	GRANT SELECT ON genus_family TO public_bien;
	```

2. Get TNRS database

  (a) Copy MySQL database tnrs4 from nimoy.nceas.ucsb.edu to postgres  
  on vegbiendev using FromMySqlToPostgreSql  
  * Recommend using FromMySqlToPostgreSql (see details above)  

  (b) Change ownership of database and all tables to user bien

### VI. Usage

1. Set database parameters in db_config.sh.

2. Set application parameters in params.sh.

3. Run the master script, bien_taxonomy.sh.

```
$ ./bien_taxonomy.sh -m
```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Use -s switch for silent mode  
  * Strongly recommend running from "screen" session, as complete operation   
    takes approximate 40 hours.
    
### VII. Sources

Higher taxa were assigned according to the classification used by Tropicos   
(Tropicos 2014) as archived in the TNRS database, v4.0  
(TNRS 2015; see Boyle et al. 2013). Tropicos (2014) follows  
APG III for angiosperms (Chase & Reveal 2009, Chase et al., 2009) and  
Christenhusz, Reveal & Farjon (2011) for gymnosperms. [I'm not sure what  
classifications they follow for ferns, lycophytes and bryophytes. I have  
written to them and will update this section when I hear back].

Operationally, families were assigned to the resolved taxon at the time of name  
resolution by the TNRS (using the Tropicos 2014 classification, as described  
above).  Because Tropicos is missing many Old World taxa, families could not  
be assigned to some Old World taxa by the TNRS. The present script attempts to  
"fill in" these missing families using a genus-in-family classification  
extracted from the database of The Plant List (TPL 2015). To avoid assigning  
erroneous families attached to homonym genus names, only genera with a single,  
unambiguous family assignment are included in this list. Finally, higher taxa  
above the rank of family are assigned by joining the family, using higher  
classification from Tropicos, as recorded in the TNRS database (see citations  
above). 

### VIII. Literature Cited

Boyle, B., N. Hopkins, Z. Lu, J. A. Raygoza Garay, D. Mozzherin, T. Rees, N.  
Matasci, M. L. Narro, W. H. Piel, S. J. McKay, S. Lowry, C. Freeland, R. K.  
Peet, and B. J. Enquist, 2013. The taxonomic name resolution service: an online  
tool for automated standardization of plant names. BMC bioinformatics 14:16.

Chase, M. W., and J. L. Reveal, 2009. A phylogenetic classification of the land  
plants to accompany APG III. Botanical Journal of the Linnean Society  
161:122–127.

Chase, M. W., M. F. Fay, J. L. Reveal, D. E. Soltis, P. S. Soltis, P. F, A. A.  
Anderberg, M. J. Moore, R. G. Olmstead, P. J. Rudall, and K. J., 2009. An update  
of the Angiosperm Phylogeny Group classification for the orders and families  
of flowering plants: APG III. Botanical Journal of the Linnean Society  
161:105–121.

Christenhusz, M., J. Reveal, and A. Farjon, 2011. A new classification and   
linear sequence of extant gymnosperms. Phytotaxa 70:55–70.

TNRS, 2015. Taxonomic Name Resolution Service [Internet]. Available from:  
http://tnrs.iplantcollaborative.org/. [Accessed May ?, 2015] 

TPL, 2015. The Plant List [Internet]. Available from: www.theplantlist.org.  
[Accessed 31 Aug. 2015]

Tropicos, 2014. Tropicos.org [Internet]. Missouri Botanical Garden, St. Louis,  
MO, USA. Available from: http://www.tropicos.org. [Accessed 19 Dec 2014].

    

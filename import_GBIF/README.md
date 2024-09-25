# Import gbif data to analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  
Release date: 21 Aug 2017

### Contents

I. Overview  
II. Details  
III. Usage  

### I. Overview

Imports prepared GBIF occurrence file (occurrence.txt), as extracted from a DWCA dump of Kingom Plantae from GBIF. See README in data directory  for instructions on how to request and download the dwca dump, and prepare the raw occurrence file.

### II. Details

#### Major standardizations and corrections
* Parses & corrects dates in dateidentified and evendate columns and converts to integer yyyy, mm and dd values
* Transforms GBIF column basisOfRecord as follows, then inserts to BIEN column observation_type:

```
CASE
WHEN "basisOfRecord"='HUMAN_OBSERVATION' THEN 'human observation'
WHEN "basisOfRecord"='LITERATURE' THEN 'literature'
WHEN "basisOfRecord"='MATERIAL_SAMPLE' THEN 'material sample'
WHEN "basisOfRecord"='OBSERVATION' THEN 'unknown'
WHEN "basisOfRecord"='PRESERVED_SPECIMEN' THEN 'specimen'
WHEN "basisOfRecord" IS NULL THEN 'unknown'
ELSE 'unknown'
END
```

* Populates BIEN columns is_cultivated_observation and is_location_cultivated based on GBIF column establishmentMeans:

```
CASE 
WHEN "establishmentMeans"='MANAGED' THEN 1
WHEN "establishmentMeans"='NATIVE' THEN 0
ELSE NULL
END
```

#### Filters
* Removes observations from the following BIEN primary providers: ARIZ, BRIT, HVAA, MO, NCU, NY, TEX, U, UNCC (i.e., derived duplicate observations)
* Removes unwanted/unreliable basisOfRecord classes:

```
WHERE "basisOfRecord" NOT IN (
'FOSSIL_SPECIMEN',
'LIVING_SPECIMEN',
'MACHINE_OBSERVATION'
)
```

### III. Usage

* Ensure that prepared raw data file is in data directory.
* Set data directory path in global params.sh
* Set raw data file name in local params.sh (this directory)
* Invoke this file from master pipeline script:

```
source import_GBIF/import.sh
```

* Or, run this file standalone:

```
$ ./import.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Recommend running from UNIX "screen" session
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	

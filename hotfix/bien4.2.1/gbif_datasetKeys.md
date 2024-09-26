# Refactor BIEN to support GBIF datasetKeys

## Key info
* These steps are manually executed
* Not yet incorporated into BIEN DB pipeline
* Updated to BIEN production database as hotfix version 4.2.1

## Overview

Daniel Noesgaard (GBIF, dnoesgaard@gbif.org) requested we support tracking of downloads of individual datasets to avoid over-citation. Currently RBIEN supports citation only of the entire GBIF download via its DOI. GBIF has recently developed a new API which can return citation information on individual datasets in response to requests containing the dataset identifier contained in column datasetKeys in the raw GBIF download. 

Although datasetKey can be retrieved by joining to the raw GBIF data in table "gbif_occurrence_raw" in schema "GBIF", the join will degrade performance and is a hard-wired, source-specific solution. As BIEN already supports the concept of dataset (as represented by FK column vfoi.dataset and identified (in part) as tuples in table datasource), a more general solution is to mormalize datasets to their own table, identified by their own primary keys, and to store the new PK and the original, datasource-specific keys, if any (e.g., datasetKeys in the case of GBIF) as foreign keys in table vfoi. This refactoring will also require separating primary_providers from datasets, which are currently conflated in table datasource, and storing them in their own table, proximate_provider. The PK of this table will also be added to vfoi. 

Ultimately, we should retire table datasource as it content is redundant and fully represented in tables proximate_provider and dataset. However, keep for now for backward compatibility with RBIEN. For stability, I will also store the existing values of datasource_id to the new tables as foreign keys.

## Create & populate columnn vfoi.dataset_id_orig

```

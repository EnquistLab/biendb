#Creates and populates table bien_metadata

Author: Brad Boyle (bboyle@email.arizona.edu)

### Overview

Updates table 'bien_metadata' with information on DB version & release date.

### Usage

```
./bien_metadata.sh
```

Be sure to set new version parameters in params file.


#### To select information on the most recent version:

```
SELECT db_version, db_release_date
FROM bien_metadata a JOIN
(SELECT MAX(bien_metadata_id) as max_id FROM bien_metadata) AS b
ON a.bien_metadata_id=b.max_id
;
```
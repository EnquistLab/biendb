# Point-in-polygon geovalidation of declared political divisionsw

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  

### I. Overview

Checks that the declared political division (country, state, county) of an observation are correct by joining the coordinates to the declared polygons. Political division polygons are from GADM. Note that both GADM and observation political division names must first be standardized using the GNRS to ensure that names match.

This (preliminary) version uses existing table world_geom, an already-populated table of GADM political divisions. In future will modify "pdg_1_prepare" to build this table from scratch.

Scrubs tables "in situ" in BIEN DB. Future versions should follow general validation app template of exporting to separate app and importing results from app as CSV file.

### II. Usage

1. Prepare reference tables "world_geom", etc.

```
./pdg_1_prepare.sh [-<option1> -<option2> ...]
```

* Requires table world_geom

2. Scrub political divisions

```
./pdg_2_scrub.sh [-<option1> -<option2> ...]
```

* Options:
| Option | Purpose |
| ------ | ------- |
| s      | Silent mode |
| m      | Send start/stop/error ermails |


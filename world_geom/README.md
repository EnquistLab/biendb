# Prepare world_geom and related spatial tables

UNDER CONSTRUCTION

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Overview

Copies world_geom from schema of current db version to development version, generates separate political division spatial tables and scrubbed political division names in world_geom using GNRS. 

Based on old pdg, NOT original world_geom module.

Added BIEN 4.2.

### II. Usage

1. Prepare reference tables "world_geom", etc.

```
./wg_1_prepare.sh [-<option1> -<option2> ...]
```

* Requires table world_geom

2. Scrub political divisions

```
./wg_2_scrub.sh [-<option1> -<option2> ...]
```

* Options:
| Option | Purpose |
| ------ | ------- |
| s      | Silent mode |
| m      | Send start/stop/error ermails |


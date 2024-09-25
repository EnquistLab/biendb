# Update biendata.org geospatial db with latest adb observations tables

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Overview

Transfers updated tables used by biendata.org from the production observations adb to the the biendata server. This pipeline implements Jeanine's original update steps and does not include updated ranges schema.

### I. Usage

```
./update_biendata.sh [-<option1> -<option2> ...]
```


* Options:
| Option | Purpose |
| ------ | ------- |
| s      | Silent mode |
| m      | Send start/stop/error ermails |
| a      | Append to existing logfile [replaces file if omitted (default) |

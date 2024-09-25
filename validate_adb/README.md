# Performs automated validations & integrity checks on completed database

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Usage

Validate completed development private database

```
./validate_adb_private_dev.sh [-<option1> -<option2> ...]
```


* Options:
| Option | Purpose |
| ------ | ------- |
| s      | Silent mode |
| m      | Send start/stop/error ermails |
| a      | Append to existing logfile [replaces file if omitted (default) |

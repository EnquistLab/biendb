# Run vacuum analyze on all tables in schema

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Usage

```
./vacuum.sh [-<option1> -<option2> ...]
```

* Options:
| Option | Purpose |
| ------ | ------- |
| d      | database |
| u      | user |
| c      | schema |
| s      | Silent mode |
| m      | Send start/stop/error ermails |
| a      | Append to existing logfile [replaces file if omitted (default) |

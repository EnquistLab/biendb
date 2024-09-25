# RETIRED. REPLACED BY MODULE "set_permissions"


# Sets permissions for public analytical database

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Usage  


### I. Usage

```
$ ./adb_public_permissions.sh -m

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	

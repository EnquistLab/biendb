# Set permissions on all objects in schema multiple users 

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  
III. Notes

### I. Overview

Set privileges for all objects in schema for a list of users. Grants select privileges on all objects in schema to users in list users\_select, and full privileges to users in list users\_full. User lists are set in params.inc.

User lists are specified as follows:

```
users_select="
username1
username2
username3
"
```

### II. Usage

```
$ ./set_permissions.sh -[options]
```

  * Operation will abort if any SQL fails
  * If running standalone, use -m switch to generate start, stop and   
  	error emails. Valid email must be provided in main params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  

### III. Notes

1. You may also need to edit pg_hba file to enable users to connect to postgres.

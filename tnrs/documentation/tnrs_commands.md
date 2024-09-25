# TNRS commands for BIEN DB pipeline

* Command for executing TNRS manually until hook up new TNRS to pipeline
* Pay special attention to batch size
* For now, best if nbatch = available cores

## Run locally on vegbiendev
* sudo command reports time at end

```
cd /home/boyle/bien3/tnrs/data
time sudo /home/bien/tnrs/TNRSbatch/src/controller.pl -in "/home/bien/tnrs/data/user/tnrs_submitted.csv"  -out "/home/bien/tnrs/data/user/tnrs_submitted_scrubbed.tsv" -sources "tropicos,tpl,usda" -class tropicos -nbatch 20 -d t 
```


## Run on paramo
* sudo command reports time at end

### 1. On vegbiendev
```
cd /home/boyle/bien3/tnrs/data
tar -czf tnrs_submitted.csv.tar.gz tnrs_submitted.csv
scp -P 1657 tnrs_submitted.csv.tar.gz bboyle@paramo.cyverse.org:~/tnrs 
```

### 2. On paramo

```
cd /home/boyle/tnrs
tar -xzf tnrs_submitted.csv.tar.gz
time sudo /var/www/tnrs/tnrs_batch/src/controller.pl -in "/home/bboyle/tnrs/tnrs_submitted.csv"  -out "/home/bboyle/tnrs/tnrs_submitted_scrubbed.tsv" -sources "tropicos,tpl,usda" -class tropicos -nbatch 30 -d t 
```

### 3. On vegbiendev

```
cd /home/boyle/bien3/tnrs/data
scp -P 1657 bboyle@paramo.cyverse.org:~/tnrs/tnrs_submitted_scrubbed.tsv .
```

File is ready to import back to pipeline at this point





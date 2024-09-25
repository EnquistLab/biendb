# GNRS commands
* Command for executing GNRS manually until hook up new TNRS to pipeline
* Pay special attention to batch size

## Run locally on vegbiendev

```
cd /home/boyle/bien/gnrs/data/user
time /home/bien/gnrs/src/gnrspar.pl -in "/home/boyle/bien/gnrs/data/user/gnrs_submitted.csv"  -out "/home/boyle/bien3/tnrs/data/user/gnrs_submitted_scrubbed.tsv" -nbatch 288 -d t 
```

##



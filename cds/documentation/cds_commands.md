# CDS commands
* Command for executing CDS manually until hook up CDS to pipeline
* Pay special attention to batch size

## Run locally on vegbiendev

### Run a sample:

```
cd /home/boyle/bien/cds/data
sudo time /home/bien/cds/src/cdspar.pl -in "/home/bien/cds/data/cds_submitted_sample.csv"  -out "/home/bien/cds/data/cds_submitted_sample_scrubbed.tsv" -nbatch 20 -d t 
```

### Run a sample in non-parallel mode:

```
cd /home/boyle/bien/cds/data
/home/bien/cds/src/cds.sh -f "/home/bien/cds/data/cds_submitted_sample.csv"  -o "/home/bien/cds/data/cds_submitted_sample_scrubbed.tsv" 
```


### Run the full file:

```
cd /home/boyle/bien/cds/data
sudo time /home/bien/cds/src/cdspar.pl -in "/home/bien/cds/data/cds_submitted.csv"  -out "/home/bien/cds/data/cds_submitted_scrubbed.tsv" -nbatch 20 -d t 
```




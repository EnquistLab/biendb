# Logfile time parsing script

Author: Brad Boyle (bboyle@email.arizona.edu)  

### I. Overview

Extracts timing information from BIEN DB pipeline logfiles. Output is a tab-delimitted file with the following three columns:

| Column | Meaning |
| ------ | ------- |
| Module | Major process name (usually, the name of the module). Consists of one or more "Tasks". |
| Task | Single process to for which total time was recorded. |
| Sec | Time in sec of the "Task" |

CSVs can then be pasted into a spreadsheet for benchmarking purposes.

### II. Usage

```
logtime [-s] -l <logfile_path_and_name> [-t <timingfile_path_and_name>] 
```

**Options:**

| option | Required? | Meaning |
| ------ | --------- | ------- |
| s | N | Silent mode (no screen echo) |
| l | Y | Path & name of logfile to be parsed |
| t | N | Path & name of output (timing) file |

**Notes:**

* If -l option not provided, will append "_time.txt" to end of base name of logfile and save to same directory.

**Example:**

```
logtime -l logfile_adb_private_1_load_data.txt -t /home/bien/benchmarking/bien_adb_pipeline_step_1_timing
```

### III. Known Issues

1. Will not parse correctly long lines containing multiple screen echoes appended using carriage returns and no line breaks (e.g., ` echo '\r -- Updating batch $batch_num of $tot_baches' ($elapsed sec)`. You will need to manually edit such lines in the logfile first. In general, the last value echoed will contain the total time for all intermediate steps echoed to the line.

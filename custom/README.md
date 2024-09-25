# Customs scripts for one-off operations using BIEN pipeline framework

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Overview  

File "custom_template.sh" is a template script for operations that can be executed using the pipeline framework. Executing an operation or series of operations with this framework enables options such as email notifications (operation start, completion, failure), writing to logfile (recording each step and echoing warnings and errors). This in turn allows long or complex operations to be automated and run remotely and unsupervised.

To create a new process, copy and rename the template script. Note that the name of the script will be used as the process name (for emails and logfile), unless you assign it a different process name ($pname; see local parameters file). As with other modules within the BIEN pipeline, the global parameters file (in the main application directory; "../params.sh") is loaded first, followed by the local parameters file (in this directory; "params.sh"). In the case of name collisions, local parameters over-ride global parameters. 

Do not alter the template script ("custom_template.sh"). Just copy it and modify the copy.

## Scripts

### match_threshold.sh
* DB version: 4.2
* Date: 9 April 2021

Remove TNRS name matching and resolution results from vfoi for names with match scores below the threshold value (currently 0.53). This is a one-time fix for BIEN 4.2. I have since added match threshold filtering to the TNRS. For the next BIEN DB version names will be filtered before import by the TNRS.

For names below threshold, note that parsing results are retained. Also, scrubbed_species_binomial_with_morphospecies is also kept because of its use as morphospecies names in plots. This leaves the decision to the user whether to use this field or the verbatim name.  

## Usage  

```
./custom_template.sh [-<option1> -<option2> ...]
```
* Check and adjust relevant parameters in global parameters file (../params.sh) and local parameters file (params.sh) as needed.

* All arguments are optional:

| Argument | Purpose |
| ------ | ------- |
| s      | Silent mode |
| m      | Send start/stop/error ermails |
| a      | Append to existing logfile [replaces file if omitted] |

# Create table data_dictionary_rbien and populates from manually-edited spreadsheet

Branch author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Requirements  
III. Usage  

### I. Overview

Create table data_dictionary_rbien and populates from manually-edited spreadsheet. Maintaining data within manually-edited Excel spreadsheets allows non-programmers to update data. Column headers, column order, etc. of spreadsheet should be locked using built-in Excel utilities so editors don't mess it up. Currently, contents of spreadsheet must be extracted to plain text CSV and placed in the data dictionary.

### II. Requirements

UTF-8 CSV dump of spreadsheet must be present in the data directory specified in the params file. 

### III. Usage

Can be sourced as part of main DB pipeline, or run standalone as follows:

```
$ .data_dictionary_rbien.sh

```

  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  


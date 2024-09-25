# Download and prepare GBIF Darwin Core Archive for import to BIEN database


## Download

### 1. Request manual download of dwca

1. Go to https://www.gbif.org/
2. Log in
3. Click "occurrences" tab above search window.
4. Click "Scientific Name" on left hand menu and select "Major Groups", then "Plantae".
5. Select "Download" option at the top of the data table.
6. Wait for GBIF to process your request and send you a download link.

### 2. Download the requested dwca file
1. Run the following command, using download link from GBIF notification email:

#### Syntax:

```
wget <gbif-download-link> -O gbif_raw_<yyyymmdd>.zip
```

#### Example:

```
wget  http://api.gbif.org/v1/occurrence/download/request/0003822-180508205500799.zip -O gbif_raw_dwca_20180518.zip
```

## Prepare

### 1. Extract the dwca zip file

```
unzip gbif_raw_dwca_20180518.zip
```

* Only need file occurrence.txt.

### 1. Double-up backslashes so Postgres takes them literally

```
sed 's/\\/\\\\/g' occurrence.txt > occurrence_cleaned.txt
```

### 2. Fix badly formed quotes
* Backup the file; quicker than downloading if screw up:

```
cp occurrence_cleaned.txt occurrences_cleaned.txt.bak
```

sed -i 's/,""/,"/g' occurrence_cleaned.txt
sed -i 's/"",/",/g' occurrence_cleaned.txt

##### Line-specific fixes
* sed command replaces entire line
* Obviously specific to a particular download
* Note sed line-number replacement syntax, where N=line number

```
sed -i 'Ns/.*/replacement-line/' file.txt
```

Example: line 16637332

```
sed -i '16637332s/.*/\"1413903801\",\"\"\"University of New Brunswick, Fredericton\"\"\",\"UNKNOWN\",\"CA\",\"Gigartinales\"/' occurrence_cleaned.txt
```

More examples
```
sed -i 's/,""University of New Brunswick, Fredericton"",/,"University of New Brunswick, Fredericton",/g' occurrence_cleaned.txt
```

```
sed -i 's/\"\"1413903801\"/\"1413903801\"/g' gbif_all_plants_20180426.csv
sed -i 's/\"CA\",\"Gigartinales\"\"/\"CA\",\"Gigartinales\"/g' occurrence_cleaned.txt
```

### 3. Optional fixes (may not be needed)

#### Check file type
* May say US_ASCII when it's actually ISO-8859-1

```
file -bi occurrence.txt
```

#### Convert to utf-8

```
iconv -f ISO-8859-1 -t utf-8 -o occurrence_utf-8.txt occurrence.txt
```



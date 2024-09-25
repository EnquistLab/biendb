#  Misc updates to database

Not part of DB pipeline. Keeping custom files in this directory allows use of global functions and parameters, including email notification features for long-running operations. 

### match_threshold.sh

Remove TNRS name matching and resolution results from vfoi for names with match scores below the threshold value (currently 0.53). This is a one-time fix for BIEN 4.2. I have since added match threshold filtering to the TNRS. For the next BIEN DB version names will be filtered before import by the TNRS.

For names below threshold, note that parsing results are retained. Also, scrubbed_species_binomial_with_morphospecies is also kept because of its use as morphospecies names in plots. This leaves the decision to the user whether to use this field or the verbatim name. 
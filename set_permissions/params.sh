#!/bin/bash

##############################################################
# Typical parameters for private database (vegbien.analtical_db)
# Rename to params.inc to apply
##############################################################

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Database to which you will be granting access
db=$db_private

# Schema on which you will be granting permissions
sch="analytical_db"

# $users_select: postgres user names (roles) of users 
# to which you will be granting select-only permission.
# Enter one per line, set to empty string ("") if none
users_select="
bien_private
public_bien3
"

# postgres user names (roles) of users to which you will be granting
# all privileges
# Enter one per line
# Leave as empty string ("") if none
users_full="
bien
"

# postgres user names (roles) of users to which you will be revoking
# all privileges on schema
# Enter one per line
# Leave as empty string ("") if none
users_revoke="
boyle
boyleadmin
bien_read
public_bien
jmcgann
cmerow
casler
sckott
fengxiao
"

# postgres user names (roles) of users to which you will be revoking
# connect privileges on db
# Enter one per line
# Leave as empty string ("") if none
users_revoke_db="
boyle
boyleadmin
bien_read
public_bien
jserradi
flowerc
proehrdanz
stevenpbachman
nadiab2018
monro
moat
klitgaard
zmarzty
clegg
panter
bwalker
javierfajnolla
conditr
mcgill
casler
jmcgann
sckott
"

# Users to assign or revoke to roles
# Each line is a user, role, and action (revoke/assign)
# Enter one triplet per line, comma separate, no closing comma
# Leave as empty string ("") if none
user_roles="
biendata_admin,bien_private,assign,
biendata_private,bien_private,assign,
jserradi,bien_private,assign
cmerow,bien_private,assign
fengxiao,bien_private,assign
flowerc,bien_private,assign
proehrdanz,bien_private,assign
naiamh,bien_private,assign
stevenpbachman,bien_private,assign
nadiab2018,bien_private,assign
monro,bien_private,assign
moat,bien_private,assign
klitgaard,bien_private,assign
zmarzty,bien_private,assign
clegg,bien_private,assign
panter,bien_private,assign
bwalker,bien_private,assign
javierfajnolla,bien_private,assign
conditr,bien_private,assign
mcgill,bien_private,assign
"

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "set_permissions" ]; then
	pname_local="Set permissions"
elif [ "$local_basename" == "assign_roles" ]; then
	pname_local="Assign/revoke roles"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
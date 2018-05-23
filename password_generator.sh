#!/bin/bash

# auth realm for digest auth
AUTH_REALM=webdav

# file locations

# a file containing a list of user names,
# one name per line, e.g.,
# $ cat users.txt
# joe
# curly
# larry
USER_FILE=users.txt

# htdigest file, needs to exist
HTDIGEST_FILE=passwd.htdigest

# insecure password file
PASSWD_FILE=passwd.txt

# read the names from the user file
while read username
  do
  # generate a pseudo-random password
  rand_pw=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`

  # hash the username, realm, and password
  htdigest_hash=`printf $username:$AUTH_REALM:$rand_pw | md5sum -`

  # build an htdigest appropriate line, and tack it onto the file
  echo "$username:$AUTH_REALM:${htdigest_hash:0:32}" >> $HTDIGEST_FILE

  # put the username and password in plain text
  # clearly, this is terribly insecure, but good for
  # testing and importing
  echo "$username:$rand_pw" >> $PASSWD_FILE
done < $USER_FILE

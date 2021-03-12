#!/usr/bin/env bash
# Backup your local Sendy database to a compressed file.

set -e
set -o pipefail

#db_config="./config.properties"
#sample content of config.properties
## dbUser = 'user'
## dbPass = 'password'
## dbName = 'databasename'
##
#db_user="$(grep -o "dbUser = '[^']*[^']'" "${db_config}" | cut -d "=" -f 2 | sed "s/'//g;s/ //g")"
#db_password="$(grep -o "dbPass = '[^']*[^']'" "${db_config}" | cut -d "=" -f 2 | sed "s/'//g;s/ //g")"
#db_name="$(grep -o "dbName = '[^']*[^']'" "${db_config}" | cut -d "=" -f 2 | sed "s/'//g;s/ //g")"

# MySQL / MariaDB.
/usr/bin/mysqldump -u "${db_user}" \
    -p"${db_password}" \
    "${db_name}" \
    | gzip > "/var/lib/mysqldb-backup/$(date +%F)_mysqldb.sql.gz"

# PostgreSQL (not using any values since it's just an example).
#
# Option 1: Use the .pgpass file
#   - sudo touch /root/.pgpass && sudo chmod 600 /root/.pgpass
#   - Add your DB connection info on line 1 of that file like this:
#       localhost:5432:mydatabase:foouser:mysecurepassword
#   - Use cut to parse out your user / host / db to avoid duplication when calling pg_dump
#   - When you connect with pg_dump below it will find a matching connection and use that pw
#
# Option 2: Use the PGPASSWORD env variable in this script
#   - Add this line right before calling pg_dump below:
#       export PGPASSWORD=mysecurepassword
#   - Feel free to parse your password out from a different file to avoid hard coding it
#
# Option 2 is a bit less secure but in a controlled environment it's not unreasonable.
 /usr/bin/pg_dump -Fc -U "${db_user}" -h localhost -d pgdatabase > pgdatabase.sql.dump

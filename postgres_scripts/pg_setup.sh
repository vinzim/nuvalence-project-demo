#!/bin/bash

set -e
set -u

if [ $# != 2 ]; then
    echo "please enter a db host and a table suffix"
    exit 1
fi

export DBHOST=$1

psql \
    -X \
    -U user \
    -P
    -h $DBHOST \
    -f ./postgres.sql \
    employee

psql_exit_status = $?

if [ $psql_exit_status != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "sql script successful"
exit 0
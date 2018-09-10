#!/bin/bash

set -e
set -u
set -o pipefail

export PGHOST=${PGHOST-10.238.4.109}
export PGPORT=${PGPORT-5432}
export PGDATABASE=${PGDATABASE-cl-us-gzh}
export PGUSER=${PGUSER-cl-us-gzh}
export PGPASSWORD=${PGPASSWORD-cl-us-gzh}

psql \
    -X \
    -f sql/transform.sql \
    --echo-all \
    --log-file=transform.log \
    --output=transform.sql.out \
    --set ON_ERROR_STOP=on

psql_exit_status=$?

if [ $psql_exit_status != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "sql script successful"
exit 0

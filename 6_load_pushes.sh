#!/bin/bash
echo "Converting pushes.csv to pushes_UTF8.csv"
iconv -f ISO-8859-1 -t UTF-8 pushes.csv > pushes_UTF8.csv
echo "Importing pushes_UTF8.csv"
pgfutter --dbname cl-us-gzh --host 10.238.4.109 --user cl-us-gzh --pass cl-us-gzh --schema import --table pushes_raw csv -d ';' pushes_UTF8.csv

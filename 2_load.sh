#!/bin/bash
echo "Converting events.csv to events_UTF8.csv"
iconv -f ISO-8859-1 -t UTF-8 events.csv > events_UTF8.csv
echo "Importing events_UTF8.csv"
pgfutter --dbname cl-us-gzh --host 10.238.4.109 --user cl-us-gzh --pass cl-us-gzh --table events_raw csv -d ';' events_UTF8.csv

echo "Converting classifications.csv to classifications_UTF8.csv"
iconv -f ISO-8859-1 -t UTF-8 classifications.csv > classifications_UTF8.csv
echo "Importing classifications_UTF8.csv"
pgfutter --dbname cl-us-gzh --host 10.238.4.109 --user cl-us-gzh --pass cl-us-gzh --table classifications_raw csv -d ';' classifications_UTF8.csv

echo "Converting newsletter_optins.csv to newsletter_optins_UTF8.csv"
iconv -f ISO-8859-1 -t UTF-8 newsletter_optins.csv > newsletter_optins_UTF8.csv
echo "Importing newsletter_optins_UTF8.csv"
pgfutter --dbname cl-us-gzh --host 10.238.4.109 --user cl-us-gzh --pass cl-us-gzh --table newsletter_optins_raw csv -d ';' newsletter_optins_UTF8.csv

echo "Converting articles.json to articles_UTF8.json"
iconv -f us-ascii -t UTF-8 articles.json > articles_UTF8.json
echo "Importing articles_UTF8.json"
pgfutter --dbname cl-us-gzh --host 10.238.4.109 --user cl-us-gzh --pass cl-us-gzh --table articles_raw json articles_UTF8.json

-- Database: cl-us-gzh

-- DROP DATABASE "cl-us-gzh";

CREATE DATABASE "cl-us-gzh"
    WITH 
    OWNER = "cl-us-gzh"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

GRANT TEMPORARY, CONNECT ON DATABASE "cl-us-gzh" TO PUBLIC;

GRANT ALL ON DATABASE "cl-us-gzh" TO "cl-us-gzh";
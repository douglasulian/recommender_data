-- Table: import.articles_raw

-- DROP TABLE import.articles_raw;

CREATE TABLE import.articles_raw
(
    data json
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE import.articles_raw
    OWNER to "cl-us-gzh";
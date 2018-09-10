-- Table: import.classifications_raw

-- DROP TABLE import.classifications_raw;

CREATE TABLE import.classifications_raw
(
    id text COLLATE pg_catalog."default",
    path text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE import.classifications_raw
    OWNER to "cl-us-gzh";

-- Index: classifications_raw_id_idx

-- DROP INDEX import.classifications_raw_id_idx;

CREATE INDEX classifications_raw_id_idx
    ON import.classifications_raw USING btree
    (id COLLATE pg_catalog."default")
    TABLESPACE pg_default;
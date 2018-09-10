-- Table: public.classification_path_levels

DROP TABLE public.classification_path_levels;

CREATE TABLE public.classification_path_levels
(
    name text COLLATE pg_catalog."default" NOT NULL,
    level numeric NOT NULL,
    classification_id text COLLATE pg_catalog."default" NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.classification_path_levels
    OWNER to "cl-us-gzh";

-- Index: classification_path_levels_classification_id_idx

-- DROP INDEX public.classification_path_levels_classification_id_idx;

CREATE INDEX classification_path_levels_classification_id_idx
    ON public.classification_path_levels USING btree
    (classification_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;
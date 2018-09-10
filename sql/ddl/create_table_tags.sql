-- Table: public.tags

-- DROP TABLE public.tags;

CREATE TABLE public.tags
(
    id numeric,
    name text COLLATE pg_catalog."default" NOT NULL,
    no_plural text COLLATE pg_catalog."default",
    CONSTRAINT tags_pkey PRIMARY KEY (name)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.tags
    OWNER to "cl-us-gzh";

-- Index: tags_id_idx

-- DROP INDEX public.tags_id_idx;

CREATE INDEX tags_id_idx
    ON public.tags USING btree
    (id)
    TABLESPACE pg_default;
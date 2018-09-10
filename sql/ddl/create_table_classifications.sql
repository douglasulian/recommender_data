-- Table: public.classifications

DROP TABLE public.classifications;

CREATE TABLE public.classifications
(
    id text COLLATE pg_catalog."default" NOT NULL,
    path text COLLATE pg_catalog."default",
    CONSTRAINT classifications_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.classifications
    OWNER to "cl-us-gzh";

-- Index: classifications_id_idx

-- DROP INDEX public.classifications_id_idx;

CREATE INDEX classifications_id_idx
    ON public.classifications USING btree
    (id COLLATE pg_catalog."default")
    TABLESPACE pg_default;
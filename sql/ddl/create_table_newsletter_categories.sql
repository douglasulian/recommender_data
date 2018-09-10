-- Table: public.newsletter_categories

DROP TABLE public.newsletter_categories;

CREATE TABLE public.newsletter_categories
(
    id text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT newsletter_categories_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.newsletter_categories
    OWNER to "cl-us-gzh";

-- Index: newsletter_categories_id_idx

-- DROP INDEX public.newsletter_categories_id_idx;

CREATE INDEX newsletter_categories_id_idx
    ON public.newsletter_categories USING btree
    (id COLLATE pg_catalog."default")
    TABLESPACE pg_default;
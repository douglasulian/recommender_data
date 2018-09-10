CREATE TABLE public.articles (
	id text NOT NULL,
	body text NULL,
	published_first date NULL,
	exposed_id text NULL,
	created_date date NULL,
	external_id text NULL,
	popularity numeric NULL,
	push_time timestamp NULL,
	CONSTRAINT articles_pkey PRIMARY KEY (id)
)
WITH (
	OIDS=FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.articles
    OWNER to "cl-us-gzh";

-- Index: articles_exposed_id_idx

-- DROP INDEX public.articles_exposed_id_idx;

CREATE INDEX articles_exposed_id_idx
    ON public.articles USING btree
    (exposed_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: articles_external_id_idx

-- DROP INDEX public.articles_external_id_idx;

CREATE INDEX articles_external_id_idx
    ON public.articles USING btree
    (external_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: articles_id_idx

-- DROP INDEX public.articles_id_idx;

CREATE INDEX articles_id_idx
    ON public.articles USING btree
    (id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

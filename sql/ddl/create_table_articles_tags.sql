-- Table: public.articles_tags

DROP TABLE public.articles_tags;

CREATE TABLE public.articles_tags
(
    article_id text COLLATE pg_catalog."default" NOT NULL,
    tag_id numeric NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.articles_tags
    OWNER to "cl-us-gzh";

-- Index: articles_tags_article_id_tag_id_idx

-- DROP INDEX public.articles_tags_article_id_tag_id_idx;

CREATE INDEX articles_tags_article_id_tag_id_idx
    ON public.articles_tags USING btree
    (article_id COLLATE pg_catalog."default", tag_id)
    TABLESPACE pg_default;
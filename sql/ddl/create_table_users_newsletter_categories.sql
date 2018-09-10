-- Table: public.users_newsletter_categories

DROP TABLE public.users_newsletter_categories;

CREATE TABLE public.users_newsletter_categories
(
    user_id text COLLATE pg_catalog."default" NOT NULL,
    newsletter_category_id text COLLATE pg_catalog."default" NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users_newsletter_categories
    OWNER to "cl-us-gzh";

-- Index: users_newsletter_categories_user_id_newsletter_category_id_idx

-- DROP INDEX public.users_newsletter_categories_user_id_newsletter_category_id_idx;

CREATE INDEX users_newsletter_categories_user_id_newsletter_category_id_idx
    ON public.users_newsletter_categories USING btree
    (user_id COLLATE pg_catalog."default", newsletter_category_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;
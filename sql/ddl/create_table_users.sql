-- Table: public.users

DROP TABLE public.users;

CREATE TABLE public.users
(
    email text COLLATE pg_catalog."default" NOT NULL,
    newsletter_optin_date date,
    newsletter_last_update date,
    newsletter_optin numeric(1,0),
    newsletter_optout numeric(1,0),
    CONSTRAINT user_pkey PRIMARY KEY (email)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to "cl-us-gzh";

-- Index: users_email_idx

-- DROP INDEX public.users_email_idx;

CREATE INDEX users_email_idx
    ON public.users USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;
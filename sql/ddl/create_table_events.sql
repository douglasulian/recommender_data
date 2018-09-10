-- Table: public.events

DROP TABLE public.events;

CREATE TABLE public.events
(
    eventosid numeric NOT NULL,
    data_evento timestamp NOT NULL,
    conteudo_topico text COLLATE pg_catalog."default",
    tag_evento text COLLATE pg_catalog."default",
    tipo_conteudo text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default" NOT NULL,
    categoria_conteudo text COLLATE pg_catalog."default",
    url_acessado text COLLATE pg_catalog."default",
    tipo_usuario text COLLATE pg_catalog."default",
    veiculo text COLLATE pg_catalog."default",
    dispositivo text COLLATE pg_catalog."default",
    id_materia text COLLATE pg_catalog."default",
    nome_edicao text COLLATE pg_catalog."default",
    data_edicao date,
    numero_edicao numeric,
    tipo_edicao text COLLATE pg_catalog."default",
    id_materia_extraido text COLLATE pg_catalog."default",
    article_id text COLLATE pg_catalog."default",
    CONSTRAINT events_pkey PRIMARY KEY (eventosid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.events
    OWNER to "cl-us-gzh";

-- Index: events_email_idx

-- DROP INDEX public.events_email_idx;

CREATE INDEX events_email_idx
    ON public.events USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: events_eventosid_idx

-- DROP INDEX public.events_eventosid_idx;

CREATE INDEX events_eventosid_idx
    ON public.events USING btree
    (eventosid)
    TABLESPACE pg_default;

-- Index: events_id_materia_extraido_idx

-- DROP INDEX public.events_id_materia_extraido_idx;

CREATE INDEX events_id_materia_extraido_idx
    ON public.events USING btree
    (id_materia_extraido COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: events_id_materia_idx

-- DROP INDEX public.events_id_materia_idx;

CREATE INDEX events_id_materia_idx
    ON public.events USING btree
    (id_materia COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: events_url_acessado_idx

-- DROP INDEX public.events_url_acessado_idx;

CREATE INDEX events_url_acessado_idx
    ON public.events USING btree
    (url_acessado COLLATE pg_catalog."default")
    TABLESPACE pg_default;
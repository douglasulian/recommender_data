-- Table: import.events_raw

-- DROP TABLE import.events_raw;

CREATE TABLE import.events_raw
(
    eventosid text COLLATE pg_catalog."default",
    data_evento text COLLATE pg_catalog."default",
    conteudo_topico text COLLATE pg_catalog."default",
    tag_evento text COLLATE pg_catalog."default",
    tipo_conteudo text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    categoria_conteudo text COLLATE pg_catalog."default",
    url_acessado text COLLATE pg_catalog."default",
    tipo_usuario text COLLATE pg_catalog."default",
    veiculo text COLLATE pg_catalog."default",
    dispositivo text COLLATE pg_catalog."default",
    id_materia text COLLATE pg_catalog."default",
    nome_edicao text COLLATE pg_catalog."default",
    data_edicao text COLLATE pg_catalog."default",
    numero_edicao text COLLATE pg_catalog."default",
    tipo_edicao text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE import.events_raw
    OWNER to "cl-us-gzh";
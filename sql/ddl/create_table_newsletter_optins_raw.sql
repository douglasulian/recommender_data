-- Table: import.newsletter_optins_raw

-- DROP TABLE import.newsletter_optins_raw;

CREATE TABLE import.newsletter_optins_raw
(
    email text COLLATE pg_catalog."default",
    ret_email text COLLATE pg_catalog."default",
    data_optin text COLLATE pg_catalog."default",
    ultima_alteracao text COLLATE pg_catalog."default",
    fg_hardbounce text COLLATE pg_catalog."default",
    fg_optout text COLLATE pg_catalog."default",
    motivo_optout text COLLATE pg_catalog."default",
    outrosmotivos text COLLATE pg_catalog."default",
    primeironome text COLLATE pg_catalog."default",
    ultimonome text COLLATE pg_catalog."default",
    confirmado text COLLATE pg_catalog."default",
    formatopreferido text COLLATE pg_catalog."default",
    clube_do_assinante text COLLATE pg_catalog."default",
    colorado_zh text COLLATE pg_catalog."default",
    colunistas_zh text COLLATE pg_catalog."default",
    destaques_da_manha text COLLATE pg_catalog."default",
    destaques_do_editor text COLLATE pg_catalog."default",
    destemperados text COLLATE pg_catalog."default",
    donna text COLLATE pg_catalog."default",
    encare_a_crise text COLLATE pg_catalog."default",
    especiais_zh text COLLATE pg_catalog."default",
    gremista_zh text COLLATE pg_catalog."default",
    zh_doc text COLLATE pg_catalog."default",
    zh_findi text COLLATE pg_catalog."default",
    zh_viagem text COLLATE pg_catalog."default",
    zh_vida text COLLATE pg_catalog."default",
    fg_lead text COLLATE pg_catalog."default",
    nome_lead text COLLATE pg_catalog."default",
    cpf_lead text COLLATE pg_catalog."default",
    dt_nasc_lead text COLLATE pg_catalog."default",
    telefone_lead text COLLATE pg_catalog."default",
    cidade_lead text COLLATE pg_catalog."default",
    origem_lead text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE import.newsletter_optins_raw
    OWNER to "cl-us-gzh";

-- Index: newsletter_optins_raw_email_idx

-- DROP INDEX import.newsletter_optins_raw_email_idx;

CREATE INDEX newsletter_optins_raw_email_idx
    ON import.newsletter_optins_raw USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;
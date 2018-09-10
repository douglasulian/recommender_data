DROP SEQUENCE public.sq_tag_id;
CREATE SEQUENCE public.sq_tag_id
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.sq_tag_id
    OWNER TO "cl-us-gzh";
truncate table public.users;
DROP INDEX public.users_email_idx;
    
begin;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    do $$
    begin
        perform import_users();
    end $$;
commit;

CREATE INDEX users_email_idx ON public.users USING btree (email COLLATE pg_catalog."default") TABLESPACE pg_default;

vacuum public.users;
analyze public.users;

truncate table public.newsletter_categories;
DROP INDEX IF EXISTS public.newsletter_categories_id_idx;
	
truncate table public.users_newsletter_categories;
DROP INDEX IF EXISTS public.users_newsletter_categories_user_id_newsletter_category_id_idx;

CREATE INDEX newsletter_categories_id_idx ON public.newsletter_categories USING btree (id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX users_newsletter_categories_user_id_newsletter_category_id_idx ON public.users_newsletter_categories USING btree (user_id COLLATE pg_catalog."default", newsletter_category_id COLLATE pg_catalog."default") TABLESPACE pg_default;

vacuum public.newsletter_categories;
analyze public.newsletter_categories;

vacuum public.users_newsletter_categories;
analyze public.users_newsletter_categories;

truncate table public.newsletter_categories;
DROP INDEX IF EXISTS public.newsletter_categories_id_idx;
    
truncate table public.users_newsletter_categories;
DROP INDEX IF EXISTS public.users_newsletter_categories_user_id_newsletter_category_id_idx;

begin;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    do $$
    begin
        perform import_newsletter_categories();
	
        perform import_newsletter_optins();
	end $$;    
commit;

CREATE INDEX users_newsletter_categories_user_id_newsletter_category_id_idx ON public.users_newsletter_categories USING btree (user_id COLLATE pg_catalog."default", newsletter_category_id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX newsletter_categories_id_idx ON public.newsletter_categories USING btree (id COLLATE pg_catalog."default") TABLESPACE pg_default;

vacuum public.newsletter_categories;
analyze public.newsletter_categories;
vacuum public.users_newsletter_categories;
analyze public.users_newsletter_categories;

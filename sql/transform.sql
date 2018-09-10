truncate table public.classifications;
DROP INDEX IF EXISTS public.classifications_id_idx;
  
truncate table public.classification_path_levels;
DROP INDEX IF EXISTS public.classification_path_levels_classification_id_idx;
    
begin;

    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    do $$
    begin
        perform setval('public.sq_tag_id', 0);
        perform import_classifications();
    end $$;
    
		
commit;

CREATE INDEX classifications_id_idx ON public.classifications USING btree (id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX classification_path_levels_classification_id_idx ON public.classification_path_levels USING btree (classification_id COLLATE pg_catalog."default") TABLESPACE pg_default;

vacuum public.classifications;
analyze public.classifications;

vacuum public.classification_path_levels;
analyze public.classification_path_levels;

truncate table public.articles;	
DROP INDEX IF EXISTS public.articles_exposed_id_idx;
DROP INDEX IF EXISTS public.articles_external_id_idx;
DROP INDEX IF EXISTS public.articles_id_idx;
    
truncate table public.tags;
DROP INDEX IF EXISTS public.tags_id_idx;
  
truncate table public.articles_tags;
DROP INDEX IF EXISTS public.articles_tags_article_id_tag_id_idx;

begin;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    truncate table articles;
    truncate table articles_tags;
    truncate table tags;
    do $$
    begin
        perform import_articles();
    end $$;
commit;

CREATE INDEX articles_exposed_id_idx ON public.articles USING btree (exposed_id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX articles_external_id_idx ON public.articles USING btree (external_id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX articles_id_idx ON public.articles USING btree (id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX tags_id_idx ON public.tags USING btree (id) TABLESPACE pg_default;
CREATE INDEX articles_tags_article_id_tag_id_idx ON public.articles_tags USING btree (article_id COLLATE pg_catalog."default", tag_id) TABLESPACE pg_default;

vacuum public.articles;
analyze public.articles;

vacuum public.tags;
analyze public.tags;

vacuum public.articles_tags;
analyze public.articles_tags;

truncate table public.events;
   
DROP INDEX IF EXISTS public.events_email_idx;
DROP INDEX IF EXISTS public.events_eventosid_idx;
DROP INDEX IF EXISTS public.events_article_id_idx;
DROP INDEX IF EXISTS public.events_id_materia_idx;
DROP INDEX IF EXISTS public.events_url_acessado_idx;

begin;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    
    do $$
    begin
        perform import_events();
    end $$;

commit;

CREATE INDEX events_email_idx ON public.events USING btree (email COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX events_eventosid_idx ON public.events USING btree (eventosid) TABLESPACE pg_default;
CREATE INDEX events_article_id_idx ON public.events USING btree (article_id COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX events_id_materia_idx ON public.events USING btree (id_materia COLLATE pg_catalog."default") TABLESPACE pg_default;
CREATE INDEX events_url_acessado_idx ON public.events USING btree (url_acessado COLLATE pg_catalog."default") TABLESPACE pg_default;

vacuum public.events;
analyze public.events;

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

begin;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    do $$
    begin
        with popularity as (
            select e.article_id,count(distinct e.email) qtt from events e group by e.article_id
        )
        update articles
           set popularity = pop.qtt
          from popularity pop
         where articles.id = pop.article_id; 
    end $$;
commit;

vacuum public.articles;
analyze public.articles;


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

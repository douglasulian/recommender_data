CREATE OR REPLACE FUNCTION public.import() RETURNS numeric AS $$
DECLARE
	result_classifications numeric default 0;    
	result_articles numeric default 0;
	result_events numeric default 0;
    result_users numeric default 0;
    result_newsletter_categories numeric default 0;
    result_newsletter_optin numeric default 0;
    
    results record;
    
BEGIN
    delete from classifications;
    delete from classification_path_levels;
    delete from articles;
    delete from articles_tags;
    delete from tags;
    delete from events;
    delete from users;
    delete from newsletter_categories;
    delete from users_newsletter_categories;

    select setval('public.sq_tag_id', 0);
    
    select import_classifications() into result_classifications;
    select import_articles() into result_articles;
    select import_events() into result_events;
    select import_users() into result_users;
    select import_newsletter_categories() into result_newsletter_categories;
    select import_newsletter_optin() into result_newsletter_optin;
    
    raise info 'Results:';
    for results in     
    	select '  classifications'             as type, count(1) as qtt from classifications union
		select '  classification_path_levels'  as type, count(1) as qtt from classification_path_levels union 
		select '  articles'                    as type, count(1) as qtt from articles union 
		select '  articles_tags'               as type, count(1) as qtt from articles_tags union 
		select '  tags'                        as type, count(1) as qtt from tags union 
		select '  events'                      as type, count(1) as qtt from events union 
		select '  users'                       as type, count(1) as qtt from users union 
		select '  newsletter_categories'       as type, count(1) as qtt from newsletter_categories union
    	select '  users_newsletter_categories' as type, count(1) as qtt from users_newsletter_categories loop
		
        RAISE log '%: %', results.type,results.qtt;
        
    end loop;
    
    return 0;
END;
$$ LANGUAGE plpgsql;
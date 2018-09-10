CREATE OR REPLACE FUNCTION public.import_articles() RETURNS numeric AS $$
DECLARE
    --subtotal ALIAS FOR $1;
    article record;
    tag record;
    tag_id numeric;
    total NUMERIC DEFAULT 0;
    parcial NUMERIC DEFAULT 0;
BEGIN
	SELECT count(1) INTO strict total FROM import.articles_raw;	

    for article in select 
        			data->>'body' as body,
        			data->>'tags-slugs' as tags_slugs,
        			data->>'published_first' as published_first,
        			data->>'exposed_id' as exposed_id,
        			data->>'all_classifications' as all_classifications,
        			data->>'created_date' as created_date,
        			data->>'external_id' as external_id,
        			data->>'id' as id
        			from import.articles_raw LOOP
        
        INSERT INTO public.articles(id, 
                                    body, 
                                    published_first, 
                                    exposed_id, 
                                    created_date, 
                                    external_id)
                            VALUES (nullif(trim(article.id),''),
                                    nullif(trim(article.body),''),
                                    to_date(article.published_first,'YYYY-MM-DD HH24:MI:SS'), --2017-05-09 08:02:06
                                    nullif(nullif(trim(article.exposed_id),''),'0'),
                                    to_date(article.created_date,'YYYY-MM-DD HH24:MI:SS'),
                                    nullif(nullif(trim(article.external_id),''),'0'));
                                    
        for tag in select value as name from json_array_elements_text(cast(article.tags_slugs AS json)) loop

            begin
                select id into strict tag_id from tags where name = tag.name;
            exception
                when NO_DATA_FOUND then
                    insert into tags (id,name) values (nextval('sq_tag_id'),tag.name);
                    tag_id := currval('sq_tag_id');
                --when TOO_MANY_ROWS then 
                --    raise exception 'tag % not unique', tag.name;
            end; 
            insert into articles_tags (article_id,tag_id) values (article.id,tag_id);
        end loop;
        --commit;
        parcial := parcial + 1;
        if (mod(parcial,round(total/100,0)) = 0 or parcial = total) then
        	raise log 'Articles: % percent imported',round(parcial/total*100,0);
        end if;
    end loop;
    
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
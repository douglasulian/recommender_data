CREATE OR REPLACE FUNCTION public.import_newsletter_optins() RETURNS numeric AS $$
DECLARE
    optin record;
    user_exists numeric default 0;
    parcial numeric default 0;
    total numeric default 0;
begin
	select count(1) into strict total from import.newsletter_optins_raw;
	
    for optin in SELECT email, 
                        data_optin, 
                        ultima_alteracao,
                        fg_optout,
                        colorado_zh,
                        colunistas_zh,
                        destaques_da_manha,
                        destaques_do_editor,
                        destemperados,
                        donna,
                        encare_a_crise,
                        especiais_zh,
                        gremista_zh,
                        zh_doc,
                        zh_findi,
                        zh_viagem,
                        zh_vida
	FROM import.newsletter_optins_raw LOOP
        --update user details
        begin
        	--select 1 into strict user_exists from public.users us where us.email = trim(optin.email);
            update public.users set newsletter_optin = 1,
                        newsletter_optin_date  = to_date(              optin.data_optin,'DD.MM.YYYY HH24:MI:SS'),
                        newsletter_optout      = to_number(nullif(trim(optin.fg_optout),''),'9'),
                        newsletter_last_update = to_date(              optin.ultima_alteracao,'DD.MM.YYYY HH24:MI:SS')
             where email = trim(optin.email);
            if trim(optin.gremista_zh        ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'1' ); end if;
            if trim(optin.colorado_zh        ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'2' ); end if;
            if trim(optin.colunistas_zh      ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'3' ); end if;
            if trim(optin.destaques_da_manha ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'4' ); end if;
            if trim(optin.destaques_do_editor) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'5' ); end if;
            if trim(optin.destemperados      ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'6' ); end if;
            if trim(optin.donna              ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'7' ); end if;
            if trim(optin.encare_a_crise     ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'8' ); end if;
            if trim(optin.especiais_zh       ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'9' ); end if;
            if trim(optin.zh_doc             ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'10'); end if;
            if trim(optin.zh_findi           ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'11'); end if;
            if trim(optin.zh_viagem          ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'12'); end if;
            if trim(optin.zh_vida            ) = '1' then insert into users_newsletter_categories (user_id, newsletter_category_id) values (trim(optin.email),'13'); end if;
        exception when NO_DATA_FOUND then
            raise log 'User not found: %', trim(optin.email);
        end;
        
        parcial := parcial + 1;
        if (mod(parcial,round(total/100,0)) = 0 or parcial = total) then
        	raise log 'Newsletter Optins: % percent imported',round(parcial/total*100,0);
        end if;
    end loop;
    
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
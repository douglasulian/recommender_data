CREATE OR REPLACE FUNCTION public.split_sample(samplesize numeric default 0, testing_schema character default 'testing', schemaA character default 'testingA', schemaB character default 'testingB') RETURNS numeric AS $$
DECLARE
begin
	
    perform set_config('search_path', schemaA, false);
    
    delete from users;
    
    execute (format('
    insert into users (   email,    newsletter_optin_date,    newsletter_last_update,    newsletter_optin,    newsletter_optout)
     select            pu.email, pu.newsletter_optin_date, pu.newsletter_last_update, pu.newsletter_optin, pu.newsletter_optout
       from %I.users pu
      order by random() 
          limit round(%s/2)',testing_schema,samplesize));
    
    delete from events;
    execute (format('
    insert into events (   eventosid,    data_evento,    conteudo_topico,    tag_evento,    tipo_conteudo,    email,    categoria_conteudo,    url_acessado,    tipo_usuario,    veiculo,    dispositivo,    id_materia,    nome_edicao,    data_edicao,    numero_edicao,    tipo_edicao,    id_materia_extraido,    article_id)
         select          pe.eventosid, pe.data_evento, pe.conteudo_topico, pe.tag_evento, pe.tipo_conteudo, pe.email, pe.categoria_conteudo, pe.url_acessado, pe.tipo_usuario, pe.veiculo, pe.dispositivo, pe.id_materia, pe.nome_edicao, pe.data_edicao, pe.numero_edicao, pe.tipo_edicao, pe.id_materia_extraido, pe.article_id
           from %I.events pe
     inner join users su on pe.email = su.email',testing_schema));

    delete from articles;
    execute (format('
    insert into articles (   id,    body,    published_first,    exposed_id,    created_date,    external_id, popularity)
         select         distinct pa.id, pa.body, pa.published_first, pa.exposed_id, pa.created_date, pa.external_id, pa.popularity
           from %I.articles pa 
     inner join events se on pa.id = se.article_id',testing_schema));
    
    delete from articles_tags;
	execute (format('
    insert into articles_tags (    article_id,     tag_id)
         select                       pat.article_id, pat.tag_id
           from %I.articles_tags pat
     inner join articles sa on pat.article_id = sa.id',testing_schema));

    delete from tags;
    execute (format('
    insert into tags (   id,    name)
         select     distinct pt.id, pt.name
           from %I.tags pt
     inner join articles_tags sat on pt.id = sat.tag_id',testing_schema));
    
    delete from classifications;
	execute (format('
    insert into classifications (   id,    path)
         select                         pc.id, pc.path
           from %I.classifications pc
          inner join articles sa on sa.id = pc.id',testing_schema));
    
    delete from classification_path_levels;
    execute (format('
    insert into classification_path_levels (     name,      level,      classification_id)
         select                                    pcpl.name, pcpl.level, pcpl.classification_id
           from %I.classification_path_levels pcpl
          inner join classifications sc on pcpl.classification_id = sc.id',testing_schema));
    
    delete from newsletter_categories;
	execute (format('
    insert into newsletter_categories (    id,     name)
         select                      distinct pnc.id, pnc.name
           from %I.newsletter_categories pnc',testing_schema));
           
    delete from users_newsletter_categories;
    execute (format('
    insert into users_newsletter_categories (     user_id,      newsletter_category_id)
         select                                     punc.user_id, punc.newsletter_category_id
           from %I.users_newsletter_categories punc
     inner join users su on punc.user_id = su.email',testing_schema));
    
    perform set_config('search_path', schemaB, false); 
    
    delete from users;
    execute (format('
    insert into users (   email,    newsletter_optin_date,    newsletter_last_update,    newsletter_optin,    newsletter_optout)
     select            pu.email, pu.newsletter_optin_date, pu.newsletter_last_update, pu.newsletter_optin, pu.newsletter_optout
           from %I.users pu where pu.email not in (select au.email from %I.users au)',testing_schema,schemaA));
          
        delete from events;
    execute (format('
    insert into events (   eventosid,    data_evento,    conteudo_topico,    tag_evento,    tipo_conteudo,    email,    categoria_conteudo,    url_acessado,    tipo_usuario,    veiculo,    dispositivo,    id_materia,    nome_edicao,    data_edicao,    numero_edicao,    tipo_edicao,    id_materia_extraido,    article_id)
         select          pe.eventosid, pe.data_evento, pe.conteudo_topico, pe.tag_evento, pe.tipo_conteudo, pe.email, pe.categoria_conteudo, pe.url_acessado, pe.tipo_usuario, pe.veiculo, pe.dispositivo, pe.id_materia, pe.nome_edicao, pe.data_edicao, pe.numero_edicao, pe.tipo_edicao, pe.id_materia_extraido, pe.article_id
           from %I.events pe
     inner join users su on pe.email = su.email',testing_schema));

    delete from articles;
    execute (format('
    insert into articles (   id,    body,    published_first,    exposed_id,    created_date,    external_id, popularity)
         select         distinct pa.id, pa.body, pa.published_first, pa.exposed_id, pa.created_date, pa.external_id, pa.popularity
           from %I.articles pa 
     inner join events se on pa.id = se.article_id',testing_schema));
    
    delete from articles_tags;
	execute (format('
    insert into articles_tags (    article_id,     tag_id)
         select                       pat.article_id, pat.tag_id
           from %I.articles_tags pat
     inner join articles sa on pat.article_id = sa.id',testing_schema));

    delete from tags;
    execute (format('
    insert into tags (   id,    name)
         select     distinct pt.id, pt.name
           from %I.tags pt
     inner join articles_tags sat on pt.id = sat.tag_id',testing_schema));
    
    delete from classifications;
	execute (format('
    insert into classifications (   id,    path)
         select                         pc.id, pc.path
           from %I.classifications pc
          inner join articles sa on sa.id = pc.id',testing_schema));
    
    delete from classification_path_levels;
    execute (format('
    insert into classification_path_levels (     name,      level,      classification_id)
         select                                    pcpl.name, pcpl.level, pcpl.classification_id
           from %I.classification_path_levels pcpl
          inner join classifications sc on pcpl.classification_id = sc.id',testing_schema));
    
    delete from newsletter_categories;
	execute (format('
    insert into newsletter_categories (    id,     name)
         select                      distinct pnc.id, pnc.name
           from %I.newsletter_categories pnc',testing_schema));
           
    delete from users_newsletter_categories;
    execute (format('
    insert into users_newsletter_categories (     user_id,      newsletter_category_id)
         select                                     punc.user_id, punc.newsletter_category_id
           from %I.users_newsletter_categories punc
     inner join users su on punc.user_id = su.email',testing_schema));
         
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
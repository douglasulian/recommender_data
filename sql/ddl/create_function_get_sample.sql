CREATE OR REPLACE FUNCTION public.get_sample(samplesize numeric default 0,training_schema character default 'training', testing_schema character default 'testing', split_date date default now()) RETURNS numeric AS $$
DECLARE
begin
	
    perform set_config('search_path', training_schema, false);
    
    delete from users;
    insert into users (   email,    newsletter_optin_date,    newsletter_last_update,    newsletter_optin,    newsletter_optout)
     select                   pu.email, pu.newsletter_optin_date, pu.newsletter_last_update, pu.newsletter_optin, pu.newsletter_optout
           from public.users pu
       order by random() 
          limit samplesize;
          
    delete from events;
    insert into events (   eventosid,    data_evento,    conteudo_topico,    tag_evento,    tipo_conteudo,    email,    categoria_conteudo,    url_acessado,    tipo_usuario,    veiculo,    dispositivo,    id_materia,    nome_edicao,    data_edicao,    numero_edicao,    tipo_edicao,    id_materia_extraido,    article_id)
         select          pe.eventosid, pe.data_evento, pe.conteudo_topico, pe.tag_evento, pe.tipo_conteudo, pe.email, pe.categoria_conteudo, pe.url_acessado, pe.tipo_usuario, pe.veiculo, pe.dispositivo, pe.id_materia, pe.nome_edicao, pe.data_edicao, pe.numero_edicao, pe.tipo_edicao, pe.id_materia_extraido, pe.article_id
           from public.events pe
     inner join users su on pe.email = su.email
     where data_evento <= split_date;

    delete from articles;
    insert into articles (   id,    body,    published_first,    exposed_id,    created_date,    external_id, push_time)
         select         distinct pa.id, pa.body, pa.published_first, pa.exposed_id, pa.created_date, pa.external_id, pa.push_time
           from public.articles pa 
     inner join events se on pa.id = se.article_id;
    
    delete from articles_tags;
    insert into articles_tags (    article_id,     tag_id)
         select                       pat.article_id, pat.tag_id
           from public.articles_tags pat
     inner join articles sa on pat.article_id = sa.id;

    delete from tags;
    insert into tags (      id,    name,    no_plural)
         select distinct pt.id, pt.name, pt.no_plural
           from public.tags pt
     inner join articles_tags sat on pt.id = sat.tag_id;
    
    delete from classifications;
    insert into classifications (   id,    path)
         select                         pc.id, pc.path
           from public.classifications pc
          inner join articles sa on sa.id = pc.id;
    
    delete from classification_path_levels;
    insert into classification_path_levels (     name,      level,      classification_id)
         select                                    pcpl.name, pcpl.level, pcpl.classification_id
           from public.classification_path_levels pcpl
          inner join classifications sc on pcpl.classification_id = sc.id;
    
    delete from newsletter_categories;
    insert into newsletter_categories (    id,     name)
         select                      distinct pnc.id, pnc.name
           from public.newsletter_categories pnc;
           
    delete from users_newsletter_categories;
    insert into users_newsletter_categories (     user_id,      newsletter_category_id)
         select                                     punc.user_id, punc.newsletter_category_id
           from public.users_newsletter_categories punc
     inner join users su on punc.user_id = su.email;
    
    with popularity as (select e.article_id,count(distinct e.email) qtt from events e group by e.article_id)
    update articles
       set popularity = pop.qtt
      from popularity pop
     where articles.id = pop.article_id;
         
    perform set_config('search_path', testing_schema, false); 
    
    delete from users;
    execute (format('
    insert into users (   email,    newsletter_optin_date,    newsletter_last_update,    newsletter_optin,    newsletter_optout)
     select            pu.email, pu.newsletter_optin_date, pu.newsletter_last_update, pu.newsletter_optin, pu.newsletter_optout
           from %I.users pu',training_schema));
          
    delete from events;
    insert into events (   eventosid,    data_evento,    conteudo_topico,    tag_evento,    tipo_conteudo,    email,    categoria_conteudo,    url_acessado,    tipo_usuario,    veiculo,    dispositivo,    id_materia,    nome_edicao,    data_edicao,    numero_edicao,    tipo_edicao,    id_materia_extraido,    article_id)
         select          pe.eventosid, pe.data_evento, pe.conteudo_topico, pe.tag_evento, pe.tipo_conteudo, pe.email, pe.categoria_conteudo, pe.url_acessado, pe.tipo_usuario, pe.veiculo, pe.dispositivo, pe.id_materia, pe.nome_edicao, pe.data_edicao, pe.numero_edicao, pe.tipo_edicao, pe.id_materia_extraido, pe.article_id
           from public.events pe
     inner join users su on pe.email = su.email
     where data_evento > split_date;

    delete from articles;
    insert into articles (   id,    body,    published_first,    exposed_id,    created_date,    external_id,    push_time)
         select  distinct pa.id, pa.body, pa.published_first, pa.exposed_id, pa.created_date, pa.external_id, pa.push_time
           from public.articles pa 
     inner join events se on pa.id = se.article_id;
    
    delete from articles_tags;
    insert into articles_tags (    article_id,     tag_id)
         select                       pat.article_id, pat.tag_id
           from public.articles_tags pat
     inner join articles sa on pat.article_id = sa.id;

    delete from tags;
    insert into tags    (   id,    name,    no_plural)
         select distinct pt.id, pt.name, pt.no_plural
           from public.tags pt
     inner join articles_tags sat on pt.id = sat.tag_id;
    
    delete from classifications;
    insert into classifications (   id,    path)
         select                         pc.id, pc.path
           from public.classifications pc
          inner join articles sa on sa.id = pc.id;
    
    delete from classification_path_levels;
    insert into classification_path_levels (     name,      level,      classification_id)
         select                                    pcpl.name, pcpl.level, pcpl.classification_id
           from public.classification_path_levels pcpl
          inner join classifications sc on pcpl.classification_id = sc.id;
    
    delete from newsletter_categories;
    insert into newsletter_categories (    id,     name)
         select                      distinct pnc.id, pnc.name
           from public.newsletter_categories pnc;
           
    delete from users_newsletter_categories;
    insert into users_newsletter_categories (     user_id,      newsletter_category_id)
         select                                     punc.user_id, punc.newsletter_category_id
           from public.users_newsletter_categories punc
     inner join users su on punc.user_id = su.email;
    
    with popularity as (select e.article_id,count(distinct e.email) qtt from events e group by e.article_id)
    update articles
       set popularity = pop.qtt
      from popularity pop
     where articles.id = pop.article_id;
     
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
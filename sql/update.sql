begin;
    LOCK TABLE public.events IN SHARE MODE;
    SET LOCAL work_mem = '3072 MB';  -- just for this transaction
    
    CREATE TABLE public.events_2 AS 
    select ev2.eventosid         ,ev2.data_evento  ,ev2.conteudo_topico, 
           ev2.tag_evento        ,ev2.tipo_conteudo,ev2.email, 
           ev2.categoria_conteudo,ev2.url_acessado ,ev2.tipo_usuario, 
           ev2.veiculo           ,ev2.dispositivo  ,ev2.id_materia, 
           ev2.nome_edicao       ,ev2.data_edicao  ,ev2.numero_edicao,
           ev2.tipo_edicao       ,ev2.id_materia_extraido,
           coalesce(ar_external_id.id, ar_exposed_id.id,ar_id.id) as article_id
      from (SELECT ev.eventosid         ,ev.data_evento  ,ev.conteudo_topico, 
                   ev.tag_evento        ,ev.tipo_conteudo,ev.email, 
                   ev.categoria_conteudo,ev.url_acessado ,ev.tipo_usuario, 
                   ev.veiculo           ,ev.dispositivo  ,ev.id_materia, 
                   ev.nome_edicao       ,ev.data_edicao  ,ev.numero_edicao, 
                   ev.tipo_edicao, 
                   coalesce(substring(substring(ev.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                                               substring(ev.url_acessado from '[0-9]{6,7}'),
                                               nullif(nullif(trim(ev.id_materia),'0'),'')
                                               ) as id_materia_extraido 
              FROM public.events ev
             where coalesce(substring(substring(ev.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                            substring(ev.url_acessado from '[0-9]{6,7}'),
                            nullif(nullif(trim(ev.id_materia),'0'),'')
                            ) is not null
               and coalesce(substring(substring(ev.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                            substring(ev.url_acessado from '[0-9]{6,7}'),
                            nullif(nullif(trim(ev.id_materia),'0'),'')
                            ) != '-1'
               limit 100
             ) ev2
    left join public.articles ar_external_id on ev2.id_materia_extraido = ar_external_id.external_id
    left join public.articles ar_exposed_id on ev2.id_materia_extraido = ar_exposed_id.exposed_id
    left join public.articles ar_id on ev2.id_materia_extraido = ar_id.id;
    
commit;
CREATE OR REPLACE FUNCTION import_events() RETURNS numeric AS $$
DECLARE
    result_events numeric default 0;
    --event record;
    total numeric default 0;
    parcial numeric default 0;
begin

    SELECT count(1) INTO strict total 
      FROM import.events_raw event
     where coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                    substring(event.url_acessado from '[0-9]{6,7}'),
                    nullif(nullif(trim(event.id_materia),'0'),'')
                    ) is not null
       and coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                    substring(event.url_acessado from '[0-9]{6,7}'),
                    nullif(nullif(trim(event.id_materia),'0'),'')
                    ) != '-1' ;
    
    raise log 'Events: importing % rows',total;
    
    drop table public.events;
    
    CREATE TABLE public.events AS 
    select ev2.eventosid         ,ev2.data_evento  ,ev2.conteudo_topico, 
           ev2.tag_evento        ,ev2.tipo_conteudo,ev2.email, 
           ev2.categoria_conteudo,ev2.url_acessado ,ev2.tipo_usuario, 
           ev2.veiculo           ,ev2.dispositivo  ,ev2.id_materia, 
           ev2.nome_edicao       ,ev2.data_edicao  ,ev2.numero_edicao,
           ev2.tipo_edicao       ,ev2.id_materia_extraido,
           coalesce(ar_external_id.id, ar_exposed_id.id,ar_id.id) as article_id
      from (SELECT to_number(event.eventosid,'9999999999') as eventosid,
                   to_timestamp(event.data_evento,'DD-MM-YYYY HH24:MI:SS') as data_evento,
                   nullif(trim(event.conteudo_topico),'') as conteudo_topico,
                   nullif(trim(event.tag_evento),'') as tag_evento,
                   nullif(trim(event.tipo_conteudo),'') as tipo_conteudo,
                   nullif(trim(event.email),'') as email,
                   nullif(trim(event.categoria_conteudo),'') as categoria_conteudo,
                   nullif(trim(event.url_acessado),'') as url_acessado,
                   nullif(trim(event.tipo_usuario),'') as tipo_usuario,
                   nullif(trim(event.veiculo),'') as veiculo,
                   nullif(trim(event.dispositivo),'') as dispositivo,
                   nullif(nullif(trim(event.id_materia),'0'),'') as id_materia,
                   nullif(trim(event.nome_edicao),'') as nome_edicao,
                   to_date(event.data_edicao,'DD/MM/YYYY') as data_edicao,
                   to_number(nullif(nullif(trim(event.numero_edicao),''),'0'),'999999') as numero_edicao,
                   nullif(trim(event.tipo_edicao),'') as tipo_edicao,
                   coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                            substring(event.url_acessado from '[0-9]{6,7}'),
                            nullif(nullif(trim(event.id_materia),'0'),'')
                   ) as id_materia_extraido 
              FROM import.events_raw event
             where coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                            substring(event.url_acessado from '[0-9]{6,7}'),
                            nullif(nullif(trim(event.id_materia),'0'),'')
                            ) is not null
               and coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                            substring(event.url_acessado from '[0-9]{6,7}'),
                            nullif(nullif(trim(event.id_materia),'0'),'')
                            ) != '-1'
             ) ev2
    left join public.articles ar_external_id on ev2.id_materia_extraido = ar_external_id.external_id
    left join public.articles ar_exposed_id on ev2.id_materia_extraido = ar_exposed_id.exposed_id
    left join public.articles ar_id on ev2.id_materia_extraido = ar_id.id
    where coalesce(ar_external_id.id, ar_exposed_id.id,ar_id.id) is not null;
    
    /*for event in SELECT er.eventosid, 
                        er.data_evento, 
                        er.conteudo_topico, 
                        er.tag_evento, 
                        er.tipo_conteudo, 
                        er.email, 
                        er.categoria_conteudo, 
                        er.url_acessado, 
                        er.tipo_usuario, 
                        er.veiculo, 
                        er.dispositivo, 
                        er.id_materia, 
                        er.nome_edicao, 
                        er.data_edicao, 
                        er.numero_edicao, 
                        er.tipo_edicao
                   FROM import.events_raw er 
                  where coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                                           substring(event.url_acessado from '[0-9]{6,7}'),
                                           nullif(nullif(trim(event.id_materia),'0'),'')
                                           ) is not null loop
        INSERT INTO public.events(eventosid,
                                  data_evento,
                                  conteudo_topico,
                                  tag_evento,
                                  tipo_conteudo,
                                  email,
                                  categoria_conteudo,
                                  url_acessado,
                                  tipo_usuario,
                                  veiculo,
                                  dispositivo,
                                  id_materia,
                                  nome_edicao,
                                  data_edicao,
                                  numero_edicao,
                                  tipo_edicao,
                                  id_materia_extraido)
                          values (to_number(event.eventosid,'9999999999'),
                                  to_date(event.data_evento,'DD-MM-YYYY'),
                                  nullif(trim(event.conteudo_topico),''),
                                  nullif(trim(event.tag_evento),''),
                                  nullif(trim(event.tipo_conteudo),''),
                                  nullif(trim(event.email),''),
                                  nullif(trim(event.categoria_conteudo),''),
                                  nullif(trim(event.url_acessado),''),
                                  nullif(trim(event.tipo_usuario),''),
                                  nullif(trim(event.veiculo),''),
                                  nullif(trim(event.dispositivo),''),
                                  nullif(nullif(trim(event.id_materia),'0'),''),
                                  nullif(trim(event.nome_edicao),''),
                                  to_date(event.data_edicao,'DD-MM-YYYY'),
                                  to_number(nullif(nullif(trim(event.numero_edicao),''),'0'),'999999'),
                                  nullif(trim(event.tipo_edicao),''),
                                  coalesce(substring(substring(event.url_acessado from '-[a-z|A-Z|0-9]{25}\.html') from 2 for 25),
                                           substring(event.url_acessado from '[0-9]{6,7}'),
                                           nullif(nullif(trim(event.id_materia),'0'),'')
                                           )
                                  );
    
        parcial := parcial + 1;
        if (mod(parcial,round(total/100,0)) = 0 or parcial = total) then

            raise log 'Events: % percent imported',round(parcial/total*100,0);
        end if;  
    end loop;
    */
    raise log 'Events: % rows imported',total;
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
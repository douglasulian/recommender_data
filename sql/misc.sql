delete from import.articles_raw;
delete from import.events_raw;
delete from import.classifications_raw;
delete from import.newsletter_optins_raw;

select 'import.articles_raw'          as type, count(1) as qtd from import.articles_raw union
select 'import.events_raw'            as type, count(1) as qtd from import.events_raw union
select 'import.classifications_raw'   as type, count(1) as qtd from import.classifications_raw union
select 'import.newsletter_optins_raw' as type, count(1) as qtd from import.newsletter_optins_raw

select count(1) from users_newsletter_categories
delete  from users_newsletter_categories

select '  classifications'             as type, count(1) as qtt from classifications union
select '  classification_path_levels'  as type, count(1) as qtt from classification_path_levels union 
select '  articles'                    as type, count(1) as qtt from articles union 
select '  articles_tags'               as type, count(1) as qtt from articles_tags union 
select '  tags'                        as type, count(1) as qtt from tags union 
select '  events'                      as type, count(1) as qtt from events union 
select '  users'                       as type, count(1) as qtt from users union 
select '  newsletter_categories'       as type, count(1) as qtt from newsletter_categories union
select '  users_newsletter_categories' as type, count(1) as qtt from users_newsletter_categories
		
select name, count(1) 
from tags t inner join articles_tags at on t.id = at.tag_id
group by t.name
order by 2 desc

/*  users_newsletter_categories	0
  newsletter_categories	13
  classifications	408
  articles_tags	52370
  classification_path_levels	1201
  users	7796
  articles	10000
  tags	11987
  events	9999
*/

select count(1) --ev.id_materia_extraido,ar.id,ar.exposed_id,ev.url_acessado,ar.body 
from events ev inner join articles ar on ev.id_materia_extraido = ar.id
union
select count(1) --ev.id_materia_extraido,ar.id,ar.exposed_id,ev.id_materia,ar.external_id,ev.url_acessado,ar.body 
from events ev inner join articles ar on ev.id_materia_extraido = ar.external_id

select sum(b.encontrados) as encontrados, 
       sum(b.total)     as total,
       sum(b.encontrados)/sum(b.total) as perc_encontrados 
  from ( 
        select 0 as encontrados,
               count(1) as total
          from events ev3 
         where ev3.id_materia_extraido is not null 
        union all
        SELECT sum(b2.qtt) as encontrados,
               0 as total
          from (
		        select count(1) as qtt -- ev.eventosid,ev.id_materia_extraido,ar.id,ar.exposed_id,ev.url_acessado,ar.body 
				  from events ev 
				 inner join articles ar on ev.id_materia_extraido = ar.external_id
			     union all
			    select count(1) as qtt-- ev.eventosid,ev.id_materia_extraido,ar.id,ar.exposed_id,ev.url_acessado,ar.body 
			      from events ev 
			     inner join articles ar on ev.id_materia_extraido = ar.id
		          ) b2
       )b

select currval('sq_tag_id')


show data_directory
 

SELECT id, count(1) FROM import.classifications_raw group by id having count(1) > 1


--https://www.postgresql.org/docs/10/static/textsearch-dictionaries.html
--http://azakirov.blogspot.com.br/2015/12/dictionaries-and-postgresql-fts.html
--http://hunspell.github.io/
--volume de tags utilizando primeiro radical (steaming)
select count(distinct result[1]) 
  from (select tsvector_to_array(to_tsvector('portuguese',name)) as result 
          from tags
       ) a;

--executando duas vezes
select count(1) 
  from (select distinct to_tsvector('portuguese',result[1]) 
          from (select tsvector_to_array(to_tsvector('portuguese',name)) as result 
                  from tags limit 100
               ) a
       )b;


select count(1) 
  from (select distinct to_tsvector('portuguese',result_b[1]) 
          from (select tsvector_to_array(to_tsvector('portuguese',result[1])) as result_b 
                  from (select tsvector_to_array(to_tsvector('portuguese',name)) as result 
                          from tags
                       ) a
               ) b
       ) c

--verificação do efeito do steaming
select original, result[1], result,ts 
  from (select tsvector_to_array(to_tsvector('portuguese',name)) as result, 
               name as original,
               to_tsvector('portuguese',name) as ts 
          from tags limit 10
       ) a;


       
       
select public.get_sample(100)


set search_path to sample;

select u.email
        ,e.article_id as articleId
        ,(1507943080-avg(extract(epoch from e.data_evento))) as timeDiffSeconds
        ,(1507943080-avg(extract(epoch from e.data_evento)))/60 as timeDiffMinutes
        ,(1507943080-avg(extract(epoch from e.data_evento)))/60/60 as timeDiffHours
        ,(1507943080-avg(extract(epoch from e.data_evento)))/60/60/24 as timeDiffDays
        ,(1507943080-avg(extract(epoch from e.data_evento)))/60/60/24/30 as timeDiffMonths
        ,(1507943080-avg(extract(epoch from e.data_evento)))/60/60/24/365 as timeDiffMonths
        ,to_char(to_timestamp(1507943080),'YYYY-MM-DD HH24:MI:SS')
        --,to_char(avg(extract(epoch from e.data_evento)),'YYYY-MM-DD HH24:MI:SS')
        ,min(e.data_evento)
        ,max(e.data_evento)
    from users u 
   inner join events e on u.email = e.email
   group by u.email,e.article_id

select u.email
        ,e.article_id as articleId
        ,to_char(to_timestamp(1507943080),'YYYY-MM-DD HH24:MI:SS')
        ,extract(epoch from current_timestamp)
        ,e.data_evento
        ,extract(epoch from e.data_evento)
    from users u 
   inner join events e on u.email = e.email

select max(extract(epoch from e.data_evento)),max(e.data_evento) from events e


select now()

select current_timestamp
   
SELECT TIMESTAMP WITH TIME ZONE 'epoch' + 982384720.12 * INTERVAL '1 second';

select u.email  ,e.article_id as articleId  ,( 1507943080 - avg(extract(epoch from e.data_evento)))/60/60/24/365 as timeDiff  from users u  inner join events e on u.email = e.email group by u.email,e.article_id
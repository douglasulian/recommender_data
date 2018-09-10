/*
 
ALTER TABLE trainning.articles ADD push_time timestamp NULL;

update public.articles
set push_time = to_timestamp(p.send_time,'Dy, DD Mon YYYY HH24:MI:SS GMT')
from public.articles a inner join import.pushes_raw p on p.article_id = a.id

select count(1) from articles where push_time is not null

set search_path to 'testing'

UPDATE articles
SET push_time=subquery.push_time
FROM (select a.id, to_timestamp(p.send_time,'Dy, DD Mon YYYY HH24:MI:SS GMT') push_time
from articles a inner join import.pushes_raw p on p.article_id = a.id) AS subquery
WHERE articles.id=subquery.id

update articles
set push_time = pa.push_time 
from public.articles pa where articles.id = pa.id 
and pa.push_time is not null

*/
set search_path to 'trainning6000';



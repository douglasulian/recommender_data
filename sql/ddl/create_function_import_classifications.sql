CREATE OR REPLACE FUNCTION public.import_classifications() RETURNS numeric AS $$
DECLARE
    classification record;
    path_level numeric;
    path_level_name text;
    parcial numeric default 0;
    total numeric default 0;
begin
	select count(1) into strict total from import.classifications_raw;

    for classification in SELECT id, path FROM import.classifications_raw LOOP
    
        insert into classifications (id,path) 
                             values (nullif(trim(classification.id),''), 
                                     nullif(trim(classification.path),''));
    
        path_level := 0;
        
        foreach path_level_name in array regexp_split_to_array(classification.path,'[^/]+') loop
    		if (nullif(trim(path_level_name),'') is not null) then
            	insert into classification_path_levels (classification_id, 
                	                                    name, 
                    	                                level) 
                        	                    values (nullif(trim(classification.id),''), 
                            	                        nullif(trim(path_level_name),''),
                                	                    path_level);
                                	                    
            	path_level := path_level + 1;
            end if;
    	end loop;
        
    	parcial := parcial + 1;
        if (mod(parcial,round(total/100,0)) = 0 or parcial = total) then
        	raise log 'Classifications: % percent imported',round(parcial/total*100,0);
        end if;
	end loop;
	
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
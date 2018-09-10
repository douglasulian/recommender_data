CREATE OR REPLACE FUNCTION public.import_users() RETURNS numeric AS $$
DECLARE
    us record;
    
BEGIN
	
    insert into public.users (email) SELECT DISTINCT email FROM public.events where nullif(trim(email),'') is not null;
    
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
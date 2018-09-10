CREATE OR REPLACE FUNCTION public.import_newsletter_categories() RETURNS numeric AS $$
DECLARE
BEGIN
    
    insert into newsletter_categories (id,name) values ('1', 'Gremista ZH');
    insert into newsletter_categories (id,name) values ('2', 'Colorado ZH');
    insert into newsletter_categories (id,name) values ('3', 'Colunistas ZH');
    insert into newsletter_categories (id,name) values ('4', 'Destaques da Manhã');
    insert into newsletter_categories (id,name) values ('5', 'Destaques do Editor');
    insert into newsletter_categories (id,name) values ('6', 'Destemperados');
    insert into newsletter_categories (id,name) values ('7', 'Donna');
    insert into newsletter_categories (id,name) values ('8', 'Encare a Crise');
    insert into newsletter_categories (id,name) values ('9', 'Especiais ZH');
    insert into newsletter_categories (id,name) values ('10', 'ZH Doc');
    insert into newsletter_categories (id,name) values ('11', 'ZH Findi');
    insert into newsletter_categories (id,name) values ('12', 'ZH Viagem');
    insert into newsletter_categories (id,name) values ('13', 'ZH Vida');
    
    RETURN 0;
END;
$$ LANGUAGE plpgsql;
--1. Afiseaza numele si prenumele persoanelor  nascute dupa anul 1980
-- daca numele incepe cu litera prenumele cu litera 'A' afiseaza numarul de telefon
declare
    cursor c_person is
        select F_NAME, TELEFON,L_NAME
        from SIT_PERSON
        where extract(year from B_DAY) > 1980;
begin
    for pers in c_person loop
        if upper(substr(pers.F_NAME, 1, 1)) = 'A' then
            dbms_output.put_line( 'Persoana cu A telefon:'||pers.TELEFON);
        else
            dbms_output.put_line('Prenume:' || pers.F_NAME || ' Nume:' || pers.L_NAME);
        end if;
    end loop;
end;
/
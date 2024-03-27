set serverout on
--1. Afiseaza numele si prenumele persoanelor  nascute dupa anul 1980
-- daca numele incepe cu litera prenumele cu litera 'A' afiseaza numarul de telefon
declare
    cursor c_person is
        select F_NAME, TELEFON, L_NAME
        from SIT_PERSON
        where extract(year from B_DAY) > 1980;
begin
    for pers in c_person
        loop
            if upper(substr(pers.F_NAME, 1, 1)) = 'A' then
                dbms_output.put_line('Persoana cu A telefon:' || pers.TELEFON);
            else
                dbms_output.put_line('Prenume:' || pers.F_NAME || ' Nume:' || pers.L_NAME);
            end if;
        end loop;
end;
/
select *
from SIT_MATERII;
--2. afiseaza numele studentului cu id-ul 10 si dupa adauga nota 5 la matematica cu 2 sap in urma
declare
    v_nume   SIT_PERSON.F_NAME%type;
    v_id_mat SIT_CATALOGUE.id_materie%type;

begin
    select p.F_NAME
    into v_nume
    from SIT_PERSON p,
         SIT_USER u,
         SIT_USER_ROLES ur
    where p.ID = u.ID_PERS
      and u.ID = ur.ID_USER
      and ur.ID = 10;
    dbms_output.put_line('Numele studentului cu id-ul 10 este: ' || v_nume);
    select distinct cat.ID_MATERIE
    into v_id_mat
    from SIT_CATALOGUE cat,
         SIT_SUBJECT sub
    where ID_STUDENT = 10
      and cat.ID_MATERIE = sub.id
      and sub.ID_MATERIE = (select id from SIT_MATERII where upper(NAME) = 'MATEMATICA');
    insert into SIT_CATALOGUE values (SIT_CATALOGUE_SEQ.nextval, 5, 10, v_id_mat, trunc(sysdate - 14));
    commit;
exception
    when others then
        dbms_output.put_line('ERROR:' || sqlerrm);
end;
/

select cat.*
from SIT_CATALOGUE cat,
     SIT_SUBJECT sub
where ID_STUDENT = 10
  and cat.ID_MATERIE = sub.id
  and sub.ID_MATERIE = (select id from SIT_MATERII where upper(NAME) = 'MATEMATICA');

--3. Calculeaza media la matematica a studentului cu id-ul 10
declare
    v_media number;
begin
    select avg(NOTA)
    into v_media
    from SIT_CATALOGUE
    where ID_STUDENT = 10
      and ID_MATERIE = (select id from SIT_MATERII where upper(NAME) = 'MATEMATICA');
    dbms_output.put_line('Media la matematica a studentului cu id-ul 10 este: ' || v_media);
end;
/
--4. Pentru toti userii afiseaza daca sunt studenti afiseaza momentan student daca este profesor afiseaza preda
-- iar daca este parinte afiseaza are copil

declare
    cursor c_user is
        select *
        from SIT_USER_ROLES;

begin
    for rec in c_user
        loop
            if rec.ID_ROLE = 1 then
                dbms_output.put_line('Userul ' || rec.ID_USER || ' momentan student');
            elsif rec.ID_ROLE = 2 then
                dbms_output.put_line('Userul ' || rec.ID_USER || ' preda');
            elsif rec.ID_ROLE = 3 then
                dbms_output.put_line('Userul ' || rec.ID_USER || ' are copil');
            end if;
        end loop;
end;

--5. Modifica adresa user-ului cu id-ul 50 daca este profesor
select *
from SIT_USER_ROLES;
declare
    v_id_address SIT_USER.id%type;
begin
    select p.ID_ADDRESS
    into v_id_address
    from SIT_USER_ROLES ur,
         SIT_USER u,
         SIT_PERSON p
    where ur.ID_USER = u.ID
      and u.ID_PERS = p.ID
      and ur.ID = 50
      and ur.ID_ROLE = 2;
    if sql%found then
        update SIT_ADDRESS
        set ADDRESS = 'Str. Mihai Viteazu, nr. 10'
        where ID = v_id_address;
        dbms_output.put_line('Adresa a fost modificata');
    else
        dbms_output.put_line('Userul nu este profesor');
    end if;
exception
    when no_data_found then
        dbms_output.put_line('Userul nu este profesor/nu exista');
end;
--6 Insereaza un nou user cu rolul de student cu id-ul 1
declare
    INSERT_EXCP EXCEPTION;
    PRAGMA EXCEPTION_INIT (INSERT_EXCP, -00001);
begin
    insert into SIT_USER values (1, 'student', 'fdsfds', 1);
    commit;
exception
    when INSERT_EXCP then
        dbms_output.put_line('Nu s-a putut insera userul');
end;
--7. 
--1
set serveroutput on
declare
    v_id_client number      := &id_client;
    v_nume      clienti.NUME_CLIENT%type;
    cursor c_comenzi(p_id_client number) is
        select c.ID_COMANDA, c.DATA, sum(rc.PRET * rc.CANTITATE) valoare
        from COMENZI c,
             clienti cl,
             RAND_COMENZI rc
        where c.ID_CLIENT = cl.ID_CLIENT
          and rc.ID_COMANDA = c.ID_COMANDA
          and cl.ID_CLIENT = p_id_client
        group by c.ID_COMANDA, c.DATA;
    v_count     pls_integer := 0;
begin
    select nume_client into v_nume from CLIENTI where ID_CLIENT = v_id_client;
    DBMS_OUTPUT.put_line('Clientul: ' || v_nume);
    for c in c_comenzi(v_id_client)
        loop
            v_count := v_count + 1;
            dbms_output.put_line('Comanda: ' || c.ID_COMANDA || ' ' || c.data || ' ' || c.valoare);
        end loop;
    if v_count = 0 then
        dbms_output.put_line('Clientul nu are comenzi');
    elsif v_count = 1 then
        dbms_output.put_line('Clientul are o comanda');
    else
        dbms_output.put_line('Clientul are ' || v_count || ' comenzi');
    end if;
exception
    when no_data_found then
        dbms_output.put_line('Clientul nu exista');
end;
/

--2

DECLARE
    my_ex exception ;
    PRAGMA EXCEPTION_INIT(my_ex, -20001);
    CURSOR c IS SELECT nume
                FROM angajati where ID_DEPARTAMENT =1;
    r c%ROWTYPE;
BEGIN
    BEGIN
        OPEN c;
        fetch c into r;
        if c%NOTFOUND then
            RAISE my_ex;
        end if;
        DBMS_OUTPUT.PUT_LINE('Numele este ' || r.nume);
        loop
        FETCH c INTO r;
        exit when c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Numele este ' || r.nume);
        END LOOP;
        close c;
    EXCEPTION
        WHEN my_ex THEN
            DBMS_OUTPUT.PUT_LINE('Selectul nu a returnat niciun rand');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('A');
    END;
    DBMS_OUTPUT.PUT_LINE('B');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        DBMS_OUTPUT.PUT_LINE('C');
END;
/
--1. eroarea aparuta se poate afla punand un dbms_output.put_line(sqlerrm); in sectiunea de exceptie
--2. prin deschiderea cursorului inainte de a-l folosi
--3. se va afisa numele primului angajat din fetch, apoi se va afisa B
--5. se va afisa B

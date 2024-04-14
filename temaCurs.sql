DECLARE
    v_ref     sys_refcursor;
    v_angajat angajati%rowtype;
BEGIN
    PAC_PAC.AFISEAZA_ANG_DIN_DEPARTAMENT(30, v_ref);
    loop
        fetch v_ref into v_angajat;
        exit when v_ref%notfound;
        dbms_output.put_line(v_angajat.nume || ' ' || v_angajat.prenume);
    end loop;
END;
/


declare
    v_ref        sys_refcursor;
    v_ist        ISTORIC_FUNCTII%rowtype;
    v_id_angajat angajati.id_angajat%type := 101;
begin
    PAC_PAC.AFISEAZA_FUNCTII_ANTERIOARE(v_id_angajat, v_ref);
    DBMS_OUTPUT.put_line('Functii anterioare ale angajatului cu id' || v_id_angajat || ':');
    loop
        fetch v_ref into v_ist;
        exit when v_ref%notfound;

        DBMS_OUTPUT.put_line(v_ist.ID_FUNCTIE);
    end loop;
end;
/


declare
    v_id_angajat angajati.id_angajat%type := 100;
begin
    PAC_PAC.MODIFICA_SALARIU_ANGAJAT(v_id_angajat, 2000);
end;

select *
from angajati
where id_angajat = 100;



declare
    v_id_angajat angajati.id_angajat%type := 100;
begin
    PAC_PAC.MODIFICA_FUNCTIE_ANGAJAT(p_ang => v_id_angajat,
                                     p_functie_noua => 'MK_MAN',
                                     p_salariu_nou =>20000,
                                     p_dep_nou => 20
    );
end;

select *
from angajati
where id_angajat = 100;


select *
from ISTORIC_FUNCTII;
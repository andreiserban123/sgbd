CREATE OR REPLACE PACKAGE pac_pac AS

    -- Return all employees from the provided department
    PROCEDURE afiseaza_ang_din_departament(p_dep IN departamente.id_departament%TYPE,
                                           p_rezultat OUT SYS_REFCURSOR);

    -- Return all previous positions held by an employee from the employment history
    PROCEDURE afiseaza_functii_anterioare(p_ang IN angajati.id_angajat%TYPE,
                                          p_rezultat OUT SYS_REFCURSOR);

    -- Modify the salary of the provided employee
    PROCEDURE modifica_salariu_angajat(p_ang IN angajati.id_angajat%TYPE,
                                       p_salariu_nou IN angajati.salariul%TYPE);

    -- Modify the position of the provided employee
    PROCEDURE modifica_functie_angajat(p_ang IN angajati.id_angajat%TYPE,
                                       p_functie_noua IN functii.id_functie%TYPE,
                                       p_salariu_nou IN angajati.salariul%TYPE DEFAULT NULL,
                                       p_dep_nou IN departamente.id_departament%TYPE DEFAULT NULL);

END pac_pac;
/

CREATE OR REPLACE PACKAGE BODY pac_pac AS

    PROCEDURE afiseaza_ang_din_departament(p_dep IN departamente.id_departament%TYPE,
                                           p_rezultat OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_rezultat FOR
            SELECT nume, PRENUME FROM angajati WHERE id_departament = p_dep;
    END afiseaza_ang_din_departament;

    PROCEDURE afiseaza_functii_anterioare(p_ang IN angajati.id_angajat%TYPE,
                                          p_rezultat OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_rezultat FOR
            SELECT * FROM istoric_functii WHERE id_angajat = p_ang;
    END afiseaza_functii_anterioare;

    PROCEDURE modifica_salariu_angajat(p_ang IN angajati.id_angajat%TYPE,
                                       p_salariu_nou IN angajati.salariul%TYPE) IS
    BEGIN
        UPDATE angajati SET salariul = p_salariu_nou WHERE id_angajat = p_ang;
    END modifica_salariu_angajat;

    PROCEDURE modifica_functie_angajat(p_ang IN angajati.id_angajat%TYPE,
                                       p_functie_noua IN functii.id_functie%TYPE,
                                       p_salariu_nou IN angajati.salariul%TYPE DEFAULT NULL,
                                       p_dep_nou IN departamente.id_departament%TYPE DEFAULT NULL) IS
    BEGIN
        UPDATE angajati
        SET id_functie     = p_functie_noua,
            salariul       = NVL(p_salariu_nou, salariul),
            id_departament = NVL(p_dep_nou, id_departament)
        WHERE id_angajat = p_ang;
    END modifica_functie_angajat;

END pac_pac;
/
DECLARE
    v_refcursor     SYS_REFCURSOR;
    v_department_id departamente.id_departament%TYPE := 10;
    v_nume          angajati.nume%TYPE;
    v_prenume       angajati.prenume%TYPE;
BEGIN
    pac_pac.afiseaza_ang_din_departament(p_dep => v_department_id, p_rezultat => v_refcursor);
    open v_refcursor;
    loop
        fetch v_refcursor into v_nume, v_prenume;
        dbms_output.put_line('Nume: ' || v_nume || ', Prenume: ' || v_prenume);
        exit when v_refcursor%notfound;
    end loop;
    close v_refcursor;
EXCEPTION
    WHEN OTHERS THEN
        -- In case of an exception, make sure to close the cursor
        IF v_refcursor%ISOPEN THEN
            CLOSE v_refcursor;
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        RAISE;
END;
/


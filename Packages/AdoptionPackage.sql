CREATE OR REPLACE PACKAGE AdoptionPackage AS
    PROCEDURE ShowAdoptions;
    FUNCTION GetAdoptionRefById(adoption_id IN INT) RETURN REF Adoption_type;
END AdoptionPackage;
/

CREATE OR REPLACE PACKAGE BODY AdoptionPackage AS
    PROCEDURE ShowAdoptions IS
        dog_name VARCHAR2(100);
        client_name VARCHAR2(100);
        client_surname VARCHAR2(100);
        employee_name VARCHAR2(100);
        employee_surname VARCHAR2(100);
        dog_obj Dog_type;
        client_obj Client_type;
        employee_obj Employee_type;
    BEGIN
        FOR r IN (SELECT dog, client, employee, status FROM ADOPTION_TABLE) LOOP
            SELECT CAST(r.dog AS Dog_type) INTO dog_obj FROM dual;
            SELECT CAST(r.client AS Client_type) INTO client_obj FROM dual;
            SELECT CAST(r.employee AS Employee_type) INTO employee_obj FROM dual;

            dog_name := dog_obj.get_name();
            client_name := client_obj.get_name();
            client_surname := client_obj.get_surname();
            employee_name := employee_obj.get_name();
            employee_surname := employee_obj.get_surname();

            DBMS_OUTPUT.PUT_LINE('Dog Name: ' || dog_name);
            DBMS_OUTPUT.PUT_LINE('Client Name: ' || client_name || ' ' || client_surname);
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || employee_name || ' ' || employee_surname);
            DBMS_OUTPUT.PUT_LINE('Status: ' || r.status);
            DBMS_OUTPUT.PUT_LINE('---------------------');
        END LOOP;
    END ShowAdoptions;

    FUNCTION GetAdoptionRefById(adoption_id IN INT) RETURN REF Adoption_type AS
        adoption_ref REF Adoption_type;
    BEGIN
        SELECT REF(a) INTO adoption_ref FROM ADOPTION_TABLE a WHERE a.ID = adoption_id;
        RETURN adoption_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetAdoptionRefById;

END AdoptionPackage;
/





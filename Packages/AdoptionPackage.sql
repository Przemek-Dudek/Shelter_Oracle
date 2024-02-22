CREATE OR REPLACE PACKAGE AdoptionPackage AS
    PROCEDURE ShowAdoptions;
    PROCEDURE AddAdoption(
        p_Dog_ID INT,
        p_Client_ID INT,
        p_Employee_ID INT,
        p_Status VARCHAR2
    );
    FUNCTION GetAdoptionRefById(adoption_id IN INT) RETURN REF Adoption_type;
END AdoptionPackage;
/

CREATE OR REPLACE PACKAGE BODY AdoptionPackage AS

    PROCEDURE ShowAdoptions IS
        adoptions_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO adoptions_count FROM ADOPTION_TABLE;

        IF adoptions_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No adoptions to show');
        ELSE
            FOR r IN (SELECT ID, dog_ID, client_ID, employee_ID, status FROM ADOPTION_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Dog ID: ' || r.dog_ID);
                DBMS_OUTPUT.PUT_LINE('Client ID: ' || r.client_ID);
                DBMS_OUTPUT.PUT_LINE('Employee ID: ' || r.employee_ID);
                DBMS_OUTPUT.PUT_LINE('Status: ' || r.status);
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowAdoptions;

    PROCEDURE AddAdoption(
        p_Dog_ID INT,
        p_Client_ID INT,
        p_Employee_ID INT,
        p_Status VARCHAR2
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Adoption_sequence.NEXTVAL;
        INSERT INTO ADOPTION_TABLE
        VALUES (Adoption_type(next_id, p_Dog_ID, p_Client_ID, p_Employee_ID, p_Status));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added adoption with ID: ' || next_id || '.');
    END AddAdoption;

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

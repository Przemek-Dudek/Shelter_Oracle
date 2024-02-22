CREATE OR REPLACE PACKAGE ClientPackage AS
    PROCEDURE ShowClients;
    PROCEDURE AddClient(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    );
    FUNCTION GetClientRefById(client_id IN INT) RETURN REF Client_type;
END ClientPackage;
/

CREATE OR REPLACE PACKAGE BODY ClientPackage AS

    PROCEDURE ShowClients IS
        clients_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO clients_count FROM CLIENT_TABLE;

        IF clients_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No clients to show');
        ELSE
            FOR r IN (SELECT ID, Name, Surname, Phone FROM CLIENT_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Name: ' || r.Name);
                DBMS_OUTPUT.PUT_LINE('Surname: ' || r.Surname);
                DBMS_OUTPUT.PUT_LINE('Phone: ' || r.Phone);
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowClients;

    PROCEDURE AddClient(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Client_sequence.NEXTVAL;
        INSERT INTO CLIENT_TABLE
        VALUES (Client_type(next_id, p_Name, p_Surname, p_Phone));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added client ' || p_Name || ' ' || p_Surname || ' with ID: ' || next_id || '.');
    END AddClient;

    FUNCTION GetClientRefById(client_id IN INT) RETURN REF Client_type AS
        client_ref REF Client_type;
    BEGIN
        SELECT REF(c) INTO client_ref FROM CLIENT_TABLE c WHERE c.ID = client_id;
        RETURN client_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetClientRefById;

END ClientPackage;
/

CREATE OR REPLACE FUNCTION Get_Client_By_Id(client_id IN INT)
RETURN Client_type
IS
    client Client_type;
BEGIN
    SELECT Client_type(ID, Name, Surname, Phone)
    INTO client
    FROM CLIENT_TABLE
    WHERE ID = client_id;

    RETURN client;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END Get_Client_By_Id;
/

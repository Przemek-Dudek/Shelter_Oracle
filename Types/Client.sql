CREATE SEQUENCE Client_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Client_type AS OBJECT (
    ID INT,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Phone VARCHAR(15),

    MEMBER FUNCTION get_name RETURN VARCHAR2,
    MEMBER FUNCTION get_surname RETURN VARCHAR2,
    MEMBER FUNCTION get_phone RETURN VARCHAR2,

    STATIC FUNCTION create_client(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    ) RETURN Client_type
);
/

CREATE OR REPLACE TYPE BODY Client_type AS
    -- Member function implementations
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.Name;
    END get_name;

    MEMBER FUNCTION get_surname RETURN VARCHAR2 IS
    BEGIN
        RETURN self.Surname;
    END get_surname;

    MEMBER FUNCTION get_phone RETURN VARCHAR2 IS
    BEGIN
        RETURN self.Phone;
    END get_phone;

    STATIC FUNCTION create_client(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    ) RETURN Client_type IS
        new_client Client_type;
    BEGIN
        new_client := Client_type(
            Client_sequence.NEXTVAL,
            p_Name,
            p_Surname,
            p_Phone
        );
        RETURN new_client;
    END create_client;
END;
/
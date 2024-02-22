CREATE TYPE Dog_type_array AS TABLE OF Dog_type;
CREATE TYPE Employee_type_array AS TABLE OF Employee_type;

CREATE SEQUENCE Shelter_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Shelter_type AS OBJECT (
    ID INT,
    opening_hour VARCHAR2(10),
    closing_hour VARCHAR2(10),
    address Address_type,
    feed_stock INT,
    dogs Dog_type_array,
    employees Employee_type_array,

    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT
    ) RETURN Shelter_type
)
NESTED TABLE dogs STORE AS dogs_table
NESTED TABLE employees STORE AS employees_table;

CREATE OR REPLACE TYPE BODY Shelter_type AS
    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT
    ) RETURN SELF AS RESULT IS
    BEGIN
        ID := Shelter_sequence.NEXTVAL;
        opening_hour := p_opening_hour;
        closing_hour := p_closing_hour;
        address := Address_type(p_street, p_city, p_number);
        dogs := Dog_type_array();
        employees := Employee_type_array();
        RETURN;
    END;

    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        RETURN address IS NOT NULL AND opening_hour IS NOT NULL
               AND closing_hour IS NOT NULL AND dogs IS NOT NULL
               AND employees IS NOT NULL;
    END;

    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT
    ) RETURN Shelter_type IS
        new_shelter Shelter_type;
    BEGIN
        new_shelter := Shelter_type(
            p_opening_hour,
            p_closing_hour,
            p_street,
            p_city,
            p_number
        );

        IF NOT new_shelter.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid shelter data');
        END IF;

        RETURN new_shelter;
    END;
END;
/

CREATE OR REPLACE TYPE Shelter_type AS OBJECT (
    ID INT,

    opening_hour VARCHAR2(10),
    closing_hour VARCHAR2(10),

    address Address_type,

    CONSTRUCTOR FUNCTION Shelter_type (
        p_ID INT,
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number VARCHAR2
    ) RETURN SELF AS RESULT
);

CREATE OR REPLACE TYPE BODY Shelter_type AS
    CONSTRUCTOR FUNCTION Shelter_type (
        p_ID INT,
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        ID := p_ID;
        opening_hour := p_opening_hour;
        closing_hour := p_closing_hour;
        address := Address_type(p_street, p_city, p_number);
        RETURN;
    END;
END;
/
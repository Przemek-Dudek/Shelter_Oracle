CREATE SEQUENCE Shelter_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Shelter_type AS OBJECT (
    ID INT,
    opening_hour VARCHAR2(10),
    closing_hour VARCHAR2(10),
    address ADDRESS_TYPE,
    feed_stock INT, -- New attribute

    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- Additional parameter for feed stock
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- Additional parameter for feed stock
    ) RETURN Shelter_type
);
/

CREATE OR REPLACE TYPE BODY Shelter_type AS
    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- Additional parameter for feed stock
    ) RETURN SELF AS RESULT IS
    BEGIN
        ID := Shelter_sequence.NEXTVAL;
        opening_hour := p_opening_hour;
        closing_hour := p_closing_hour;
        address := Address_type(p_street, p_city, p_number);
        feed_stock := p_feed_stock; -- Set the feed stock attribute
        RETURN;
    END;

    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        RETURN address IS NOT NULL AND opening_hour IS NOT NULL
               AND closing_hour IS NOT NULL;
    END;

    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- Additional parameter for feed stock
    ) RETURN Shelter_type IS
        new_shelter Shelter_type;
    BEGIN
        new_shelter := Shelter_type(
            p_opening_hour,
            p_closing_hour,
            p_street,
            p_city,
            p_number,
            p_feed_stock -- Pass the feed stock parameter
        );

        IF NOT new_shelter.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid shelter data');
        END IF;

        RETURN new_shelter;
    END;
END;
/

CREATE SEQUENCE Dog_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Dog_type AS OBJECT (
    ID INT,
    race VARCHAR(100),
    shelter SHELTER_TYPE,
    age INT,
    name VARCHAR(100),
    status VARCHAR(20),
    weight FLOAT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    MEMBER FUNCTION get_name RETURN VARCHAR2,

    CONSTRUCTOR FUNCTION Dog_type(
        p_ID INT,
        p_race VARCHAR,
        p_shelter SHELTER_TYPE,
        p_age INT,
        p_name VARCHAR,
        p_status VARCHAR,
        p_weight FLOAT
    ) RETURN SELF AS RESULT
);
/


CREATE OR REPLACE TYPE BODY Dog_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        IF race IS NULL OR age IS NULL OR name IS NULL OR status IS NULL OR weight IS NULL THEN
            RETURN FALSE;
        END IF;

        IF shelter IS NULL OR NOT shelter.is_valid THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.name;
    END get_name;

    CONSTRUCTOR FUNCTION Dog_type(
        p_ID INT,
        p_race VARCHAR,
        p_shelter SHELTER_TYPE,
        p_age INT,
        p_name VARCHAR,
        p_status VARCHAR,
        p_weight FLOAT
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ID := p_ID;
        SELF.race := p_race;
        SELF.shelter := p_shelter;
        SELF.age := p_age;
        SELF.name := p_name;
        SELF.status := p_status;
        SELF.weight := p_weight;

        -- Return the initialized object
        RETURN;
    END;
END;
/

CREATE SEQUENCE Dog_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Dog_type AS OBJECT (
    ID INT,
    race VARCHAR(100),
    age INT,
    name VARCHAR(100),
    status VARCHAR(20),
    weight FLOAT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_dog(
        p_race VARCHAR, p_age INT, p_name VARCHAR, p_status VARCHAR, p_weight FLOAT
    ) RETURN Dog_type
);
/

CREATE OR REPLACE TYPE BODY Dog_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        IF race IS NULL OR age IS NULL OR name IS NULL OR status IS NULL OR weight IS NULL THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    STATIC FUNCTION create_dog(
        p_race VARCHAR, p_age INT, p_name VARCHAR, p_status VARCHAR, p_weight FLOAT
    ) RETURN Dog_type IS
        v_dog Dog_type;
    BEGIN
        v_dog := Dog_type(
            Dog_sequence.NEXTVAL, p_race, p_age, p_name, p_status, p_weight
        );

        IF NOT v_dog.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid dog data');
        END IF;

        RETURN v_dog;
    END;
END;
/
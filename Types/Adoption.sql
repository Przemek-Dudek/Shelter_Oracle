CREATE SEQUENCE Adoption_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Adoption_type AS OBJECT (
    ID INT,
    dog_ID INT,
    client_ID INT,
    employee_ID INT,
    status VARCHAR(20),

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_adoption(
        p_dog_ID INT, p_client_ID INT, p_employee_ID INT, p_status VARCHAR
    ) RETURN Adoption_type
);
/

CREATE OR REPLACE TYPE BODY Adoption_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        IF dog_ID IS NULL OR client_ID IS NULL OR employee_ID IS NULL THEN
            RETURN FALSE;
        END IF;

        IF status NOT IN ('Rozpoczęta', 'Procesowanie', 'Zakończona') THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    STATIC FUNCTION create_adoption(
        p_dog_ID INT, p_client_ID INT, p_employee_ID INT, p_status VARCHAR
    ) RETURN Adoption_type IS
        v_adoption Adoption_type;
    BEGIN
        v_adoption := Adoption_type(
            Adoption_sequence.NEXTVAL, p_dog_ID, p_client_ID, p_employee_ID, p_status
        );

        IF NOT v_adoption.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid adoption data');
        END IF;

        RETURN v_adoption;
    END;
END;
/


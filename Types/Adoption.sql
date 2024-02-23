CREATE SEQUENCE Adoption_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Adoption_type AS OBJECT (
    ID INT,
    dog REF Dog_type,
    client REF Client_type,
    employee REF Employee_type,
    status VARCHAR(20),

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_adoption(
        p_dog REF Dog_type, p_client REF Client_type, p_employee REF Employee_type, p_status VARCHAR
    ) RETURN Adoption_type
);
/

CREATE OR REPLACE TYPE BODY Adoption_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
        v_dog_status VARCHAR(20);
    BEGIN
        IF self.dog IS NULL OR self.client IS NULL OR self.employee IS NULL THEN
            RETURN FALSE;
        END IF;

        -- Assuming get_dog_status is defined and accessible
        v_dog_status := get_dog_status(self.dog);

        IF self.status NOT IN ('Rozpoczęta', 'Procesowanie', 'Zakończona') THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    STATIC FUNCTION create_adoption (
        p_dog REF Dog_type, p_client REF Client_type, p_employee REF Employee_type, p_status VARCHAR
    ) RETURN Adoption_type IS
        new_adoption Adoption_type;
    BEGIN
        new_adoption := Adoption_type(
            Adoption_sequence.NEXTVAL, p_dog, p_client, p_employee, p_status
        );

        IF NOT new_adoption.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid adoption data');
        END IF;

        RETURN new_adoption;
    END;
END;
/

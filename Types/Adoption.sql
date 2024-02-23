CREATE SEQUENCE Adoption_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Adoption_type AS OBJECT (
    ID INT,
    dog REF Dog_type,
    client REF Client_type,
    employee REF Employee_type,
    status VARCHAR(20),

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_adoption(
        p_dog_ID INT, p_client_ID INT, p_employee_ID INT, p_status VARCHAR
    ) RETURN Adoption_type
);
/

CREATE OR REPLACE TYPE BODY Adoption_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
        v_dog_status VARCHAR(20);
    BEGIN
        v_dog_status := get_dog_status(self.dog);

        IF DEREF(self.dog) IS NULL OR self.client IS NULL OR self.employee IS NULL THEN
            RETURN FALSE;
        END IF;

        IF self.status NOT IN ('Rozpoczęta', 'Procesowanie', 'Zakończona') THEN
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
            Adoption_sequence.NEXTVAL,
            (SELECT REF(d) FROM Dog_type d WHERE d.ID = p_dog_ID),
            (SELECT REF(c) FROM Client_type c WHERE c.ID = p_client_ID),
            (SELECT REF(e) FROM Employee_type e WHERE e.ID = p_employee_ID),
            p_status
        );

        IF NOT v_adoption.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid adoption data');
        END IF;

        RETURN v_adoption;
    END;
END;
/

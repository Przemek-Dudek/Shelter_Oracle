CREATE OR REPLACE FUNCTION get_dog_status(dog_ref IN REF Dog_type)
    RETURN VARCHAR2
    IS
        dog_status VARCHAR2(100);
    BEGIN
        SELECT d.status INTO dog_status FROM Dog_type d WHERE REF(d) = dog_ref;

        RETURN dog_status;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Status Not Found';
        WHEN OTHERS THEN
            RETURN 'Error';
    END;
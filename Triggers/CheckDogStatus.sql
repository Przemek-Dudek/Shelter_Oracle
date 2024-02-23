CREATE OR REPLACE TRIGGER CheckAdoptionStatus
BEFORE INSERT ON Adoption_Table
FOR EACH ROW
DECLARE
    dog_status VARCHAR(20);
BEGIN
    SELECT status INTO dog_status
    FROM Dog_Table
    WHERE ID = :NEW.dog_ID;

    IF dog_status != 'Available' THEN
        RAISE_APPLICATION_ERROR(-20005, 'The dog is not available for adoption.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Dog ID not found.');
    WHEN OTHERS THEN
        RAISE;
END;
/

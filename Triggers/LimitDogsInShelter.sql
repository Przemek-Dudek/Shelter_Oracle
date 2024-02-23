CREATE OR REPLACE TRIGGER limit_dogs_in_shelter
BEFORE INSERT ON Dog_Table
FOR EACH ROW
DECLARE
    max_dogs_in_shelter CONSTANT INT := 1;
    current_dogs_count INT;
BEGIN
    SELECT COUNT(*) INTO current_dogs_count
    FROM Dog_Table
    WHERE shelter.ID = :NEW.shelter.ID;

    IF current_dogs_count >= max_dogs_in_shelter THEN
        RAISE_APPLICATION_ERROR(-20006, 'Cannot add more dogs. Shelter is at full capacity.');
    END IF;
END;
/

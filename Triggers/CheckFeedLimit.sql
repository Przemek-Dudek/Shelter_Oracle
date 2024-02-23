CREATE OR REPLACE TRIGGER check_feed_limit
BEFORE UPDATE OF feed_stock ON Shelter_Table
FOR EACH ROW
DECLARE
    max_feed_limit CONSTANT INT := 1000;
BEGIN
    IF :NEW.feed_stock > max_feed_limit THEN
        RAISE_APPLICATION_ERROR(-20009, 'Cannot add more feed. Shelter reached maximum feed limit.');
    END IF;
END;
/
CREATE OR REPLACE FUNCTION Get_Dog_By_Id(dog_id IN INT)
RETURN Dog_type
IS
    v_dog Dog_type;
BEGIN
    SELECT Dog_type(ID, race, age, name, status, weight)
    INTO v_dog
    FROM DOG_TABLE
    WHERE ID = dog_id;

    RETURN v_dog;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END Get_Dog_By_Id;
/

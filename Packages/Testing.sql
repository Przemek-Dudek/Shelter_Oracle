-- ### Testing for Dog ###
-- Test AddDog
BEGIN
    DBMS_OUTPUT.PUT_LINE('Adding a dogs dog:');
    DogPackage.AddDog('Labrador', 3, 'Max', 'Healthy', 25.5);
    DogPackage.AddDog('German Shepherd', 2, 'Buddy', 'Healthy', 30.0);
    DogPackage.AddDog('Golden Retriever', 1, 'Mikey', 'Healthy', 23.0);
END;
/

-- Test ShowDogs
BEGIN
    DBMS_OUTPUT.PUT_LINE('Showing dogs:');
    DogPackage.ShowDogs;
END;
/

-- Test ShowDogDetails
DECLARE
    dog_id INT := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Showing details for dog with ID ' || dog_id);
    DogPackage.ShowDogDetails(dog_id);
END;
/


-- ### Testing for Shelter ###
-- Test AddShelter
DECLARE
    opening_hour VARCHAR2(10) := '08:00';
    closing_hour VARCHAR2(10) := '18:00';
    street VARCHAR2(100) := 'Main St';
    city VARCHAR2(100) := 'New York';
    number INT := 123;
    feed_stock INT := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Adding a new shelter:');
    ShelterPackage.AddShelter(opening_hour, closing_hour, street, city, number, feed_stock);
END;
/

-- Test ShowShelterInfo
DECLARE
    shelter_id INT := 4;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Showing info for shelter with ID ' || shelter_id);
    ShelterPackage.ShowShelterInfo(shelter_id);
END;

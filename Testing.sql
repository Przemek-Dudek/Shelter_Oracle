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
    shelter_id INT := 2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Showing info for shelter with ID ' || shelter_id);
    ShelterPackage.ShowShelterInfo(shelter_id);
END;


-- ### Testing for Dog ###
-- Test AddDog
DECLARE
    shelter SHELTER_TYPE;
    opening_hour VARCHAR2(10) := '08:00';
    closing_hour VARCHAR2(10) := '18:00';
    street VARCHAR2(100) := 'Main St';
    city VARCHAR2(100) := 'New York';
    number INT := 123;
    feed_stock INT := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Adding a dog:');

    shelter := SHELTER_TYPE(opening_hour, closing_hour, street, city, number, feed_stock);

    DogPackage.AddDog('Labrador', 3, 'Max', 'Healthy', 25.5, shelter);
    DogPackage.AddDog('German Shepherd', 2, 'Buddy', 'Healthy', 30.0, shelter);
    DogPackage.AddDog('Golden Retriever', 1, 'Mikey', 'Healthy', 23.0, shelter);
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

-- Test CheckDogStatus
DECLARE
    dog_ref REF Dog_type;
    status VARCHAR2(100);
BEGIN
    -- Assuming you have a dog in your Dog_table
    SELECT REF(d) INTO dog_ref FROM Dog_table d WHERE d.ID = 1;

    -- Call the function
    status := get_dog_status(dog_ref);

    -- Display the result
    DBMS_OUTPUT.PUT_LINE('Dog Status: ' || status);
END;
/

-- Test GetDogById
DECLARE
    dog_id INT := 1; -- Assuming the ID of the dog you want to retrieve
    dog Dog_type;
BEGIN
    dog := GET_DOG_BY_ID(dog_id);

    IF dog IS NOT NULL THEN
        -- Print dog details
        DBMS_OUTPUT.PUT_LINE('Dog ID: ' || dog.ID);
        DBMS_OUTPUT.PUT_LINE('Race: ' || dog.race);
        DBMS_OUTPUT.PUT_LINE('Age: ' || dog.age);
        DBMS_OUTPUT.PUT_LINE('Name: ' || dog.name);
        DBMS_OUTPUT.PUT_LINE('Status: ' || dog.status);
        DBMS_OUTPUT.PUT_LINE('Weight: ' || dog.weight);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dog with ID ' || dog_id || ' not found.');
    END IF;
END;
/

-- ### Testing for Client ###
-- Test procedure to show clients
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Showing Clients ---');
    ClientPackage.ShowClients;
END;
/

-- Test procedure to add a client
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Adding Client ---');
    ClientPackage.AddClient('John', 'Doe', '123456789');
END;
/

-- Test function to get client reference by ID
DECLARE
    client_id INT := 1; -- Assuming the ID of the client you want to retrieve
    client Client_type;
BEGIN
    client := Get_Client_By_Id(client_id);

    IF client IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Client ID: ' || client.ID);
        DBMS_OUTPUT.PUT_LINE('Client Name: ' || client.Name);
        DBMS_OUTPUT.PUT_LINE('Client Surname: ' || client.Surname);
        DBMS_OUTPUT.PUT_LINE('Client Phone: ' || client.Phone);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Client with ID ' || client_id || ' not found.');
    END IF;
END;
/
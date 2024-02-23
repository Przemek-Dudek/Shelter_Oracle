--### TYPES ###

CREATE OR REPLACE TYPE Address_type AS OBJECT (
    street VARCHAR2(100),
    city VARCHAR2(100),
    number_ INT
);

CREATE SEQUENCE Client_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Client_type AS OBJECT (
    ID INT,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE SEQUENCE Employee_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Employee_type AS OBJECT (
    ID INT,
    name VARCHAR(100),
    surname VARCHAR(100),
    salary FLOAT,
    date_of_hire DATE
);

CREATE SEQUENCE Dog_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Dog_type AS OBJECT (
    ID INT,
    race VARCHAR(100),
    age INT,
    name VARCHAR(100),
    status VARCHAR(20),
    weight FLOAT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_dog(
        p_race VARCHAR, p_age INT, p_name VARCHAR, p_status VARCHAR, p_weight FLOAT
    ) RETURN Dog_type
);
/

CREATE OR REPLACE TYPE BODY Dog_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        IF race IS NULL OR age IS NULL OR name IS NULL OR status IS NULL OR weight IS NULL THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    STATIC FUNCTION create_dog(
        p_race VARCHAR, p_age INT, p_name VARCHAR, p_status VARCHAR, p_weight FLOAT
    ) RETURN Dog_type IS
        v_dog Dog_type;
    BEGIN
        v_dog := Dog_type(
            Dog_sequence.NEXTVAL, p_race, p_age, p_name, p_status, p_weight
        );

        IF NOT v_dog.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid dog data');
        END IF;

        RETURN v_dog;
    END;
END;
/

CREATE TABLE Dog_Table OF DOG_TYPE (PRIMARY KEY (ID));


CREATE OR REPLACE FUNCTION get_dog_status(dog_ref IN REF Dog_type)
RETURN VARCHAR2
IS
    dog_status VARCHAR2(100);
BEGIN
    SELECT VALUE(d).status INTO dog_status FROM Dog_table d WHERE REF(d) = dog_ref;

    RETURN dog_status;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Status Not Found';
    WHEN OTHERS THEN
        RETURN 'Error';
END;
/


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












CREATE SEQUENCE Shelter_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Shelter_type AS OBJECT (
    ID INT,
    opening_hour VARCHAR2(10),
    closing_hour VARCHAR2(10),
    address ADDRESS_TYPE,
    feed_stock INT,

    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT
    ) RETURN Shelter_type
);
/

CREATE OR REPLACE TYPE BODY Shelter_type AS
    CONSTRUCTOR FUNCTION Shelter_type (
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT
    ) RETURN SELF AS RESULT IS
    BEGIN
        ID := Shelter_sequence.NEXTVAL;
        opening_hour := p_opening_hour;
        closing_hour := p_closing_hour;
        address := Address_type(p_street, p_city, p_number);
        feed_stock := p_feed_stock;
        RETURN;
    END;

    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        RETURN address IS NOT NULL AND opening_hour IS NOT NULL
               AND closing_hour IS NOT NULL;
    END;

    STATIC FUNCTION create_shelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT
    ) RETURN Shelter_type IS
        new_shelter Shelter_type;
    BEGIN
        new_shelter := Shelter_type(
            p_opening_hour,
            p_closing_hour,
            p_street,
            p_city,
            p_number,
            p_feed_stock
        );

        IF NOT new_shelter.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid shelter data');
        END IF;

        RETURN new_shelter;
    END;
END;
/

--### CREATE TABLES ###

CREATE TABLE Adoption_Table OF ADOPTION_TYPE (PRIMARY KEY (ID));

CREATE TABLE Employees_Table  OF EMPLOYEE_TYPE (PRIMARY KEY (ID));

CREATE TABLE Client_Table OF CLIENT_TYPE (PRIMARY KEY (ID));


--### CREATE PACKAGES ###

CREATE OR REPLACE PACKAGE AdoptionPackage AS
    PROCEDURE ShowAdoptions;
    PROCEDURE AddAdoption(
        p_Dog_ID INT,
        p_Client_ID INT,
        p_Employee_ID INT,
        p_Status VARCHAR2
    );
    FUNCTION GetAdoptionRefById(adoption_id IN INT) RETURN REF Adoption_type;
END AdoptionPackage;
/

CREATE OR REPLACE PACKAGE BODY AdoptionPackage AS

    PROCEDURE ShowAdoptions IS
        adoptions_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO adoptions_count FROM ADOPTION_TABLE;

        IF adoptions_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No adoptions to show');
        ELSE
            FOR r IN (SELECT ID, dog_ID, client_ID, employee_ID, status FROM ADOPTION_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Dog ID: ' || r.dog_ID);
                DBMS_OUTPUT.PUT_LINE('Client ID: ' || r.client_ID);
                DBMS_OUTPUT.PUT_LINE('Employee ID: ' || r.employee_ID);
                DBMS_OUTPUT.PUT_LINE('Status: ' || r.status);
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowAdoptions;

    PROCEDURE AddAdoption(
        p_Dog_ID INT,
        p_Client_ID INT,
        p_Employee_ID INT,
        p_Status VARCHAR2
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Adoption_sequence.NEXTVAL;
        INSERT INTO ADOPTION_TABLE
        VALUES (Adoption_type(next_id, p_Dog_ID, p_Client_ID, p_Employee_ID, p_Status));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added adoption with ID: ' || next_id || '.');
    END AddAdoption;

    FUNCTION GetAdoptionRefById(adoption_id IN INT) RETURN REF Adoption_type AS
        adoption_ref REF Adoption_type;
    BEGIN
        SELECT REF(a) INTO adoption_ref FROM ADOPTION_TABLE a WHERE a.ID = adoption_id;
        RETURN adoption_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetAdoptionRefById;

END AdoptionPackage;
/


CREATE OR REPLACE PACKAGE ClientPackage AS
    PROCEDURE ShowClients;
    PROCEDURE AddClient(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    );
    FUNCTION GetClientRefById(client_id IN INT) RETURN REF Client_type;
END ClientPackage;
/

CREATE OR REPLACE PACKAGE BODY ClientPackage AS

    PROCEDURE ShowClients IS
        clients_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO clients_count FROM CLIENT_TABLE;

        IF clients_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No clients to show');
        ELSE
            FOR r IN (SELECT ID, Name, Surname, Phone FROM CLIENT_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Name: ' || r.Name);
                DBMS_OUTPUT.PUT_LINE('Surname: ' || r.Surname);
                DBMS_OUTPUT.PUT_LINE('Phone: ' || r.Phone);
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowClients;

    PROCEDURE AddClient(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Phone VARCHAR2
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Client_sequence.NEXTVAL;
        INSERT INTO CLIENT_TABLE
        VALUES (Client_type(next_id, p_Name, p_Surname, p_Phone));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added client ' || p_Name || ' ' || p_Surname || ' with ID: ' || next_id || '.');
    END AddClient;

    FUNCTION GetClientRefById(client_id IN INT) RETURN REF Client_type AS
        client_ref REF Client_type;
    BEGIN
        SELECT REF(c) INTO client_ref FROM CLIENT_TABLE c WHERE c.ID = client_id;
        RETURN client_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetClientRefById;

END ClientPackage;
/


CREATE OR REPLACE PACKAGE DogPackage AS
    PROCEDURE ShowDogs;
    PROCEDURE AddDog(
        p_race VARCHAR2,
        p_age INT,
        p_name VARCHAR2,
        p_status VARCHAR2,
        p_weight FLOAT
    );
    PROCEDURE ShowDogDetails(dog_id IN INT);
END DogPackage;
/

CREATE OR REPLACE PACKAGE BODY DogPackage AS

    PROCEDURE ShowDogs IS
        dogs_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO dogs_count FROM DOG_TABLE;

        IF dogs_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No dogs to show');
        ELSE
            FOR r IN (SELECT ID, race, age, name, status, weight FROM DOG_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Race: ' || r.race);
                DBMS_OUTPUT.PUT_LINE('Age: ' || r.age);
                DBMS_OUTPUT.PUT_LINE('Name: ' || r.name);
                DBMS_OUTPUT.PUT_LINE('Status: ' || r.status);
                DBMS_OUTPUT.PUT_LINE('Weight: ' || r.weight);
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowDogs;

    PROCEDURE AddDog(
        p_race VARCHAR2,
        p_age INT,
        p_name VARCHAR2,
        p_status VARCHAR2,
        p_weight FLOAT
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Dog_sequence.NEXTVAL;
        INSERT INTO DOG_TABLE
        VALUES (Dog_type(next_id, p_race, p_age, p_name, p_status, p_weight));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added dog ' || p_name || ' with ID: ' || next_id || '.');
    END AddDog;

    PROCEDURE ShowDogDetails(dog_id IN INT) IS
        v_race VARCHAR2(100);
        v_age INT;
        v_name VARCHAR2(100);
        v_status VARCHAR2(20);
        v_weight FLOAT;
    BEGIN
        SELECT race, age, name, status, weight INTO v_race, v_age, v_name, v_status, v_weight
        FROM DOG_TABLE
        WHERE ID = dog_id;

        -- Print dog details
        DBMS_OUTPUT.PUT_LINE('Dog ID: ' || dog_id);
        DBMS_OUTPUT.PUT_LINE('Race: ' || v_race);
        DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
        DBMS_OUTPUT.PUT_LINE('Weight: ' || v_weight);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Dog with ID ' || dog_id || ' not found.');
    END ShowDogDetails;
END DogPackage;
/


CREATE OR REPLACE PACKAGE EmployeePackage AS
    PROCEDURE ShowEmployees;
    PROCEDURE AddEmployee(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Salary FLOAT,
        p_Date_of_hire DATE
    );
    FUNCTION GetEmployeeRefById(employee_id IN INT) RETURN REF Employee_type;
END EmployeePackage;
/

CREATE OR REPLACE PACKAGE BODY EmployeePackage AS

    PROCEDURE ShowEmployees IS
        employees_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO employees_count FROM EMPLOYEES_TABLE;

        IF employees_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No employees to show');
        ELSE
            FOR r IN (SELECT ID, name, surname, salary, date_of_hire FROM EMPLOYEES_TABLE)
            LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID);
                DBMS_OUTPUT.PUT_LINE('Name: ' || r.name);
                DBMS_OUTPUT.PUT_LINE('Surname: ' || r.surname);
                DBMS_OUTPUT.PUT_LINE('Salary: ' || r.salary);
                DBMS_OUTPUT.PUT_LINE('Date of Hire: ' || TO_CHAR(r.date_of_hire, 'YYYY-MM-DD'));
                DBMS_OUTPUT.PUT_LINE('---------------------');
            END LOOP;
        END IF;
    END ShowEmployees;

    PROCEDURE AddEmployee(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Salary FLOAT,
        p_Date_of_hire DATE
    ) IS
        next_id NUMBER;
    BEGIN
        next_id := Employee_sequence.NEXTVAL;
        INSERT INTO EMPLOYEES_TABLE
        VALUES (Employee_type(next_id, p_Name, p_Surname, p_Salary, p_Date_of_hire));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added employee ' || p_Name || ' ' || p_Surname || ' with ID: ' || next_id || '.');
    END AddEmployee;

    FUNCTION GetEmployeeRefById(employee_id IN INT) RETURN REF Employee_type AS
        employee_ref REF Employee_type;
    BEGIN
        SELECT REF(e) INTO employee_ref FROM EMPLOYEES_TABLE e WHERE e.ID = employee_id;
        RETURN employee_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetEmployeeRefById;

END EmployeePackage;
/


CREATE OR REPLACE PACKAGE ShelterPackage AS
    PROCEDURE ShowShelterInfo(p_shelter_id INT);
    PROCEDURE AddShelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- New parameter for feed stock
    );
END ShelterPackage;
/


--### TRIGGERS ###





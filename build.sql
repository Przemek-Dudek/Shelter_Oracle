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

CREATE SEQUENCE Adoption_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Adoption_type AS OBJECT (
    ID INT,
    dog_ID INT,
    client_ID INT,
    employee_ID INT,
    status VARCHAR(20),

    MEMBER FUNCTION is_valid RETURN BOOLEAN,
    STATIC FUNCTION create_adoption(
        p_dog_ID INT, p_client_ID INT, p_employee_ID INT, p_status VARCHAR
    ) RETURN Adoption_type
);
/

CREATE OR REPLACE TYPE BODY Adoption_type AS
    MEMBER FUNCTION is_valid RETURN BOOLEAN IS
    BEGIN
        IF dog_ID IS NULL OR client_ID IS NULL OR employee_ID IS NULL THEN
            RETURN FALSE;
        END IF;

        IF status NOT IN ('Rozpoczęta', 'Procesowanie', 'Zakończona') THEN
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
            Adoption_sequence.NEXTVAL, p_dog_ID, p_client_ID, p_employee_ID, p_status
        );

        IF NOT v_adoption.is_valid THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid adoption data');
        END IF;

        RETURN v_adoption;
    END;
END;
/

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

--SHELTER

--### CREATE TABLES ###



CREATE TABLE Adoption_Table OF ADOPTION_TYPE (PRIMARY KEY (ID));

CREATE TABLE Employees_Table  OF EMPLOYEE_TYPE (PRIMARY KEY (ID));

CREATE TABLE Client_Table OF CLIENT_TYPE (PRIMARY KEY (ID));

CREATE TABLE Dog_Table OF DOG_TYPE (PRIMARY KEY (ID));

CREATE TABLE Shelter_Table OF Shelter_type (PRIMARY KEY (ID)); --nie działa







--### TRIGGERS ###



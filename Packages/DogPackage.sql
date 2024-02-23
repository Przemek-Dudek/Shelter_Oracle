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

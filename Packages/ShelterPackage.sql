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

CREATE OR REPLACE PACKAGE BODY ShelterPackage AS
    PROCEDURE ShowShelterInfo(p_shelter_id INT) IS
        v_shelter Shelter_type;
    BEGIN
        SELECT VALUE(s) INTO v_shelter
        FROM Shelter_Table s
        WHERE s.ID = p_shelter_id;

        DBMS_OUTPUT.PUT_LINE('Shelter ID: ' || v_shelter.ID);
        DBMS_OUTPUT.PUT_LINE('Opening Hour: ' || v_shelter.opening_hour);
        DBMS_OUTPUT.PUT_LINE('Closing Hour: ' || v_shelter.closing_hour);
        -- Output other shelter attributes as needed
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Shelter with ID ' || p_shelter_id || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END ShowShelterInfo;

    PROCEDURE AddShelter(
        p_opening_hour VARCHAR2,
        p_closing_hour VARCHAR2,
        p_street VARCHAR2,
        p_city VARCHAR2,
        p_number INT,
        p_feed_stock INT -- New parameter for feed stock
    ) IS
        v_new_shelter Shelter_type;
    BEGIN
        v_new_shelter := Shelter_type.create_shelter(
            p_opening_hour,
            p_closing_hour,
            p_street,
            p_city,
            p_number,
            p_feed_stock -- Pass the feed stock parameter
        );

        -- Insert the new shelter into the table
        INSERT INTO Shelter_Table (ID, opening_hour, closing_hour, address, feed_stock)
        VALUES (Shelter_sequence.NEXTVAL, v_new_shelter.opening_hour, v_new_shelter.closing_hour, v_new_shelter.address, v_new_shelter.feed_stock);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Shelter added successfully with ID: ' || Shelter_sequence.CURRVAL);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END AddShelter;
END ShelterPackage;
/

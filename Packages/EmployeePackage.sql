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

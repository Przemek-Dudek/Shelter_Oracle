CREATE SEQUENCE Employee_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Employee_type AS OBJECT (
    ID INT,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Salary FLOAT,
    Date_of_hire DATE,

    MEMBER FUNCTION get_name RETURN VARCHAR2,
    MEMBER FUNCTION get_surname RETURN VARCHAR2,
    MEMBER FUNCTION get_salary RETURN FLOAT,
    MEMBER FUNCTION get_date_of_hire RETURN DATE,

    STATIC FUNCTION create_employee(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Salary FLOAT,
        p_Date_of_hire DATE
    ) RETURN Employee_type
);
/

CREATE OR REPLACE TYPE BODY Employee_type AS
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.Name;
    END get_name;

    MEMBER FUNCTION get_surname RETURN VARCHAR2 IS
    BEGIN
        RETURN self.Surname;
    END get_surname;

    MEMBER FUNCTION get_salary RETURN FLOAT IS
    BEGIN
        RETURN self.Salary;
    END get_salary;

    MEMBER FUNCTION get_date_of_hire RETURN DATE IS
    BEGIN
        RETURN self.Date_of_hire;
    END get_date_of_hire;

    STATIC FUNCTION create_employee(
        p_Name VARCHAR2,
        p_Surname VARCHAR2,
        p_Salary FLOAT,
        p_Date_of_hire DATE
    ) RETURN Employee_type IS
        new_employee Employee_type;
    BEGIN
        new_employee := Employee_type(
            Employee_sequence.NEXTVAL,
            p_Name,
            p_Surname,
            p_Salary,
            p_Date_of_hire
        );
        RETURN new_employee;
    END create_employee;
END;
/

--### TYPES ###


-- Client, Dog, Employee

CREATE SEQUENCE Client_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Client_type AS OBJECT (
    ID INT,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Phone VARCHAR(15)
);


CREATE SEQUENCE Dog_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Dog_type AS OBJECT (
    ID INT,
    name VARCHAR(100),
    race VARCHAR(100),
    age INT,
    weight FLOAT,
    status VARCHAR(20)
);


CREATE SEQUENCE Employee_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Employee_type AS OBJECT (
    ID INT,
    name VARCHAR(100),
    surname VARCHAR(100),
    salary FLOAT,
    date_of_hire DATE
);

-- Adoption

--### CREATE TABLES ###



CREATE TABLE Adoption_Table OF ADOPTION_TYPE (PRIMARY KEY (ID));

CREATE TABLE Employees_Table  OF EMPLOYEE_TYPE (PRIMARY KEY (ID));

CREATE TABLE Client_Table OF CLIENT_TYPE (PRIMARY KEY (ID));

CREATE TABLE Dog_Table OF DOG_TYPE (PRIMARY KEY (ID));



--### TRIGGERS ###



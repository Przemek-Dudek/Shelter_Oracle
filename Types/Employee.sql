CREATE SEQUENCE Employee_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Employee_type AS OBJECT (
    ID INT,
    name VARCHAR(100),
    surname VARCHAR(100),
    salary FLOAT,
    date_of_hire DATE
);
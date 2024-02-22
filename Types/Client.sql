CREATE SEQUENCE Client_sequence START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TYPE Client_type AS OBJECT (
    ID INT,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Phone VARCHAR(15)
);
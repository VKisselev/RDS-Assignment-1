--
--  Enabling ECHO and TAB
--
SET ECHO ON
SET TAB OFF
--
-- SPOOL Location, may need to be adjusted depending on host
--
SPOOL C:\Users\Vladimir\Documents\GitHub\RDS\RDS-Assignment-1\Assignment01_Spool_KisselevV_AuE.txt
------------------------------------------------------------
--  COMP 2714 
--  SET 2A
--  Assignment 1 
--  
--  Kisselev, Vladimir    A00798129
--  email: vvladimir@my.bcit.ca
--  
--  Au, Eva     A00970757
--  email: pau7@my.bcit.ca
------------------------------------------------------------
--  Setting/Checking date
ALTER SESSION SET NLS_DATE_FORMAT ='YYYY-MM-DD';
SELECT SYSDATE
FROM DUAL;
--
--  Q.1
--  Clearing current database
--
DROP TABLE OldBooking;
DROP TABLE Room;
DROP TABLE Booking;
DROP TABLE Hotel;
DROP TABLE Guest;
--
--  Q.2
--  Creating tables Hotel, Room
--
CREATE TABLE Hotel
(HotelNo    CHAR(8)         NOT NULL
,HotelName  VARCHAR2(50)    NOT NULL
,City       VARCHAR2(50)    NOT NULL
,CONSTRAINT PKHotel PRIMARY KEY (HotelNo)
);
--
CREATE TABLE Room
(RoomNo     CHAR(5)         NOT NULL
            CHECK(RoomNo    BETWEEN 1 AND 100)
,HotelNo    CHAR(8)         NOT NULL
,RoomType   VARCHAR2(6)     NOT NULL
,RoomPrice  DECIMAL(5,2)    NOT NULL
,CONSTRAINT PKRoom          PRIMARY KEY (RoomNo, HotelNo)
,CONSTRAINT FKHotelNo       FOREIGN KEY (HotelNo)
                            REFERENCES Hotel (HotelNo)
,CONSTRAINT chk_type        CHECK(RoomType IN('Single', 'Double', 'Family'))
,CONSTRAINT chk_roomNo      CHECK(RoomNo BETWEEN 1 AND 100)
,CONSTRAINT chk_roomPrice   CHECK(RoomPrice BETWEEN 100.00 AND 1000.00)
);
--
--  Q.3
--  Creating tables Guest & Booking
CREATE TABLE Guest
(GuestNo        CHAR(5)         NOT NULL
,GuestName      VARCHAR2(50)    NOT NULL
,GuestAddress   VARCHAR2(50)    NOT NULL
,CONSTRAINT PKGuest PRIMARY KEY (GuestNo)
);
--
CREATE TABLE Booking
(HotelNo    CHAR(8)         NOT NULL
,GuestNo    CHAR(5)         NOT NULL
,DateFrom   DATE
,DateTo     DATE
,RoomNo     CHAR(5)         NOT NULL
,CONSTRAINT PKBooking   PRIMARY KEY (HotelNo, GuestNo, DateFrom)
,CONSTRAINT FKHotelNoBook   FOREIGN KEY (HotelNo) REFERENCES Hotel (HotelNo)
,CONSTRAINT FKGuestNo   FOREIGN KEY (GuestNo) REFERENCES Guest (GuestNo)
);
--
--  Checking for proper table parameters in SQL
--
DESCRIBE Hotel;
DESCRIBE Room;
DESCRIBE Guest;
DESCRIBE Booking;
--
--  Q.4
--  Inserting Hotel Values
--
INSERT INTO Hotel
    VALUES('1234632', 'BCIT TERRIBLE HOTEL', 'Vancouver');
INSERT INTO Hotel
    VALUES('1234633', 'BCIT MORE TERRIBLE', 'Toronto');
INSERT INTO Hotel
    VALUES('1234634', 'EVAS AWESOME HOTEL', 'Hong Kong');
--
--  Inserting Room Values
--
INSERT INTO Room
    VALUES('10', '1234632', 'Family', 990.05);
INSERT INTO Room
    VALUES('20', '1234633', 'Single', 880.05);
INSERT INTO Room
    VALUES('30', '1234634', 'Double', 770.05);
--
--  Inserting Guest Values
--
INSERT INTO Guest
    VALUES('01', 'Eva Au', '3563 Metrotown');
INSERT INTO Guest
    VALUES('02', 'Vladimir Kisselev', '3969 Heather St, Vancouver');
INSERT INTO Guest
    VALUES('03', 'John H', 'Some street, Burnaby');
--
--  Inserting Booking Values
--
INSERT INTO Booking
    VALUES('1234632', '01', DATE'2018-01-01', DATE'2018-01-10', '10');
INSERT INTO Booking
    VALUES('1234633', '02', DATE'2018-02-02', DATE'2018-02-12', '20');
INSERT INTO Booking
    VALUES('1234634', '03', DATE'2018-03-03', DATE'2018-03-13', '30');
COMMIT;
--
--  Q.5a
--  Dropping the old Constraint
--
ALTER TABLE Room
Drop CONSTRAINT chk_type;
--
--  Add the new Constraint
--
ALTER TABLE Room
    ADD CONSTRAINT newchk_type CHECK(RoomType IN('Single','Double','Family','Deluxe'));
--
--  Q.5b
--  Addding new discount column to Room table
--
ALTER TABLE Room
    ADD Discount DECIMAL(4,2)  DEFAULT 0.00 NOT NULL;
--
--  Addding Constraint to the discount column
--
ALTER TABLE Room
    ADD CONSTRAINT chk_discount CHECK(Discount BETWEEN 0.00 AND 30.00);
--
--  Checking correct addition of Discount Column
--
INSERT INTO Room
    VALUES('11', '1234632', 'Deluxe', 990.05, 25.00);
--
--  Q.6a
--  Altering Double in Room to increase the price
--
UPDATE Room
SET RoomPrice = RoomPrice * 1.15
WHERE HotelNo = '1234634' AND RoomType = 'Double';
--
--  Q.6b
--  Updating Booking dates for a single guest
--
UPDATE Booking
SET DateFrom = DATE'2017-11-30'
,DateTo = DATE'2018-01-14'
WHERE GuestNo = '01' AND HotelNo = '1234632' AND RoomNo = '10';
--
--  Q.7a
--  Creating table for Old Bookings
--
CREATE TABLE OldBooking
(HotelNo    CHAR(8)         NOT NULL
,GuestNo    CHAR(5)         NOT NULL
,DateFrom   DATE
,DateTo     DATE
,RoomNo     CHAR(5)         NOT NULL
,CONSTRAINT PKOldBooking    PRIMARY KEY(HotelNo, GuestNo, DateFrom)
);
--
--  Q.7b
--  Taking values from Booking to move to Old Bookings
--
INSERT INTO OldBooking
SELECT *
FROM Booking
WHERE DateTo < DATE'2018-01-15';
--
--  Q.7c
--  Deleting old Bookings from Booking
--
DELETE FROM Booking
WHERE DateTo < DATE'2018-01-15';
COMMIT;
--
--  Formatting Hotel Output
--  Formatting Room Output 
--  Formatting Guest Output
--
SET LINESIZE 100
SET PAGESIZE 60
COLUMN  HotelNo         FORMAT  A10
COLUMN  HotelName       FORMAT  A25
COLUMN  City            FORMAT  A15
COLUMN  RoomNo          FORMAT  A10
COLUMN  HotelNo         FORMAT  A10
COLUMN  RoomPrice       FORMAT  9999.99
COLUMN  GuestNo         FORMAT  A10
COLUMN  GuestName       FORMAT  A20
COLUMN  GuestAddress    FORMAT  A30
--
--  Displaying all current table data
--
SELECT *
FROM Hotel;
--
SELECT *
FROM Room;
--
SELECT *
FROM Guest;
--
SELECT *
FROM Booking;
--
SELECT *
FROM OldBooking;
--
SELECT *
FROM Booking;
--
--  Disabling SPOOL to prevent data loss
--
SPOOL OFF
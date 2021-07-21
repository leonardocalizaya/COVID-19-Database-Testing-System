-- CS4400: Introduction to Database Systems
-- Fall 2020
-- Phase II Create Table and Insert Statements Template

-- Team 114
-- Ethan Svitak (esvitak3)
-- Kira O’Hare (kohare6)
-- Leonardo Callzaya (lquispe3)
-- Mary Jiang (mjiang48)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission


-- CREATE TABLE STATEMENTS BELOW


DROP DATABASE IF EXISTS phase2;
CREATE DATABASE IF NOT EXISTS phase2;
USE phase2;

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
username VARCHAR(20) UNIQUE,
apassword VARCHAR(255) NOT NULL,
email VARCHAR(25),
first_name VARCHAR(15) NOT NULL,
last_name VARCHAR(15) NOT NULL,

PRIMARY KEY (username),
CONSTRAINT password_length CHECK (CHAR_LENGTH(apassword) >= 8),
CONSTRAINT email_length CHECK(CHAR_LENGTH(email) >= 5),
CONSTRAINT email_format CHECK(email like '%@%')
);

DROP TABLE IF EXISTS location;
CREATE TABLE location
(
aname VARCHAR(20), 

PRIMARY KEY (aname)
);

DROP TABLE IF EXISTS student;
CREATE TABLE student
(
username VARCHAR(20),
housing_type VARCHAR(20),
location VARCHAR(20),

PRIMARY KEY (username),
CONSTRAINT student_fk1 FOREIGN KEY (username) REFERENCES users(username),
CONSTRAINT student_fk2 FOREIGN KEY (location) REFERENCES location(aname)
);

DROP TABLE IF EXISTS admins;
CREATE TABLE admins
(
admin_username VARCHAR(20),

PRIMARY KEY (admin_username),
FOREIGN KEY (admin_username) REFERENCES users(username) 
);

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(
employee_username VARCHAR(20),
phone_number VARCHAR(10),

PRIMARY KEY (employee_username),
FOREIGN KEY (employee_username) REFERENCES users(username),
CONSTRAINT phone_length CHECK(CHAR_LENGTH(phone_number) = 10)
);

DROP TABLE IF EXISTS site_tester;
CREATE TABLE site_tester
(
tester_username VARCHAR(20),
PRIMARY KEY (tester_username),
FOREIGN KEY (tester_username) REFERENCES employee(employee_username) 
);

DROP TABLE IF EXISTS lab_technician;
CREATE TABLE lab_technician
(
technician_username VARCHAR(20),
PRIMARY KEY (technician_username),
FOREIGN KEY (technician_username) REFERENCES employee(employee_username) 
);

DROP TABLE IF EXISTS site;
CREATE TABLE site (
aname varchar(40) NOT NULL UNIQUE, -- changed
street varchar(80) NOT NULL,
city varchar(40) NOT NULL,
state varchar(2) NOT NULL,
zip decimal(5, 0) NOT NULL,
location_name varchar(20) NOT NULL,
PRIMARY KEY (aname),
CONSTRAINT site_fk1 FOREIGN KEY (location_name) REFERENCES location (aname),
CONSTRAINT zip_length CHECK (CHAR_LENGTH(zip) = 5)
);

DROP TABLE IF EXISTS appointment;
CREATE TABLE appointment (
student_username varchar(20), -- changed
app_date date NOT NULL,
app_time time NOT NULL, 
site_name varchar(40) NOT NULL,

PRIMARY KEY (site_name,app_date,app_time),
UNIQUE (site_name, app_date, app_time),
CONSTRAINT appointment_fk1 FOREIGN KEY (site_name) REFERENCES site(aname),
CONSTRAINT appointment_fk2 FOREIGN KEY (student_username) REFERENCES student (username)
);

DROP TABLE IF EXISTS works_in;
CREATE TABLE works_in
(
tester_username VARCHAR(20),
site_name VARCHAR(40),
PRIMARY KEY (tester_username, site_name),
FOREIGN KEY (tester_username) REFERENCES site_tester(tester_username),
FOREIGN KEY (site_name) REFERENCES site(aname)
);

DROP TABLE IF EXISTS pool;
CREATE TABLE pool
(
poolid VARCHAR(15),
labtechnicianid	VARCHAR(15),
astatus VARCHAR(15),
adate VARCHAR(15),

PRIMARY KEY (poolid),
CONSTRAINT pool_fk1 FOREIGN KEY (labtechnicianid) REFERENCES lab_technician(technician_username)
);

DROP TABLE IF EXISTS test;
CREATE TABLE test
(
testid VARCHAR(15) NOT NULL,
poolid VARCHAR(15) NOT NULL,
astatus VARCHAR(15),
site_name VARCHAR(40) NOT NULL,
appointment_date DATE NOT NULL,
appointment_time TIME NOT NULL,

PRIMARY KEY (testid),
FOREIGN KEY (site_name, appointment_date, appointment_time) REFERENCES appointment(site_name, app_date, app_time),
FOREIGN KEY (poolid) REFERENCES pool(poolid)
);


-- INSERT STATEMENTS BELOW


INSERT INTO location VALUES ('East'), ('West');

INSERT INTO site VALUES ('Fulton County Board of Health', '10 Park Place South SE', 'Atlanta', 'GA', 30303, 'East'),('CCBOH WIC Clinic', '1895 Phoenix Blvd', 'College Park', 'GA', 30339, 'West'),('Kennesaw State University', '3305 Busbee Drive NW', 'Kennesaw', 'GA', 30144, 'West'),('Stamps Health Services', '740 Ferst Drive', 'Atlanta', 'GA', 30332, 'West'),('Bobby Dodd Stadium', '150 Bobby Dodd Way NW', 'Atlanta', 'GA', 30332, 'East'),('Caddell Building', '280 Ferst Drive NW', 'Atlanta', 'GA', 30332, 'West'),('Coda Building', '760 Spring Street', 'Atlanta', 'GA', 30332, 'East'),('GT Catholic Center', '172 4th St NW', 'Atlanta', 'GA', 30313, 'East'),('West Village', '532 8th St NW', 'Atlanta', 'GA', 30318, 'West'),('GT Connector', '116 Bobby Dodd Way NW', 'Atlanta', 'GA', 30313, 'East'),('Curran St Parking Deck', '564 8th St NW', 'Atlanta', 'GA', 30318, 'West'),('North Avenue (Centenial Room)', '120 North Avenue NW', 'Atlanta', 'GA', 30313, 'East');

INSERT INTO users VALUES
('jlionel666','password1','jlionel666@gatech.edu','John','Lionel'),
('mmoss7','password2','mmoss7@gatech.edu','Mark','Moss'),
('lchen27','password3','lchen27@gatech.edu','Liang','Chen'),
('jhilborn97','password4','jhilborn97@gatech.edu','Jack','Hilborn'),
('jhilborn98','password5','jhilborn98@gatech.edu','Jake','Hilborn'),
('ygao10','password6','ygao10@gatech.edu','Yuan','Gao'),
('jthomas520','password7','jthomas520@gatech.edu','James','Thomas'),
('cforte58','password8','cforte58@gatech.edu','Connor','Forte'),
('fdavenport49','password9','fdavenport49@gatech.edu','Felicia','Devenport'),
('hliu88','password10','hliu88@gatech.edu','Hang','Liu'),
('akarev16','password11','akarev16@gatech.edu','Alex','Karev'),
('jdoe381','password12','jdoe381@gatech.edu','Jane ','Doe'),
('sstrange11','password13','sstrange11@gatech.edu','Stephen','Strange'),
('dmcstuffins7','password14','dmcstuffins7@gatech.edu','Doc','Mcstuffins'),
('mgrey91','password15','mgrey91@gatech.edu','Meredith','Grey'),
('pwallace51','password16','pwallace51@gatech.edu','Penny','Wallace'),
('jrosario34','password17','jrosario34@gatech.edu','Jon','Rosario'),
('nshea230','password18','nshea230@gatech.edu','Nicholas','Shea'),
('mgeller3','password19','mgeller3@gatech.edu','Monica ','Geller'),
('rgeller9','password20','rgeller9@gatech.edu','Ross','Geller '),
('jtribbiani27','password21','jtribbiani27@gatech.edu','Joey ','Tribbiani'),
('pbuffay56','password22','pbuffay56@gatech.edu','Phoebe ','Buffay'),
('rgreen97','password23','rgreen97@gatech.edu','Rachel','Green'),
('cbing101','password24','cbing101@gatech.edu','Chandler ','Bing'),
('pbeesly61','password25','pbeesly61@gatech.edu','Pamela','Beesly'),
('jhalpert75','password26','jhalpert75@gatech.edu','Jim ','Halpert'),
('dschrute18','password27','dschrute18@gatech.edu','Dwight ','Schrute'),
('amartin365','password28','amartin365@gatech.edu','Angela ','Martin'),
('omartinez13','password29','omartinez13@gatech.edu','Oscar','Martinez'),
('mscott845','password30','mscott845@gatech.edu','Michael ','Scott'),
('abernard224','password31','abernard224@gatech.edu','Andy ','Bernard'),
('kkapoor155','password32','kkapoor155@gatech.edu','Kelly ','Kapoor'),
('dphilbin81','password33','dphilbin81@gatech.edu','Darryl ','Philbin'),
('sthefirst1','password34','sthefirst1@gatech.edu','Sofia','Thefirst'),
('gburdell1','password35','gburdell1@gatech.edu','George','Burdell'),
('dsmith102','password36','dsmith102@gatech.edu','Dani','Smith'),
('dbrown85','password37','dbrown85@gatech.edu','David','Brown'),
('dkim99','password38','dkim99@gatech.edu','Dave','Kim'),
('tlee984','password39','tlee984@gatech.edu','Tom','Lee'),
('jpark29','password40','jpark29@gatech.edu','Jerry','Park'),
('vneal101','password41','vneal101@gatech.edu','Vinay','Neal'),
('hpeterson55','password42','hpeterson55@gatech.edu','Haydn','Peterson'),
('lpiper20','password43','lpiper20@gatech.edu','Leroy','Piper'),
('mbob2','password44','mbob2@gatech.edu','Mary','Bob'),
('mrees785','password45','mrees785@gatech.edu','Marie','Rees'),
('wbryant23','password46','wbryant23@gatech.edu','William','Bryant'),
('aallman302','password47','aallman302@gatech.edu','Aiysha','Allman'),
('kweston85','password48','kweston85@gatech.edu','Kyle','Weston');


INSERT INTO student VALUES ('mgeller3', 'Off-campus Apartment','East');
INSERT INTO student VALUES ('rgeller9', 'Student Housing','East');
INSERT INTO student VALUES ('jtribbiani27', 'Greek Housing','West');
INSERT INTO student VALUES ('pbuffay56', 'Student Housing','East');
INSERT INTO student VALUES ('rgreen97', 'Student Housing','West');
INSERT INTO student VALUES ('cbing101', 'Greek Housing','East');
INSERT INTO student VALUES ('pbeesly61', 'Student Housing','West');
INSERT INTO student VALUES ('jhalpert75', 'Student Housing','East');
INSERT INTO student VALUES ('dschrute18', 'Student Housing','East');
INSERT INTO student VALUES ('amartin365', 'Greek Housing','East');
INSERT INTO student VALUES ('omartinez13', 'Student Housing','West');
INSERT INTO student VALUES ('mscott845', 'Student Housing','East');
INSERT INTO student VALUES ('abernard224', 'Greek Housing','West');
INSERT INTO student VALUES ('kkapoor155', 'Greek Housing','East');
INSERT INTO student VALUES ('dphilbin81', 'Greek Housing','West');
INSERT INTO student VALUES ('sthefirst1', 'Student Housing','West');
INSERT INTO student VALUES ('gburdell1', 'Student Housing','East');
INSERT INTO student VALUES ('dsmith102', 'Greek Housing','West');
INSERT INTO student VALUES ('dbrown85', 'Off-campus Apartment','East');
INSERT INTO student VALUES ('dkim99', 'Greek Housing','East');
INSERT INTO student VALUES ('tlee984', 'Student Housing','West');
INSERT INTO student VALUES ('jpark29', 'Student Housing','East');
INSERT INTO student VALUES ('vneal101', 'Student Housing','West');
INSERT INTO student VALUES ('hpeterson55', 'Greek Housing','East');
INSERT INTO student VALUES ('lpiper20', 'Student Housing','West');
INSERT INTO student VALUES ('mbob2', 'Student Housing','West');
INSERT INTO student VALUES ('mrees785', 'Off-campus House','West');
INSERT INTO student VALUES ('wbryant23', 'Greek Housing','East');
INSERT INTO student VALUES ('aallman302', 'Student Housing','West');
INSERT INTO student VALUES ('kweston85', 'Greek Housing','West');

INSERT INTO admins VALUES ('jlionel666'),('mmoss7'),('lchen27');

INSERT INTO employee VALUES
('jhilborn97', '4043802577'),
('jhilborn98', '4042201897'),
('ygao10', '7703928765'),
('jthomas520', '7705678943'),
('cforte58', '4708623384'),
('fdavenport49', '7068201473'),
('hliu88', '4782809765'),
('akarev16', '9876543210'),
('jdoe381', '1237864230'),
('sstrange11', '6547891234'),
('dmcstuffins7', '1236549878'),
('mgrey91', '6458769523'),
('pwallace51', '3788612907'),
('jrosario34', '5926384247'),
('nshea230', '6979064501');

INSERT INTO lab_technician VALUES
('jhilborn97'),
('jhilborn98'),
('ygao10'),
('jthomas520'),
('cforte58'),
('fdavenport49'),
('hliu88');

INSERT INTO site_tester VALUES
('akarev16'),
('jdoe381'),
('sstrange11'),
('dmcstuffins7'),
('mgrey91'),
('pwallace51'),
('jrosario34'),
('nshea230');

INSERT INTO appointment VALUES
('mgeller3','2020-09-01','08:00:00','Fulton County Board of Health'),
('rgeller9','2020-09-01','09:00:00','Bobby Dodd Stadium'),
('jtribbiani27','2020-09-01','10:00:00','Caddell Building'),
('pbuffay56','2020-09-01','11:00:00','GT Catholic Center'),
('rgreen97','2020-09-01','12:00:00','West Village'),
('cbing101','2020-09-01','13:00:00','GT Catholic Center'),
('pbeesly61','2020-09-01','14:00:00','West Village'),
('jhalpert75','2020-09-01','15:00:00','North Avenue (Centenial Room)'),
('dschrute18','2020-09-01','16:00:00','North Avenue (Centenial Room)'),
('omartinez13','2020-09-03','08:00:00','Curran St Parking Deck'),
('mscott845','2020-09-03','09:00:00','Bobby Dodd Stadium'),
('abernard224','2020-09-03','10:00:00','Stamps Health Services'),
('kkapoor155','2020-09-03','11:00:00','GT Catholic Center'),
('dphilbin81','2020-09-03','12:00:00','West Village'),
('sthefirst1','2020-09-03','13:00:00','Caddell Building'),
('gburdell1','2020-09-03','14:00:00','Coda Building'),
('dsmith102','2020-09-03','15:00:00','Stamps Health Services'),
('dbrown85','2020-09-03','16:00:00','CCBOH WIC Clinic'),
('dkim99','2020-09-03','17:00:00','GT Connector'),
('tlee984','2020-09-04','08:00:00','Curran St Parking Deck'),
('jpark29','2020-09-04','09:00:00','GT Connector'),
('vneal101','2020-09-04','10:00:00','Curran St Parking Deck'),
('hpeterson55','2020-09-04','11:00:00','Bobby Dodd Stadium'),
('lpiper20','2020-09-04','12:00:00','Caddell Building'),
('mbob2','2020-09-04','13:00:00','Stamps Health Services'),
('mrees785','2020-09-04','14:00:00','Kennesaw State University'),
('wbryant23','2020-09-04','15:00:00','GT Catholic Center'),
('aallman302','2020-09-04','16:00:00','West Village'),
('kweston85','2020-09-04','17:00:00','West Village'),
('mgeller3','2020-09-04','08:00:00','Fulton County Board of Health'),
('rgeller9','2020-09-04','09:00:00','Bobby Dodd Stadium'),
('jtribbiani27','2020-09-04','10:00:00','Caddell Building'),
('pbuffay56','2020-09-10','11:00:00','Bobby Dodd Stadium'),
('rgreen97','2020-09-10','12:00:00','Caddell Building'),
('cbing101','2020-09-10','13:00:00','GT Catholic Center'),
('pbeesly61','2020-09-10','14:00:00','West Village'),
('jhalpert75','2020-09-10','15:00:00','Coda Building'),
('dschrute18','2020-09-10','16:00:00','Coda Building'),
('amartin365','2020-09-10','17:00:00','Coda Building'),
('omartinez13','2020-09-10','08:00:00','Stamps Health Services'),
('mscott845','2020-09-10','09:00:00','Bobby Dodd Stadium'),
('abernard224','2020-09-10','10:00:00','West Village'),
('kkapoor155','2020-09-10','11:00:00','GT Connector'),
('dphilbin81','2020-09-10','12:00:00','Curran St Parking Deck'),
('sthefirst1','2020-09-10','13:00:00','Curran St Parking Deck'),
('gburdell1','2020-09-10','14:00:00','North Avenue (Centenial Room)'),
('dsmith102','2020-09-10','15:00:00','Caddell Building'),
('dbrown85','2020-09-10','16:00:00','CCBOH WIC Clinic'),
('dkim99','2020-09-10','17:00:00','Bobby Dodd Stadium'),
('tlee984','2020-09-10','08:00:00','West Village'),
('jpark29','2020-09-10','09:00:00','GT Catholic Center'),
('vneal101','2020-09-13','10:00:00','Curran St Parking Deck'),
('hpeterson55','2020-09-13','11:00:00','Coda Building'),
('lpiper20','2020-09-13','12:00:00','Stamps Health Services'),
('mbob2','2020-09-13','13:00:00','Curran St Parking Deck'),
('mrees785','2020-09-13','14:00:00','CCBOH WIC Clinic'),
('wbryant23','2020-09-16','15:00:00','North Avenue (Centenial Room)'),
('aallman302','2020-09-16','16:00:00','West Village'),
('kweston85','2020-09-16','17:00:00','Caddell Building'),
(NULL,'2020-09-16','08:00:00','Fulton County Board of Health'),
(NULL,'2020-09-16','09:00:00','CCBOH WIC Clinic'),
(NULL,'2020-09-16','10:00:00','Kennesaw State University'),
(NULL,'2020-09-16','11:00:00','Stamps Health Services'),
(NULL,'2020-09-16','12:00:00','Bobby Dodd Stadium'),
(NULL,'2020-09-16','13:00:00','Caddell Building'),
(NULL,'2020-09-16','14:00:00','Coda Building'),
(NULL,'2020-09-16','15:00:00','GT Catholic Center'),
(NULL,'2020-10-01','17:00:00','GT Connector'),
(NULL,'2020-10-01','08:00:00','Curran St Parking Deck'),
(NULL,'2020-10-01','09:00:00','North Avenue (Centenial Room)'),
(NULL,'2020-10-01','17:00:00','Fulton County Board of Health'),
(NULL,'2020-10-01','08:00:00','CCBOH WIC Clinic'),
(NULL,'2020-10-01','09:00:00','Kennesaw State University'),
(NULL,'2020-10-01','10:00:00','Stamps Health Services'),
(NULL,'2020-10-01','11:00:00','Bobby Dodd Stadium'),
(NULL,'2020-10-02','12:00:00','Caddell Building'),
(NULL,'2020-10-02','13:00:00','Coda Building'),
(NULL,'2020-10-02','14:00:00','GT Catholic Center'),
(NULL,'2020-10-02','15:00:00','West Village'),
(NULL,'2020-10-02','16:00:00','GT Connector'),
(NULL,'2020-10-02','17:00:00','Curran St Parking Deck'),
(NULL,'2020-10-06','08:00:00','North Avenue (Centenial Room)'),
(NULL,'2020-10-06','09:00:00','Fulton County Board of Health'),
(NULL,'2020-10-06','10:00:00','CCBOH WIC Clinic'),
(NULL,'2020-10-06','11:00:00','Kennesaw State University'),
(NULL,'2020-10-06','12:00:00','Stamps Health Services'),
(NULL,'2020-10-07','13:00:00','Bobby Dodd Stadium'),
(NULL,'2020-10-07','14:00:00','Caddell Building'),
(NULL,'2020-10-07','15:00:00','Coda Building'),
(NULL,'2020-10-07','16:00:00','GT Catholic Center'),
(NULL,'2020-10-07','17:00:00','West Village'),
(NULL,'2020-10-07','08:00:00','GT Connector'),
(NULL,'2020-10-07','09:00:00','Curran St Parking Deck'),
(NULL,'2020-10-07','10:00:00','North Avenue (Centenial Room)');

INSERT INTO works_in VALUES
('akarev16','Fulton County Board of Health'),
('akarev16','CCBOH WIC Clinic'),
('akarev16','Kennesaw State University'),
('akarev16','Stamps Health Services'),
('jdoe381','Curran St Parking Deck'),
('jdoe381','North Avenue (Centenial Room)'),
('jdoe381','Fulton County Board of Health'),
('jdoe381','CCBOH WIC Clinic'),
('sstrange11','Coda Building'),
('sstrange11','GT Catholic Center'),
('sstrange11','West Village'),
('sstrange11','GT Connector'),
('sstrange11','Curran St Parking Deck'),
('sstrange11','North Avenue (Centenial Room)'),
('dmcstuffins7','Bobby Dodd Stadium'),
('dmcstuffins7','Caddell Building'),
('dmcstuffins7','Coda Building'),
('dmcstuffins7','GT Catholic Center'),
('dmcstuffins7','West Village'),
('dmcstuffins7','GT Connector'),
('mgrey91','Kennesaw State University'),
('mgrey91','Stamps Health Services'),
('mgrey91','Bobby Dodd Stadium'),
('mgrey91','Caddell Building'),
('pwallace51','Coda Building');

INSERT INTO pool VALUES
(1,'jhilborn97','negative','2020-09-02'),
(2,'jhilborn98','positive','2020-09-04'),
(3,'ygao10','positive','2020-09-06'),
(4,'jthomas520','positive','2020-09-05'),
(5,'fdavenport49','negative','2020-09-07'),
(6,'hliu88','positive','2020-09-05'),
(7,'cforte58','negative','2020-09-11'),
(8,'ygao10','positive','2020-09-11'),
(9,NULL,'pending',NULL),
(10,NULL,'pending',NULL),
(11,NULL,'pending',NULL),
(12,NULL,'pending',NULL),
(13,NULL,'pending',NULL);
  
INSERT INTO test VALUES
(100002,1,'negative','Bobby Dodd Stadium','2020-09-01','09:00:00'),
(100003,1,'negative','Caddell Building','2020-09-01','10:00:00'),
(100004,1,'negative','GT Catholic Center','2020-09-01','11:00:00'),
(100005,1,'negative','West Village','2020-09-01','12:00:00'),
(100006,1,'negative','GT Catholic Center','2020-09-01','13:00:00'),
(100007,1,'negative','West Village','2020-09-01','14:00:00'),
(100008,2,'negative','North Avenue (Centenial Room)','2020-09-01','15:00:00'),
(100009,2,'positive','North Avenue (Centenial Room)','2020-09-01','16:00:00'),
(100011,2,'negative','Curran St Parking Deck','2020-09-03','08:00:00'),
(100012,2,'positive','Bobby Dodd Stadium','2020-09-03','09:00:00'),
(100013,2,'positive','Stamps Health Services','2020-09-03','10:00:00'),
(100014,2,'negative','GT Catholic Center','2020-09-03','11:00:00'),
(100015,3,'negative','West Village','2020-09-03','12:00:00'),
(100016,3,'positive','Caddell Building','2020-09-03','13:00:00'),
(100017,3,'negative','Coda Building','2020-09-03','14:00:00'),
(100018,3,'negative','Stamps Health Services','2020-09-03','15:00:00'),
(100019,3,'positive','CCBOH WIC Clinic','2020-09-03','16:00:00'),
(100020,4,'negative','GT Connector','2020-09-03','17:00:00'),
(100021,4,'negative','Curran St Parking Deck','2020-09-04','08:00:00'),
(100022,4,'negative','GT Connector','2020-09-04','09:00:00'),
(100023,4,'negative','Curran St Parking Deck','2020-09-04','10:00:00'),
(100024,4,'positive','Bobby Dodd Stadium','2020-09-04','11:00:00'),
(100025,5,'negative','Caddell Building','2020-09-04','12:00:00'),
(100026,5,'negative','Stamps Health Services','2020-09-04','13:00:00'),
(100027,5,'negative','Kennesaw State University','2020-09-04','14:00:00'),
(100028,5,'negative','GT Catholic Center','2020-09-04','15:00:00'),
(100029,5,'negative','West Village','2020-09-04','16:00:00'),
(100030,5,'negative','West Village','2020-09-04','17:00:00'),
(100031,6,'positive','Fulton County Board of Health','2020-09-04','08:00:00'),
(100032,6,'positive','Bobby Dodd Stadium','2020-09-04','09:00:00'),
(100033,7,'negative','Caddell Building','2020-09-04','10:00:00'),
(100034,7,'negative','Bobby Dodd Stadium','2020-09-10','11:00:00'),
(100035,7,'negative','Caddell Building','2020-09-10','12:00:00'),
(100036,7,'negative','GT Catholic Center','2020-09-10','13:00:00'),
(100037,7,'negative','West Village','2020-09-10','14:00:00'),
(100038,7,'negative','Coda Building','2020-09-10','15:00:00'),
(100039,8,'negative','Coda Building','2020-09-10','16:00:00'),
(100040,8,'positive','Coda Building','2020-09-10','17:00:00'),
(100041,8,'negative','Stamps Health Services','2020-09-10','08:00:00'),
(100042,9,'pending','Bobby Dodd Stadium','2020-09-10','09:00:00'),
(100043,9,'pending','West Village','2020-09-10','10:00:00'),
(100044,9,'pending','GT Connector','2020-09-10','11:00:00'),
(100045,9,'pending','Curran St Parking Deck','2020-09-10','12:00:00'),
(100046,9,'pending','Curran St Parking Deck','2020-09-10','13:00:00'),
(100047,9,'pending','North Avenue (Centenial Room)','2020-09-10','14:00:00'),
(100048,9,'pending','Caddell Building','2020-09-10','15:00:00'),
(100049,10,'pending','CCBOH WIC Clinic','2020-09-10','16:00:00'),
(100050,11,'pending','Bobby Dodd Stadium','2020-09-10','17:00:00'),
(100051,11,'pending','West Village','2020-09-10','08:00:00'),
(100052,11,'pending','GT Catholic Center','2020-09-10','09:00:00'),
(100053,11,'pending','Curran St Parking Deck','2020-09-13','10:00:00'),
(100054,11,'pending','Coda Building','2020-09-13','11:00:00'),
(100055,12,'pending','Stamps Health Services','2020-09-13','12:00:00'),
(100056,12,'pending','Curran St Parking Deck','2020-09-13','13:00:00'),
(100057,12,'pending','CCBOH WIC Clinic','2020-09-13','14:00:00'),
(100058,12,'pending','North Avenue (Centenial Room)','2020-09-16','15:00:00'),
(100059,13,'pending','West Village','2020-09-16','16:00:00'),
(100060,13,'pending','Caddell Building','2020-09-16','17:00:00');

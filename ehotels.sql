/*
Names: Karina Glavan & Mia Martel 
Course: CSI2132
Group Number: Group 4
*/ 

-- Using Drop Database so that its easy to continusly test and edit at different times
DROP DATABASE IF EXISTS ehotels; 

CREATE DATABASE ehotels; 
USE ehotels;  

/* ##################################################
********** PART A: DATABASE IMPLEMENTATION **********
*/ ##################################################

-- Creating the hotel chain table 
CREATE TABLE Hotel_Chain (
	ChainName VARCHAR(100) PRIMARY KEY,
    ContactEmail VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(50) UNIQUE NOT NULL,
    CentralOfficeAdd VARCHAR(200) NOT NULL, 
    NumOfHotels INT CHECK (NumOfHotels > 0) NOT NULL -- Constraint Added ensures each hotel chain has at least one hotel 
);

-- Creating the hotel table 
CREATE TABLE Hotel(
	HotelID INT UNSIGNED PRIMARY KEY, 
    ContactEmail VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(50) UNIQUE NOT NULL,
    ChainName VARCHAR(100) NOT NULL,
    FOREIGN KEY (ChainName) REFERENCES Hotel_Chain(ChainName), 
    StarRating INT CHECK (StarRating >= 1 AND StarRating <= 5) NOT NULL,
    NumOfRooms INT CHECK (NumOfRooms > 0 AND NumOfRooms <= 3000) NOT NULL, 
    Address VARCHAR(200) NOT NULL, 
    HotelName VARCHAR(200) NOT NULL -- Added to make it easier to import to website 
); 

-- Creating the room table 
CREATE TABLE Room(
	RoomID INT UNSIGNED PRIMARY KEY,
    HotelID INT UNSIGNED, 
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
	CanExtend BOOLEAN NOT NULL, 
    RoomView VARCHAR(10) CHECK (RoomView = 'Mountain' OR RoomView = 'Sea' OR RoomView = 'None'), -- Changed Name of attribute from View to RoomView
    CapacityOfRoom INT CHECK (CapacityOfRoom >= 1 AND CapacityOfRoom <= 8),
    Price INT CHECK (Price > 0 AND Price <= 500), 
    Availability BOOLEAN NOT NULL
); 

-- Creating a Problems_with_Room table since its considered as a multivalued attribute 
CREATE TABLE Problems_with_Room(
	RoomID INT UNSIGNED,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID), 
    Problem VARCHAR(150) NOT NULL,
    PRIMARY KEY (RoomID, Problem) 
); 

-- Creating an Amenity table since its considered as a multivalued attribute 
CREATE TABLE Amenities(
	RoomID INT UNSIGNED,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    Amenity VARCHAR(200) NOT NULL,
    PRIMARY KEY (RoomID, Amenity)
);

-- Creating the Customer table 
CREATE TABLE Customer(
	IDNumber INT UNSIGNED PRIMARY KEY,
    TypeOfID VARCHAR(100) NOT NULL, 
    FullName VARCHAR(200) NOT NULL, -- Some people have long names 
    Address VARCHAR(200) NOT NULL, 
    DateOfRegistration DATE 
);

-- Creating the Employee Table 
CREATE TABLE Employee(
	SSN_SIN INT UNSIGNED PRIMARY KEY, 
    HotelID INT UNSIGNED, 
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    FullName VARCHAR(200) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    PositionName VARCHAR(100) NOT NULL
); 

-- Creating the Booking Table 
CREATE TABLE Booking(
	BookingID INT UNSIGNED PRIMARY KEY,
    CustomerID INT UNSIGNED, -- Changed Name 
    FOREIGN KEY (CustomerID) REFERENCES Customer(IDNumber), 
    RoomID INT UNSIGNED,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    StatusofBooking VARCHAR(20) CHECK (StatusofBooking = 'Confirmed' OR StatusofBooking = 'Pending' OR StatusofBooking = 'Cancelled') NOT NULL, -- Changed Name 
    BookingDate DATE, 
    CheckInDate DATE, 
    CheckOutDate DATE
); 

-- Creating the Renting Table 
CREATE TABLE Renting(
	RentingID INT UNSIGNED PRIMARY KEY, 
    BookingID INT UNSIGNED, 
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID), 
	CustomerID INT UNSIGNED, -- Changed Name 
    FOREIGN KEY (CustomerID) REFERENCES Customer(IDNumber), 
    HotelID INT UNSIGNED, 
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    RoomID INT UNSIGNED,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus = 'Paid' OR PaymentStatus = 'Not Paid' OR PaymentStatus = 'Partially Paid') NOT NULL, 
    CheckInTime TIME, 
    CheckOutTime TIME
); 

-- Adding a BookingArchive Table since was missed in the ER Diagram and Schema 
-- So that if information about the room or customer doesnt exist the information 
-- Exists somewhere in the database. But no Foreign Keys since the info will just be copied 
CREATE TABLE BookingArchive(
	BookingID INT UNSIGNED PRIMARY KEY,
    CustomerID INT UNSIGNED, -- Changed Name 
    RoomID INT UNSIGNED,
    StatusofBooking VARCHAR(20) CHECK (StatusofBooking = 'Confirmed' OR StatusofBooking = 'Pending' OR StatusofBooking = 'Cancelled') NOT NULL, -- Changed Name 
    BookingDate DATE, 
    CheckInDate DATE, 
    CheckOutDate DATE
); 

-- Adding a RentingArchive Table for the same reason as BookingArchive 
CREATE TABLE RentingArchive(
	RentingID INT UNSIGNED PRIMARY KEY, 
    BookingID INT UNSIGNED, 
	CustomerID INT UNSIGNED, -- Changed Name 
    HotelID INT UNSIGNED, 
    RoomID INT UNSIGNED,
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus = 'Paid' OR PaymentStatus = 'Not Paid' OR PaymentStatus = 'Partially Paid') NOT NULL, 
    CheckInTime TIME, 
    CheckOutTime TIME
); 

/* ##################################################
********** PART B: Database Population **********
*/ ##################################################

-- ************************
-- INSERTING HOTEL CHAINS 
-- ************************
-- Doing the insert for the First Hotel Chain (Marriott International) 
INSERT INTO Hotel_Chain (ChainName, ContactEmail, PhoneNumber, CentralOfficeAdd, NumOfHotels) 
VALUES ('Marriott International', 'marriott_int_hotels@marriottint.com', '718-223-4589', '799 First Avenue, New York City, United States', 15) ; 

-- Doing the insert for the Second Hotel Chain (Hilton Worldwide) 
INSERT INTO Hotel_Chain (ChainName, ContactEmail, PhoneNumber, CentralOfficeAdd, NumOfHotels) 
VALUES ('Hilton Worldwide', 'hilton_worldwide_hotels@hiltonworldwide.com', '512-389-5464', '99 Oaks Cir, Austin, United States', 15) ; 

-- Doing the insert for the Third Hotel Chain (Hyatt Hotels) 
INSERT INTO Hotel_Chain (ChainName, ContactEmail, PhoneNumber, CentralOfficeAdd, NumOfHotels) 
VALUES ('Hyatt Hotels Corporation', 'hyatt_hotels@hyatthotels.com', '818-879-4521', '21 Ventura Boulevard, San Fernando Valley, United States', 15) ; 

-- Doing the insert for the Fourth Hotel Chain (IHG Hotels & Resorts) 
INSERT INTO Hotel_Chain (ChainName, ContactEmail, PhoneNumber, CentralOfficeAdd, NumOfHotels) 
VALUES ('IHG Hotels & Resorts', 'ihg_hotels_resorts@ihg.com', '718-544-1233', '123 Third Avenue, New York City, United States', 15) ; 

-- Doing the insert for the Fifth Hotel Chain (Wyndham Hotels & Resorts) 
INSERT INTO Hotel_Chain (ChainName, ContactEmail, PhoneNumber, CentralOfficeAdd, NumOfHotels) 
VALUES ('Wyndham Hotels & Resorts', 'wyndham_hotels_resorts@wyndham.com', '718-655-7237', '456 Second Avenue, New York City, United States', 15) ; 

-- ************************
-- INSERTING HOTELS
-- ************************ 
-- INSERTING HOTELS FROM MARIOTT INTERNATIONAL CHAIN 
INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (123456789, 'marriott_marquis@marriottint.com', '718-888-9999', 'Marriott International', 4, 1966, '1535 Broadway, New York City, United States', 'Marriott Marquis') ; 

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (111111111, 'marriott_jw@marriottint.com', '310-777-4788', 'Marriott International', 5, 878, '900 W Olympic Blvd, Los Angeles, United States', 'JW Marriott L.A. LIVE') ; 

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (222222222, 'marriott_courtyardchicago@marriottint.com', '312-787-5788', 'Marriott International', 3, 337, '30 E Hubbard St, Chicago, United States', 'Courtyard Chicago Downtown') ; 

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (4, 'marriott_residenceinntoronto@marriottint.com', '416-555-1001', 'Marriott International', 3, 256, '255 Wellington St W, Toronto, Canada', 'Residence Inn Toronto Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (5, 'marriott_deltavancouver@marriottint.com', '604-555-1002', 'Marriott International', 4, 226, '550 W Hastings St, Vancouver, Canada', 'Delta Hotels Vancouver Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (6, 'marriott_acmiami@marriottint.com', '305-555-1003', 'Marriott International', 4, 150, '2912 Collins Ave, Miami, United States', 'AC Hotel Miami Beach');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (7, 'marriott_fairfielddallas@marriottint.com', '214-555-1004', 'Marriott International', 3, 116, '2110 Market Center Blvd, Dallas, United States', 'Fairfield Dallas Market Center');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (8, 'marriott_springhillatlanta@marriottint.com', '404-555-1005', 'Marriott International', 3, 170, '239 Ivan Allen Jr Blvd, Atlanta, United States', 'SpringHill Suites Atlanta Midtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (9, 'marriott_jwlasvegas@marriottint.com', '702-555-1006', 'Marriott International', 5, 548, '221 N Rampart Blvd, Las Vegas, United States', 'JW Marriott Las Vegas');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (10, 'marriott_courtyardseattle@marriottint.com', '206-555-1007', 'Marriott International', 3, 262, '612 2nd Ave, Seattle, United States', 'Courtyard Seattle Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (11, 'marriott_moxyboston@marriottint.com', '617-555-1008', 'Marriott International', 4, 340, '240 Tremont St, Boston, United States', 'Moxy Boston Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (12, 'marriott_unionsf@marriottint.com', '415-555-1009', 'Marriott International', 4, 401, '480 Sutter St, San Francisco, United States', 'Marriott Union Square');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (13, 'marriott_towneplacedenver@marriottint.com', '303-555-1010', 'Marriott International', 3, 122, '685 Speer Blvd, Denver, United States', 'TownePlace Suites Denver Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (14, 'marriott_lemeridienmontreal@marriottint.com', '514-555-1011', 'Marriott International', 4, 210, '901 Rue du Square-Victoria, Montreal, Canada', 'Le Meridien Montreal');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (15, 'marriott_orlandoworldcenter@marriottint.com', '407-555-1012', 'Marriott International', 5, 2008, '8701 World Center Dr, Orlando, United States', 'Orlando World Center Marriott');

-- INSERTING HOTELS FOR HILTON WORLDWIDE 
INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (16, 'hilton_timesquare@hilton.com', '212-555-2001', 'Hilton Worldwide', 3, 369, '790 8th Ave, New York City, United States', 'Hilton Garden Inn Times Square');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (17, 'hilton_lax@hilton.com', '310-555-2002', 'Hilton Worldwide', 3, 149, '10300 S La Cienega Blvd, Los Angeles, United States', 'Hampton Inn LAX');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (18, 'hilton_waldorfchicago@hilton.com', '312-555-2003', 'Hilton Worldwide', 5, 215, '11 E Walton St, Chicago, United States', 'Waldorf Astoria Chicago');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (19, 'hilton_toronto@hilton.com', '416-555-2004', 'Hilton Worldwide', 4, 490, '108 Chestnut St, Toronto, Canada', 'DoubleTree Toronto Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (20, 'hilton_vancouver@hilton.com', '604-555-2005', 'Hilton Worldwide', 3, 132, '8811 Bridgeport Rd, Vancouver, Canada', 'Hampton Inn Vancouver Airport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (21, 'hilton_conradmiami@hilton.com', '305-555-2006', 'Hilton Worldwide', 5, 203, '1395 Brickell Ave, Miami, United States', 'Conrad Miami');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (22, 'hilton_dallas@hilton.com', '214-555-2007', 'Hilton Worldwide', 3, 130, '1025 Elm St, Dallas, United States', 'Homewood Suites Dallas');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (23, 'hilton_atlanta@hilton.com', '404-555-2008', 'Hilton Worldwide', 2, 120, '1162 W Peachtree St, Atlanta, United States', 'Tru by Hilton Atlanta Midtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (24, 'hilton_lasvegas@hilton.com', '702-555-2009', 'Hilton Worldwide', 4, 1239, '2650 Las Vegas Blvd, Las Vegas, United States', 'Hilton Grand Vacations');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (25, 'hilton_seattle@hilton.com', '206-555-2010', 'Hilton Worldwide', 4, 282, '255 S King St, Seattle, United States', 'Embassy Suites Seattle Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (26, 'hilton_boston@hilton.com', '617-555-2011', 'Hilton Worldwide', 3, 252, '670 Summer St, Boston, United States', 'Hampton Inn Boston Seaport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (27, 'hilton_sanfrancisco@hilton.com', '415-555-2012', 'Hilton Worldwide', 4, 1024, '55 Cyril Magnin St, San Francisco, United States', 'Parc 55 (Hilton)');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (28, 'hilton_denver@hilton.com', '303-555-2013', 'Hilton Worldwide', 3, 221, '1400 Welton St, Denver, United States', 'Hilton Garden Inn Denver Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (29, 'hilton_montreal@hilton.com', '514-555-2014', 'Hilton Worldwide', 4, 595, '1255 Jeanne-Mance St, Montreal, Canada', 'DoubleTree Montreal');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (30, 'hilton_orlando@hilton.com', '407-555-2015', 'Hilton Worldwide', 5, 502, '14200 Bonnet Creek Resort Ln, Orlando, United States', 'Waldorf Astoria Orlando');


-- INSERTING HOTELS FOR HYATT HOTELS CORPORATION 
INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (31, 'hyatt_parkny@hyatt.com', '212-555-3001', 'Hyatt Hotels Corporation', 5, 210, '153 W 57th St, New York City, United States', 'Park Hyatt New York');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (32, 'hyatt_placelax@hyatt.com', '310-555-3002', 'Hyatt Hotels Corporation', 3, 272, '5959 W Century Blvd, Los Angeles, United States', 'Hyatt Place LAX');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (33, 'hyatt_centricchicago@hyatt.com', '312-555-3003', 'Hyatt Hotels Corporation', 4, 257, '633 N St Clair St, Chicago, United States', 'Hyatt Centric Chicago');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (34, 'hyatt_regencytoronto@hyatt.com', '416-555-3004', 'Hyatt Hotels Corporation', 4, 394, '370 King St W, Toronto, Canada', 'Hyatt Regency Toronto');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (35, 'hyatt_housevancouver@hyatt.com', '604-555-3005', 'Hyatt Hotels Corporation', 3, 127, '111 Robson St, Vancouver, Canada', 'Hyatt House Vancouver');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (36, 'hyatt_centricmiami@hyatt.com', '305-555-3006', 'Hyatt Hotels Corporation', 4, 105, '1600 Collins Ave, Miami, United States', 'Hyatt Centric South Beach');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (37, 'hyatt_housedallas@hyatt.com', '214-555-3007', 'Hyatt Hotels Corporation', 3, 141, '2914 Harry Hines Blvd, Dallas, United States', 'Hyatt House Dallas Uptown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (38, 'hyatt_placeatlanta@hyatt.com', '404-555-3008', 'Hyatt Hotels Corporation', 3, 95, '330 Peachtree St, Atlanta, United States', 'Hyatt Place Atlanta Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (39, 'hyatt_placelv@hyatt.com', '702-555-3009', 'Hyatt Hotels Corporation', 3, 202, '4520 Paradise Rd, Las Vegas, United States', 'Hyatt Place Las Vegas');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (40, 'hyatt_thompsonseattle@hyatt.com', '206-555-3010', 'Hyatt Hotels Corporation', 5, 158, '110 Stewart St, Seattle, United States', 'Thompson Seattle');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (41, 'hyatt_placeboston@hyatt.com', '617-555-3011', 'Hyatt Hotels Corporation', 3, 297, '295 Northern Ave, Boston, United States', 'Hyatt Place Boston Seaport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (42, 'hyatt_regencysf@hyatt.com', '415-555-3012', 'Hyatt Hotels Corporation', 4, 804, '5 Embarcadero Center, San Francisco, United States', 'Hyatt Regency SF');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (43, 'hyatt_housedenver@hyatt.com', '303-555-3013', 'Hyatt Hotels Corporation', 3, 113, '440 14th St, Denver, United States', 'Hyatt House Denver Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (44, 'hyatt_placemontreal@hyatt.com', '514-555-3014', 'Hyatt Hotels Corporation', 3, 354, '1415 Rue Saint-Hubert, Montreal, Canada', 'Hyatt Place Montreal Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (45, 'hyatt_regencyorlando@hyatt.com', '407-555-3015', 'Hyatt Hotels Corporation', 4, 1641, '9801 International Dr, Orlando, United States', 'Hyatt Regency Orlando');


-- INSERTING HOTELS FOR IHG HOTELS & RESORTS 
INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (46, 'ihg_candlewoodnyc@ihg.com', '212-555-4001', 'IHG Hotels & Resorts', 2, 188, '339 W 39th St, New York City, United States', 'Candlewood Suites NYC');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (47, 'ihg_hiexpresslax@ihg.com', '310-555-4002', 'IHG Hotels & Resorts', 3, 160, '8620 Airport Blvd, Los Angeles, United States', 'Holiday Inn Express LAX');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (48, 'ihg_intercontinentalchicago@ihg.com', '312-555-4003', 'IHG Hotels & Resorts', 5, 792, '505 N Michigan Ave, Chicago, United States', 'InterContinental Chicago');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (49, 'ihg_hiexpresstoronto@ihg.com', '416-555-4004', 'IHG Hotels & Resorts', 3, 195, '111 Lombard St, Toronto, Canada', 'Holiday Inn Express Toronto Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (50, 'ihg_holidayinnvancouver@ihg.com', '604-555-4005', 'IHG Hotels & Resorts', 3, 245, '1110 Howe St, Vancouver, Canada', 'Holiday Inn & Suites Vancouver');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (51, 'ihg_kimptonepic@ihg.com', '305-555-4006', 'IHG Hotels & Resorts', 5, 411, '270 Biscayne Blvd Way, Miami, United States', 'Kimpton EPIC Hotel');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (52, 'ihg_staybridgedallas@ihg.com', '214-555-4007', 'IHG Hotels & Resorts', 3, 97, '7880 Alpha Rd, Dallas, United States', 'Staybridge Suites Dallas');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (53, 'ihg_holidayinnatlanta@ihg.com', '404-555-4008', 'IHG Hotels & Resorts', 3, 150, '1810 Howell Mill Rd, Atlanta, United States', 'Holiday Inn Atlanta Midtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (54, 'ihg_holidayinclublv@ihg.com', '702-555-4009', 'IHG Hotels & Resorts', 4, 658, '3950 Koval Ln, Las Vegas, United States', 'Holiday Inn Club Vacations');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (55, 'ihg_evenseattle@ihg.com', '206-555-4010', 'IHG Hotels & Resorts', 4, 222, '527 Fairview Ave N, Seattle, United States', 'EVEN Hotel Seattle');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (56, 'ihg_holidayinnboston@ihg.com', '617-555-4011', 'IHG Hotels & Resorts', 3, 226, '1200 Beacon St, Boston, United States', 'Holiday Inn Boston Brookline');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (57, 'ihg_indigosf@ihg.com', '415-555-4012', 'IHG Hotels & Resorts', 4, 350, '180 3rd St, San Francisco, United States', 'Hotel Indigo SF');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (58, 'ihg_staybridgedenver@ihg.com', '303-555-4013', 'IHG Hotels & Resorts', 3, 111, '333 W Colfax Ave, Denver, United States', 'Staybridge Suites Denver Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (59, 'ihg_holidayinnmontreal@ihg.com', '514-555-4014', 'IHG Hotels & Resorts', 3, 235, '999 Rue St-Urbain, Montreal, Canada', 'Holiday Inn Montreal Centre');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (60, 'ihg_holidayinnorlando@ihg.com', '407-555-4015', 'IHG Hotels & Resorts', 4, 777, '14500 Continental Gateway, Orlando, United States', 'Holiday Inn Resort Orlando');
 
-- INSERTING HOTELS FOR WYNDHAM HOTELS & RESORTS 
INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (61, 'wyndham_chinatownny@wyndham.com', '212-555-5001', 'Wyndham Hotels & Resorts', 3, 106, '93 Bowery, New York City, United States', 'Wyndham Garden Chinatown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (62, 'wyndham_super8lax@wyndham.com', '310-555-5002', 'Wyndham Hotels & Resorts', 2, 122, '9250 Airport Blvd, Los Angeles, United States', 'Super 8 LAX');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (63, 'wyndham_travelodgechicago@wyndham.com', '312-555-5003', 'Wyndham Hotels & Resorts', 2, 233, '65 E Harrison St, Chicago, United States', 'Travelodge Chicago Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (64, 'wyndham_daysinntoronto@wyndham.com', '416-555-5004', 'Wyndham Hotels & Resorts', 2, 148, '1684 Ellesmere Rd, Toronto, Canada', 'Days Inn Toronto East');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (65, 'wyndham_daysinnvancouver@wyndham.com', '604-555-5005', 'Wyndham Hotels & Resorts', 2, 67, '2840 Sexsmith Rd, Vancouver, Canada', 'Days Inn Vancouver Airport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (66, 'wyndham_laquintamiami@wyndham.com', '305-555-5006', 'Wyndham Hotels & Resorts', 3, 152, '7401 NW 36th St, Miami, United States', 'La Quinta Miami Airport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (67, 'wyndham_laquintadallas@wyndham.com', '214-555-5007', 'Wyndham Hotels & Resorts', 3, 127, '302 S Houston St, Dallas, United States', 'La Quinta Dallas Downtown');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (68, 'wyndham_super8atlanta@wyndham.com', '404-555-5008', 'Wyndham Hotels & Resorts', 2, 99, '4979 Old National Hwy, Atlanta, United States', 'Super 8 Atlanta Airport');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (69, 'wyndham_granddesert@wyndham.com', '702-555-5009', 'Wyndham Hotels & Resorts', 4, 787, '265 E Harmon Ave, Las Vegas, United States', 'Wyndham Grand Desert');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (70, 'wyndham_daysinnseattle@wyndham.com', '206-555-5010', 'Wyndham Hotels & Resorts', 2, 100, '2006 5th Ave, Seattle, United States', 'Days Inn Seattle');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (71, 'wyndham_laquintaboston@wyndham.com', '617-555-5011', 'Wyndham Hotels & Resorts', 3, 147, '23 Cummings St, Boston, United States', 'La Quinta Boston Somerville');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (72, 'wyndham_travelodgesf@wyndham.com', '415-555-5012', 'Wyndham Hotels & Resorts', 2, 120, '1707 Market St, San Francisco, United States', 'Travelodge SF Central');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (73, 'wyndham_super8denver@wyndham.com', '303-555-5013', 'Wyndham Hotels & Resorts', 2, 106, '5888 N Broadway, Denver, United States', 'Super 8 Denver Central');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (74, 'wyndham_travelodgemontreal@wyndham.com', '514-555-5014', 'Wyndham Hotels & Resorts', 2, 244, '50 René-Lévesque Blvd, Montreal, Canada', 'Travelodge Montreal Centre');

INSERT INTO Hotel (HotelID, ContactEmail, PhoneNumber, ChainName, StarRating, NumOfRooms, Address, HotelName)
VALUES (75, 'wyndham_lakebuenavista@wyndham.com', '407-555-5015', 'Wyndham Hotels & Resorts', 4, 232, '1850 Hotel Plaza Blvd, Orlando, United States', 'Wyndham Lake Buena Vista');

-- ************************
-- INSERTING ROOMS
-- ************************

-- MARRIOT HOTELS 
INSERT INTO Room (RoomID, HotelID, CanExtend, RoomView, CapacityOfRoom, Price, Availability)
VALUES
-- Hotel 1 (123456789)
(1, 123456789, TRUE, 'None', 1, 90, TRUE),
(2, 123456789, TRUE, 'Mountain', 2, 150, TRUE),
(3, 123456789, TRUE, 'None', 4, 250, TRUE),
(4, 123456789, FALSE, 'Sea', 5, 350, TRUE),
(5, 123456789, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 2 (111111111)
(6, 111111111, TRUE, 'None', 1, 90, TRUE),
(7, 111111111, TRUE, 'Mountain', 2, 150, TRUE),
(8, 111111111, TRUE, 'None', 4, 250, TRUE),
(9, 111111111, FALSE, 'Sea', 5, 350, TRUE),
(10, 111111111, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 3 (222222222)
(11, 222222222, TRUE, 'None', 1, 90, TRUE),
(12, 222222222, TRUE, 'Mountain', 2, 150, TRUE),
(13, 222222222, TRUE, 'None', 4, 250, TRUE),
(14, 222222222, FALSE, 'Sea', 5, 350, TRUE),
(15, 222222222, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 4
(16, 4, TRUE, 'None', 1, 90, TRUE),
(17, 4, TRUE, 'Mountain', 2, 150, TRUE),
(18, 4, TRUE, 'None', 4, 250, TRUE),
(19, 4, FALSE, 'Sea', 5, 350, TRUE),
(20, 4, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 5
(21, 5, TRUE, 'None', 1, 90, TRUE),
(22, 5, TRUE, 'Mountain', 2, 150, TRUE),
(23, 5, TRUE, 'None', 4, 250, TRUE),
(24, 5, FALSE, 'Sea', 5, 350, TRUE),
(25, 5, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 6
(26, 6, TRUE, 'None', 1, 90, TRUE),
(27, 6, TRUE, 'Mountain', 2, 150, TRUE),
(28, 6, TRUE, 'None', 4, 250, TRUE),
(29, 6, FALSE, 'Sea', 5, 350, TRUE),
(30, 6, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 7
(31, 7, TRUE, 'None', 1, 90, TRUE),
(32, 7, TRUE, 'Mountain', 2, 150, TRUE),
(33, 7, TRUE, 'None', 4, 250, TRUE),
(34, 7, FALSE, 'Sea', 5, 350, TRUE),
(35, 7, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 8
(36, 8, TRUE, 'None', 1, 90, TRUE),
(37, 8, TRUE, 'Mountain', 2, 150, TRUE),
(38, 8, TRUE, 'None', 4, 250, TRUE),
(39, 8, FALSE, 'Sea', 5, 350, TRUE),
(40, 8, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 9
(41, 9, TRUE, 'None', 1, 90, TRUE),
(42, 9, TRUE, 'Mountain', 2, 150, TRUE),
(43, 9, TRUE, 'None', 4, 250, TRUE),
(44, 9, FALSE, 'Sea', 5, 350, TRUE),
(45, 9, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 10
(46, 10, TRUE, 'None', 1, 90, TRUE),
(47, 10, TRUE, 'Mountain', 2, 150, TRUE),
(48, 10, TRUE, 'None', 4, 250, TRUE),
(49, 10, FALSE, 'Sea', 5, 350, TRUE),
(50, 10, FALSE, 'Sea', 6, 480, TRUE)
;

-- ROOMS FOR HILTON HOTELS
INSERT INTO Room (RoomID, HotelID, CanExtend, RoomView, CapacityOfRoom, Price, Availability)
VALUES
-- Hotel 16
(76, 16, TRUE, 'None', 1, 90, TRUE),
(77, 16, TRUE, 'Mountain', 2, 150, TRUE),
(78, 16, TRUE, 'None', 4, 250, TRUE),
(79, 16, FALSE, 'Sea', 5, 350, TRUE),
(80, 16, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 17
(81, 17, TRUE, 'None', 1, 90, TRUE),
(82, 17, TRUE, 'Mountain', 2, 150, TRUE),
(83, 17, TRUE, 'None', 4, 250, TRUE),
(84, 17, FALSE, 'Sea', 5, 350, TRUE),
(85, 17, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 18
(86, 18, TRUE, 'None', 1, 90, TRUE),
(87, 18, TRUE, 'Mountain', 2, 150, TRUE),
(88, 18, TRUE, 'None', 4, 250, TRUE),
(89, 18, FALSE, 'Sea', 5, 350, TRUE),
(90, 18, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 19
(91, 19, TRUE, 'None', 1, 90, TRUE),
(92, 19, TRUE, 'Mountain', 2, 150, TRUE),
(93, 19, TRUE, 'None', 4, 250, TRUE),
(94, 19, FALSE, 'Sea', 5, 350, TRUE),
(95, 19, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 20
(96, 20, TRUE, 'None', 1, 90, TRUE),
(97, 20, TRUE, 'Mountain', 2, 150, TRUE),
(98, 20, TRUE, 'None', 4, 250, TRUE),
(99, 20, FALSE, 'Sea', 5, 350, TRUE),
(100, 20, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 21
(101, 21, TRUE, 'None', 1, 90, TRUE),
(102, 21, TRUE, 'Mountain', 2, 150, TRUE),
(103, 21, TRUE, 'None', 4, 250, TRUE),
(104, 21, FALSE, 'Sea', 5, 350, TRUE),
(105, 21, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 22
(106, 22, TRUE, 'None', 1, 90, TRUE),
(107, 22, TRUE, 'Mountain', 2, 150, TRUE),
(108, 22, TRUE, 'None', 4, 250, TRUE),
(109, 22, FALSE, 'Sea', 5, 350, TRUE),
(110, 22, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 23
(111, 23, TRUE, 'None', 1, 90, TRUE),
(112, 23, TRUE, 'Mountain', 2, 150, TRUE),
(113, 23, TRUE, 'None', 4, 250, TRUE),
(114, 23, FALSE, 'Sea', 5, 350, TRUE),
(115, 23, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 24
(116, 24, TRUE, 'None', 1, 90, TRUE),
(117, 24, TRUE, 'Mountain', 2, 150, TRUE),
(118, 24, TRUE, 'None', 4, 250, TRUE),
(119, 24, FALSE, 'Sea', 5, 350, TRUE),
(120, 24, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 25
(121, 25, TRUE, 'None', 1, 90, TRUE),
(122, 25, TRUE, 'Mountain', 2, 150, TRUE),
(123, 25, TRUE, 'None', 4, 250, TRUE),
(124, 25, FALSE, 'Sea', 5, 350, TRUE),
(125, 25, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 26
(126, 26, TRUE, 'None', 1, 90, TRUE),
(127, 26, TRUE, 'Mountain', 2, 150, TRUE),
(128, 26, TRUE, 'None', 4, 250, TRUE),
(129, 26, FALSE, 'Sea', 5, 350, TRUE),
(130, 26, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 27
(131, 27, TRUE, 'None', 1, 90, TRUE),
(132, 27, TRUE, 'Mountain', 2, 150, TRUE),
(133, 27, TRUE, 'None', 4, 250, TRUE),
(134, 27, FALSE, 'Sea', 5, 350, TRUE),
(135, 27, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 28
(136, 28, TRUE, 'None', 1, 90, TRUE),
(137, 28, TRUE, 'Mountain', 2, 150, TRUE),
(138, 28, TRUE, 'None', 4, 250, TRUE),
(139, 28, FALSE, 'Sea', 5, 350, TRUE),
(140, 28, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 29
(141, 29, TRUE, 'None', 1, 90, TRUE),
(142, 29, TRUE, 'Mountain', 2, 150, TRUE),
(143, 29, TRUE, 'None', 4, 250, TRUE),
(144, 29, FALSE, 'Sea', 5, 350, TRUE),
(145, 29, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 30
(146, 30, TRUE, 'None', 1, 90, TRUE),
(147, 30, TRUE, 'Mountain', 2, 150, TRUE),
(148, 30, TRUE, 'None', 4, 250, TRUE),
(149, 30, FALSE, 'Sea', 5, 350, TRUE),
(150, 30, FALSE, 'Sea', 6, 480, TRUE);


-- ROOMS FOR HYATT HOTELS 
INSERT INTO Room (RoomID, HotelID, CanExtend, RoomView, CapacityOfRoom, Price, Availability)
VALUES
-- Hotel 31
(151, 31, TRUE, 'None', 1, 90, TRUE),
(152, 31, TRUE, 'Mountain', 2, 150, TRUE),
(153, 31, TRUE, 'None', 4, 250, TRUE),
(154, 31, FALSE, 'Sea', 5, 350, TRUE),
(155, 31, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 32
(156, 32, TRUE, 'None', 1, 90, TRUE),
(157, 32, TRUE, 'Mountain', 2, 150, TRUE),
(158, 32, TRUE, 'None', 4, 250, TRUE),
(159, 32, FALSE, 'Sea', 5, 350, TRUE),
(160, 32, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 33
(161, 33, TRUE, 'None', 1, 90, TRUE),
(162, 33, TRUE, 'Mountain', 2, 150, TRUE),
(163, 33, TRUE, 'None', 4, 250, TRUE),
(164, 33, FALSE, 'Sea', 5, 350, TRUE),
(165, 33, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 34
(166, 34, TRUE, 'None', 1, 90, TRUE),
(167, 34, TRUE, 'Mountain', 2, 150, TRUE),
(168, 34, TRUE, 'None', 4, 250, TRUE),
(169, 34, FALSE, 'Sea', 5, 350, TRUE),
(170, 34, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 35
(171, 35, TRUE, 'None', 1, 90, TRUE),
(172, 35, TRUE, 'Mountain', 2, 150, TRUE),
(173, 35, TRUE, 'None', 4, 250, TRUE),
(174, 35, FALSE, 'Sea', 5, 350, TRUE),
(175, 35, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 36
(176, 36, TRUE, 'None', 1, 90, TRUE),
(177, 36, TRUE, 'Mountain', 2, 150, TRUE),
(178, 36, TRUE, 'None', 4, 250, TRUE),
(179, 36, FALSE, 'Sea', 5, 350, TRUE),
(180, 36, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 37
(181, 37, TRUE, 'None', 1, 90, TRUE),
(182, 37, TRUE, 'Mountain', 2, 150, TRUE),
(183, 37, TRUE, 'None', 4, 250, TRUE),
(184, 37, FALSE, 'Sea', 5, 350, TRUE),
(185, 37, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 38
(186, 38, TRUE, 'None', 1, 90, TRUE),
(187, 38, TRUE, 'Mountain', 2, 150, TRUE),
(188, 38, TRUE, 'None', 4, 250, TRUE),
(189, 38, FALSE, 'Sea', 5, 350, TRUE),
(190, 38, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 39
(191, 39, TRUE, 'None', 1, 90, TRUE),
(192, 39, TRUE, 'Mountain', 2, 150, TRUE),
(193, 39, TRUE, 'None', 4, 250, TRUE),
(194, 39, FALSE, 'Sea', 5, 350, TRUE),
(195, 39, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 40
(196, 40, TRUE, 'None', 1, 90, TRUE),
(197, 40, TRUE, 'Mountain', 2, 150, TRUE),
(198, 40, TRUE, 'None', 4, 250, TRUE),
(199, 40, FALSE, 'Sea', 5, 350, TRUE),
(200, 40, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 41
(201, 41, TRUE, 'None', 1, 90, TRUE),
(202, 41, TRUE, 'Mountain', 2, 150, TRUE),
(203, 41, TRUE, 'None', 4, 250, TRUE),
(204, 41, FALSE, 'Sea', 5, 350, TRUE),
(205, 41, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 42
(206, 42, TRUE, 'None', 1, 90, TRUE),
(207, 42, TRUE, 'Mountain', 2, 150, TRUE),
(208, 42, TRUE, 'None', 4, 250, TRUE),
(209, 42, FALSE, 'Sea', 5, 350, TRUE),
(210, 42, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 43
(211, 43, TRUE, 'None', 1, 90, TRUE),
(212, 43, TRUE, 'Mountain', 2, 150, TRUE),
(213, 43, TRUE, 'None', 4, 250, TRUE),
(214, 43, FALSE, 'Sea', 5, 350, TRUE),
(215, 43, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 44
(216, 44, TRUE, 'None', 1, 90, TRUE),
(217, 44, TRUE, 'Mountain', 2, 150, TRUE),
(218, 44, TRUE, 'None', 4, 250, TRUE),
(219, 44, FALSE, 'Sea', 5, 350, TRUE),
(220, 44, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 45
(221, 45, TRUE, 'None', 1, 90, TRUE),
(222, 45, TRUE, 'Mountain', 2, 150, TRUE),
(223, 45, TRUE, 'None', 4, 250, TRUE),
(224, 45, FALSE, 'Sea', 5, 350, TRUE),
(225, 45, FALSE, 'Sea', 6, 480, TRUE);

-- ROOMS FOR IHG HOTELS & RESORTS
INSERT INTO Room (RoomID, HotelID, CanExtend, RoomView, CapacityOfRoom, Price, Availability)
VALUES
-- Hotel 46
(226, 46, TRUE, 'None', 1, 90, TRUE),
(227, 46, TRUE, 'Mountain', 2, 150, TRUE),
(228, 46, TRUE, 'None', 4, 250, TRUE),
(229, 46, FALSE, 'Sea', 5, 350, TRUE),
(230, 46, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 47
(231, 47, TRUE, 'None', 1, 90, TRUE),
(232, 47, TRUE, 'Mountain', 2, 150, TRUE),
(233, 47, TRUE, 'None', 4, 250, TRUE),
(234, 47, FALSE, 'Sea', 5, 350, TRUE),
(235, 47, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 48
(236, 48, TRUE, 'None', 1, 90, TRUE),
(237, 48, TRUE, 'Mountain', 2, 150, TRUE),
(238, 48, TRUE, 'None', 4, 250, TRUE),
(239, 48, FALSE, 'Sea', 5, 350, TRUE),
(240, 48, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 49
(241, 49, TRUE, 'None', 1, 90, TRUE),
(242, 49, TRUE, 'Mountain', 2, 150, TRUE),
(243, 49, TRUE, 'None', 4, 250, TRUE),
(244, 49, FALSE, 'Sea', 5, 350, TRUE),
(245, 49, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 50
(246, 50, TRUE, 'None', 1, 90, TRUE),
(247, 50, TRUE, 'Mountain', 2, 150, TRUE),
(248, 50, TRUE, 'None', 4, 250, TRUE),
(249, 50, FALSE, 'Sea', 5, 350, TRUE),
(250, 50, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 51
(251, 51, TRUE, 'None', 1, 90, TRUE),
(252, 51, TRUE, 'Mountain', 2, 150, TRUE),
(253, 51, TRUE, 'None', 4, 250, TRUE),
(254, 51, FALSE, 'Sea', 5, 350, TRUE),
(255, 51, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 52
(256, 52, TRUE, 'None', 1, 90, TRUE),
(257, 52, TRUE, 'Mountain', 2, 150, TRUE),
(258, 52, TRUE, 'None', 4, 250, TRUE),
(259, 52, FALSE, 'Sea', 5, 350, TRUE),
(260, 52, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 53
(261, 53, TRUE, 'None', 1, 90, TRUE),
(262, 53, TRUE, 'Mountain', 2, 150, TRUE),
(263, 53, TRUE, 'None', 4, 250, TRUE),
(264, 53, FALSE, 'Sea', 5, 350, TRUE),
(265, 53, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 54
(266, 54, TRUE, 'None', 1, 90, TRUE),
(267, 54, TRUE, 'Mountain', 2, 150, TRUE),
(268, 54, TRUE, 'None', 4, 250, TRUE),
(269, 54, FALSE, 'Sea', 5, 350, TRUE),
(270, 54, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 55
(271, 55, TRUE, 'None', 1, 90, TRUE),
(272, 55, TRUE, 'Mountain', 2, 150, TRUE),
(273, 55, TRUE, 'None', 4, 250, TRUE),
(274, 55, FALSE, 'Sea', 5, 350, TRUE),
(275, 55, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 56
(276, 56, TRUE, 'None', 1, 90, TRUE),
(277, 56, TRUE, 'Mountain', 2, 150, TRUE),
(278, 56, TRUE, 'None', 4, 250, TRUE),
(279, 56, FALSE, 'Sea', 5, 350, TRUE),
(280, 56, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 57
(281, 57, TRUE, 'None', 1, 90, TRUE),
(282, 57, TRUE, 'Mountain', 2, 150, TRUE),
(283, 57, TRUE, 'None', 4, 250, TRUE),
(284, 57, FALSE, 'Sea', 5, 350, TRUE),
(285, 57, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 58
(286, 58, TRUE, 'None', 1, 90, TRUE),
(287, 58, TRUE, 'Mountain', 2, 150, TRUE),
(288, 58, TRUE, 'None', 4, 250, TRUE),
(289, 58, FALSE, 'Sea', 5, 350, TRUE),
(290, 58, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 59
(291, 59, TRUE, 'None', 1, 90, TRUE),
(292, 59, TRUE, 'Mountain', 2, 150, TRUE),
(293, 59, TRUE, 'None', 4, 250, TRUE),
(294, 59, FALSE, 'Sea', 5, 350, TRUE),
(295, 59, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 60
(296, 60, TRUE, 'None', 1, 90, TRUE),
(297, 60, TRUE, 'Mountain', 2, 150, TRUE),
(298, 60, TRUE, 'None', 4, 250, TRUE),
(299, 60, FALSE, 'Sea', 5, 350, TRUE),
(300, 60, FALSE, 'Sea', 6, 480, TRUE);

-- ROOMS FOR WYNDHAM HOTELS & RESORTS
INSERT INTO Room (RoomID, HotelID, CanExtend, RoomView, CapacityOfRoom, Price, Availability)
VALUES
-- Hotel 61
(301, 61, TRUE, 'None', 1, 90, TRUE),
(302, 61, TRUE, 'Mountain', 2, 150, TRUE),
(303, 61, TRUE, 'None', 4, 250, TRUE),
(304, 61, FALSE, 'Sea', 5, 350, TRUE),
(305, 61, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 62
(306, 62, TRUE, 'None', 1, 90, TRUE),
(307, 62, TRUE, 'Mountain', 2, 150, TRUE),
(308, 62, TRUE, 'None', 4, 250, TRUE),
(309, 62, FALSE, 'Sea', 5, 350, TRUE),
(310, 62, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 63
(311, 63, TRUE, 'None', 1, 90, TRUE),
(312, 63, TRUE, 'Mountain', 2, 150, TRUE),
(313, 63, TRUE, 'None', 4, 250, TRUE),
(314, 63, FALSE, 'Sea', 5, 350, TRUE),
(315, 63, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 64
(316, 64, TRUE, 'None', 1, 90, TRUE),
(317, 64, TRUE, 'Mountain', 2, 150, TRUE),
(318, 64, TRUE, 'None', 4, 250, TRUE),
(319, 64, FALSE, 'Sea', 5, 350, TRUE),
(320, 64, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 65
(321, 65, TRUE, 'None', 1, 90, TRUE),
(322, 65, TRUE, 'Mountain', 2, 150, TRUE),
(323, 65, TRUE, 'None', 4, 250, TRUE),
(324, 65, FALSE, 'Sea', 5, 350, TRUE),
(325, 65, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 66
(326, 66, TRUE, 'None', 1, 90, TRUE),
(327, 66, TRUE, 'Mountain', 2, 150, TRUE),
(328, 66, TRUE, 'None', 4, 250, TRUE),
(329, 66, FALSE, 'Sea', 5, 350, TRUE),
(330, 66, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 67
(331, 67, TRUE, 'None', 1, 90, TRUE),
(332, 67, TRUE, 'Mountain', 2, 150, TRUE),
(333, 67, TRUE, 'None', 4, 250, TRUE),
(334, 67, FALSE, 'Sea', 5, 350, TRUE),
(335, 67, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 68
(336, 68, TRUE, 'None', 1, 90, TRUE),
(337, 68, TRUE, 'Mountain', 2, 150, TRUE),
(338, 68, TRUE, 'None', 4, 250, TRUE),
(339, 68, FALSE, 'Sea', 5, 350, TRUE),
(340, 68, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 69
(341, 69, TRUE, 'None', 1, 90, TRUE),
(342, 69, TRUE, 'Mountain', 2, 150, TRUE),
(343, 69, TRUE, 'None', 4, 250, TRUE),
(344, 69, FALSE, 'Sea', 5, 350, TRUE),
(345, 69, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 70
(346, 70, TRUE, 'None', 1, 90, TRUE),
(347, 70, TRUE, 'Mountain', 2, 150, TRUE),
(348, 70, TRUE, 'None', 4, 250, TRUE),
(349, 70, FALSE, 'Sea', 5, 350, TRUE),
(350, 70, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 71
(351, 71, TRUE, 'None', 1, 90, TRUE),
(352, 71, TRUE, 'Mountain', 2, 150, TRUE),
(353, 71, TRUE, 'None', 4, 250, TRUE),
(354, 71, FALSE, 'Sea', 5, 350, TRUE),
(355, 71, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 72
(356, 72, TRUE, 'None', 1, 90, TRUE),
(357, 72, TRUE, 'Mountain', 2, 150, TRUE),
(358, 72, TRUE, 'None', 4, 250, TRUE),
(359, 72, FALSE, 'Sea', 5, 350, TRUE),
(360, 72, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 73
(361, 73, TRUE, 'None', 1, 90, TRUE),
(362, 73, TRUE, 'Mountain', 2, 150, TRUE),
(363, 73, TRUE, 'None', 4, 250, TRUE),
(364, 73, FALSE, 'Sea', 5, 350, TRUE),
(365, 73, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 74
(366, 74, TRUE, 'None', 1, 90, TRUE),
(367, 74, TRUE, 'Mountain', 2, 150, TRUE),
(368, 74, TRUE, 'None', 4, 250, TRUE),
(369, 74, FALSE, 'Sea', 5, 350, TRUE),
(370, 74, FALSE, 'Sea', 6, 480, TRUE),

-- Hotel 75
(371, 75, TRUE, 'None', 1, 90, TRUE),
(372, 75, TRUE, 'Mountain', 2, 150, TRUE),
(373, 75, TRUE, 'None', 4, 250, TRUE),
(374, 75, FALSE, 'Sea', 5, 350, TRUE),
(375, 75, FALSE, 'Sea', 6, 480, TRUE);

-- **************************************
-- INSERTING AMENITIES FOR SELECT ROOMS
-- **************************************
INSERT INTO Amenities (RoomID, Amenity)
VALUES
(1, 'WiFi'),
(1, 'TV'),

(2, 'WiFi'),
(2, 'Air Conditioning'),

(4, 'WiFi'),
(4, 'TV'),
(4, 'Mini Bar'),

(10, 'WiFi'),

(25, 'WiFi'),
(25, 'Balcony'),

(50, 'WiFi'),
(50, 'TV'),

(76, 'WiFi'),
(76, 'Jacuzzi'),

(100, 'WiFi'),

(150, 'WiFi'),
(150, 'Mini Bar'),

(200, 'WiFi'),
(200, 'Air Conditioning');

-- *************************************************
-- INSERTING PROBLEMS WITH ROOM 
-- *************************************************
INSERT INTO Problems_with_Room (RoomID, Problem)
VALUES
(1, 'Broken AC'),
(1, 'Leaky Faucet'),

(10, 'No WiFi'),

(25, 'Broken TV'),

(50, 'Dirty Carpet'),
(50, 'Noise Issue'),

(76, 'Low Water Pressure');

-- ********************************************
-- INSERTING CUSTOMERS 
-- ********************************************
INSERT INTO Customer (IDNumber, TypeOfID, FullName, Address, DateOfRegistration)
VALUES
(1, 'Passport', 'John Smith', '123 Main St, New York City, United States', '2025-01-10'),
(2, 'Driver License', 'Emily Johnson', '45 Queen St, Toronto, Canada', '2025-01-15'),
(3, 'Passport', 'Michael Brown', '78 Sunset Blvd, Los Angeles, United States', '2025-02-01'),
(4, 'National ID', 'Sophia Davis', '22 King St W, Toronto, Canada', '2025-02-10'),
(5, 'Passport', 'Daniel Wilson', '910 Ocean Dr, Miami, United States', '2025-02-20'),
(6, 'Driver License', 'Olivia Martinez', '300 Elm St, Dallas, United States', '2025-03-01'),
(7, 'Passport', 'James Anderson', '55 Peachtree St, Atlanta, United States', '2025-03-10'),
(8, 'National ID', 'Isabella Thomas', '600 Granville St, Vancouver, Canada', '2025-03-15'),
(9, 'Passport', 'William Taylor', '700 Market St, San Francisco, United States', '2025-03-20'),
(10, 'Driver License', 'Mia White', '800 Colfax Ave, Denver, United States', '2025-03-25');

-- ************************************************
-- INSERTING BOOKINGS 
-- ************************************************
INSERT INTO Booking (BookingID, CustomerID, RoomID, StatusofBooking, BookingDate, CheckInDate, CheckOutDate)
VALUES
(1, 1, 1, 'Confirmed', '2025-04-01', '2025-04-10', '2025-04-15'),
(2, 2, 2, 'Pending', '2025-04-02', '2025-04-12', '2025-04-16'),
(3, 3, 10, 'Cancelled', '2025-04-03', '2025-04-14', '2025-04-18'),
(4, 4, 25, 'Confirmed', '2025-04-04', '2025-04-20', '2025-04-25'),
(5, 5, 50, 'Confirmed', '2025-04-05', '2025-04-22', '2025-04-28'),
(6, 6, 76, 'Pending', '2025-04-06', '2025-04-25', '2025-04-30'),
(7, 7, 100, 'Confirmed', '2025-04-07', '2025-05-01', '2025-05-05'),
(8, 8, 150, 'Cancelled', '2025-04-08', '2025-05-03', '2025-05-08'),
(9, 9, 200, 'Confirmed', '2025-04-09', '2025-05-10', '2025-05-15'),
(10, 10, 250, 'Pending', '2025-04-10', '2025-05-12', '2025-05-18');

-- ************************************************
-- INSERTING RENTINGS 
-- ************************************************
INSERT INTO Renting (RentingID, BookingID, CustomerID, HotelID, RoomID, PaymentStatus, CheckInTime, CheckOutTime)
VALUES
(1, 1, 1, 123456789, 1, 'Paid', '14:00:00', '11:00:00'),
(2, 4, 4, 5, 25, 'Partially Paid', '15:00:00', '11:00:00'),
(3, 5, 5, 10, 50, 'Paid', '13:00:00', '10:00:00'),
(4, 7, 7, 20, 100, 'Not Paid', '16:00:00', '11:00:00'),
(5, 9, 9, 30, 200, 'Paid', '14:30:00', '11:30:00');

-- ********************
-- INSERTING EMPLOYEE
-- *********************

-- Adding Managers only one per hotel 
INSERT INTO Employee (SSN_SIN, HotelID, FullName, Address, PositionName)
VALUES
(123456789, 123456789, 'John Smith', '123 Main St, New York', 'Manager'),
(111111111, 111111111, 'Emily Johnson', '456 Sunset Blvd, Los Angeles', 'Manager'),
(222222222, 222222222, 'Michael Brown', '789 Lakeshore Rd, Chicago', 'Manager'),
(333333333, 4, 'Sarah Davis', '321 Ocean Dr, Miami', 'Manager'),
(444444444, 5, 'David Wilson', '654 King St, Toronto', 'Manager'),
(555555555, 6, 'Laura Martinez', '987 Granville St, Vancouver', 'Manager'),
(666666666, 7, 'James Anderson', '159 Peachtree St, Atlanta', 'Manager'),
(777777777, 8, 'Olivia Thomas', '753 Market St, San Francisco', 'Manager'),
(888888888, 9, 'Daniel Taylor', '852 Colfax Ave, Denver', 'Manager'),
(999999999, 10, 'Sophia Moore', '951 Boylston St, Boston', 'Manager'),

(100000001, 11, 'Liam White', '12 Queen St, Orlando', 'Manager'),
(100000002, 12, 'Noah Harris', '45 Bay St, Montreal', 'Manager'),
(100000003, 13, 'Emma Clark', '67 King St, Seattle', 'Manager'),
(100000004, 14, 'Ava Lewis', '89 Broadway, Dallas', 'Manager'),
(100000005, 15, 'Mason Walker', '23 Ocean Blvd, Miami', 'Manager'),
(100000006, 16, 'Lucas Hall', '78 Sunset Dr, LA', 'Manager'),
(100000007, 17, 'Mia Allen', '56 Market St, SF', 'Manager'),
(100000008, 18, 'Ethan Young', '90 Yonge St, Toronto', 'Manager'),
(100000009, 19, 'Isabella King', '34 Granville St, Vancouver', 'Manager'),
(100000010, 20, 'James Wright', '11 King Rd, Chicago', 'Manager'),

(100000011, 21, 'Charlotte Scott', '78 Lake Rd, Boston', 'Manager'),
(100000012, 22, 'Benjamin Green', '54 Elm St, Denver', 'Manager'),
(100000013, 23, 'Amelia Baker', '22 Pine St, Atlanta', 'Manager'),
(100000014, 24, 'Elijah Adams', '89 Palm Dr, Orlando', 'Manager'),
(100000015, 25, 'Harper Nelson', '100 Bayview Ave, Seattle', 'Manager'),
(100000016, 26, 'Henry Carter', '76 Maple Rd, Dallas', 'Manager'),
(100000017, 27, 'Evelyn Mitchell', '66 Queen St, Montreal', 'Manager'),
(100000018, 28, 'Alexander Perez', '55 King Blvd, Toronto', 'Manager'),
(100000019, 29, 'Abigail Roberts', '44 Sunset Blvd, LA', 'Manager'),
(100000020, 30, 'Michael Turner', '33 Ocean Dr, Miami', 'Manager'),

(100000021, 31, 'Sofia Phillips', '22 Main St, Chicago', 'Manager'),
(100000022, 32, 'Daniel Campbell', '11 Lake Shore, Vancouver', 'Manager'),
(100000023, 33, 'Avery Parker', '88 Broadway, NY', 'Manager'),
(100000024, 34, 'Matthew Evans', '77 Bay St, Toronto', 'Manager'),
(100000025, 35, 'Ella Edwards', '66 King St, Montreal', 'Manager'),
(100000026, 36, 'Joseph Collins', '55 Elm St, Boston', 'Manager'),
(100000027, 37, 'Scarlett Stewart', '44 Pine St, Denver', 'Manager'),
(100000028, 38, 'Samuel Sanchez', '33 Palm Ave, Miami', 'Manager'),
(100000029, 39, 'Victoria Morris', '22 Ocean Blvd, LA', 'Manager'),
(100000030, 40, 'David Rogers', '11 Sunset Dr, SF', 'Manager'),

(100000031, 41, 'Lily Reed', '90 Market St, Seattle', 'Manager'),
(100000032, 42, 'Andrew Cook', '89 Queen St, Toronto', 'Manager'),
(100000033, 43, 'Hannah Morgan', '78 King Rd, Dallas', 'Manager'),
(100000034, 44, 'Christopher Bell', '67 Bayview Ave, Chicago', 'Manager'),
(100000035, 45, 'Grace Murphy', '56 Maple Rd, Boston', 'Manager'),
(100000036, 46, 'Joshua Bailey', '45 Elm St, Atlanta', 'Manager'),
(100000037, 47, 'Chloe Rivera', '34 Pine St, Orlando', 'Manager'),
(100000038, 48, 'Nathan Cooper', '23 Ocean Dr, Miami', 'Manager'),
(100000039, 49, 'Zoe Richardson', '12 Sunset Blvd, LA', 'Manager'),
(100000040, 50, 'Ryan Cox', '11 Market St, SF', 'Manager'),

(100000041, 51, 'Natalie Howard', '100 King St, Toronto', 'Manager'),
(100000042, 52, 'Aaron Ward', '99 Bay St, Montreal', 'Manager'),
(100000043, 53, 'Leah Torres', '88 Queen St, Vancouver', 'Manager'),
(100000044, 54, 'Justin Peterson', '77 Broadway, NY', 'Manager'),
(100000045, 55, 'Audrey Gray', '66 Main St, Chicago', 'Manager'),
(100000046, 56, 'Kevin Ramirez', '55 Elm St, Dallas', 'Manager'),
(100000047, 57, 'Bella James', '44 Pine St, Miami', 'Manager'),
(100000048, 58, 'Jason Watson', '33 Ocean Blvd, LA', 'Manager'),
(100000049, 59, 'Stella Brooks', '22 Sunset Dr, SF', 'Manager'),
(100000050, 60, 'Eric Kelly', '11 Market St, Seattle', 'Manager'),

(100000051, 61, 'Madison Sanders', '90 Bay St, Toronto', 'Manager'),
(100000052, 62, 'Brandon Price', '89 Queen St, Montreal', 'Manager'),
(100000053, 63, 'Penelope Bennett', '78 King Rd, Vancouver', 'Manager'),
(100000054, 64, 'Justin Wood', '67 Broadway, NY', 'Manager'),
(100000055, 65, 'Lucy Barnes', '56 Main St, Chicago', 'Manager'),
(100000056, 66, 'Kyle Ross', '45 Elm St, Dallas', 'Manager'),
(100000057, 67, 'Anna Henderson', '34 Pine St, Miami', 'Manager'),
(100000058, 68, 'Dylan Coleman', '23 Ocean Blvd, LA', 'Manager'),
(100000059, 69, 'Layla Jenkins', '12 Sunset Dr, SF', 'Manager'),
(100000060, 70, 'Connor Perry', '11 Market St, Seattle', 'Manager'),

(100000061, 71, 'Nora Powell', '100 King St, Toronto', 'Manager'),
(100000062, 72, 'Jordan Long', '99 Bay St, Montreal', 'Manager'),
(100000063, 73, 'Hazel Patterson', '88 Queen St, Vancouver', 'Manager'),
(100000064, 74, 'Adam Hughes', '77 Broadway, NY', 'Manager'),
(100000065, 75, 'Ruby Flores', '66 Main St, Chicago', 'Manager');

-- Adding an employee per hotel just for basic population 
INSERT INTO Employee (SSN_SIN, HotelID, FullName, Address, PositionName)
VALUES
(200000001, 123456789, 'Alex Carter', '123 Main St, New York', 'Receptionist'),
(200000002, 111111111, 'Maya Lopez', '456 Sunset Blvd, Los Angeles', 'Housekeeper'),
(200000003, 222222222, 'Ethan Brooks', '789 Lakeshore Rd, Chicago', 'Receptionist'),
(200000004, 4, 'Lily Nguyen', '321 Ocean Dr, Miami', 'Cleaner'),
(200000005, 5, 'Noah Patel', '654 King St, Toronto', 'Receptionist'),
(200000006, 6, 'Chloe Kim', '987 Granville St, Vancouver', 'Housekeeper'),
(200000007, 7, 'Lucas Rivera', '159 Peachtree St, Atlanta', 'Cleaner'),
(200000008, 8, 'Ava Chen', '753 Market St, San Francisco', 'Receptionist'),
(200000009, 9, 'Mason Turner', '852 Colfax Ave, Denver', 'Housekeeper'),
(200000010, 10, 'Sofia Ahmed', '951 Boylston St, Boston', 'Cleaner'),

(200000011, 11, 'Leo Foster', '12 Queen St, Orlando', 'Receptionist'),
(200000012, 12, 'Zara Ali', '45 Bay St, Montreal', 'Housekeeper'),
(200000013, 13, 'Jack Murphy', '67 King St, Seattle', 'Cleaner'),
(200000014, 14, 'Ella Singh', '89 Broadway, Dallas', 'Receptionist'),
(200000015, 15, 'Ryan Scott', '23 Ocean Blvd, Miami', 'Housekeeper'),
(200000016, 16, 'Amelia Ross', '78 Sunset Dr, LA', 'Cleaner'),
(200000017, 17, 'Owen Diaz', '56 Market St, SF', 'Receptionist'),
(200000018, 18, 'Nina Park', '90 Yonge St, Toronto', 'Housekeeper'),
(200000019, 19, 'Caleb Reed', '34 Granville St, Vancouver', 'Cleaner'),
(200000020, 20, 'Hannah Cole', '11 King Rd, Chicago', 'Receptionist'),

(200000021, 21, 'Aaron Ward', '78 Lake Rd, Boston', 'Housekeeper'),
(200000022, 22, 'Lucy Gray', '54 Elm St, Denver', 'Cleaner'),
(200000023, 23, 'Isaac Bell', '22 Pine St, Atlanta', 'Receptionist'),
(200000024, 24, 'Mila Torres', '89 Palm Dr, Orlando', 'Housekeeper'),
(200000025, 25, 'Logan Price', '100 Bayview Ave, Seattle', 'Cleaner'),
(200000026, 26, 'Grace Bennett', '76 Maple Rd, Dallas', 'Receptionist'),
(200000027, 27, 'Eli Watson', '66 Queen St, Montreal', 'Housekeeper'),
(200000028, 28, 'Zoe Sanders', '55 King Blvd, Toronto', 'Cleaner'),
(200000029, 29, 'Tyler Hughes', '44 Sunset Blvd, LA', 'Receptionist'),
(200000030, 30, 'Ruby Brooks', '33 Ocean Dr, Miami', 'Housekeeper'),

(200000031, 31, 'Dylan Perry', '22 Main St, Chicago', 'Cleaner'),
(200000032, 32, 'Bella Flores', '11 Lake Shore, Vancouver', 'Receptionist'),
(200000033, 33, 'Jason Kelly', '88 Broadway, NY', 'Housekeeper'),
(200000034, 34, 'Layla Jenkins', '77 Bay St, Toronto', 'Cleaner'),
(200000035, 35, 'Connor Wood', '66 King St, Montreal', 'Receptionist'),
(200000036, 36, 'Eva Barnes', '55 Elm St, Boston', 'Housekeeper'),
(200000037, 37, 'Omar Powell', '44 Pine St, Denver', 'Cleaner'),
(200000038, 38, 'Sara Long', '33 Palm Ave, Miami', 'Receptionist'),
(200000039, 39, 'Kevin Cox', '22 Ocean Blvd, LA', 'Housekeeper'),
(200000040, 40, 'Megan Ward', '11 Sunset Dr, SF', 'Cleaner'),

(200000041, 41, 'Daniel Price', '90 Market St, Seattle', 'Receptionist'),
(200000042, 42, 'Chloe Reed', '89 Queen St, Toronto', 'Housekeeper'),
(200000043, 43, 'Brandon Cole', '78 King Rd, Dallas', 'Cleaner'),
(200000044, 44, 'Sophia Bell', '67 Bayview Ave, Chicago', 'Receptionist'),
(200000045, 45, 'Nathan Ross', '56 Maple Rd, Boston', 'Housekeeper'),
(200000046, 46, 'Emily Cook', '45 Elm St, Atlanta', 'Cleaner'),
(200000047, 47, 'Jacob Torres', '34 Pine St, Orlando', 'Receptionist'),
(200000048, 48, 'Ariana Diaz', '23 Ocean Dr, Miami', 'Housekeeper'),
(200000049, 49, 'Evan Murphy', '12 Sunset Blvd, LA', 'Cleaner'),
(200000050, 50, 'Luna Kim', '11 Market St, SF', 'Receptionist'),

(200000051, 51, 'Isaiah Brooks', '100 King St, Toronto', 'Housekeeper'),
(200000052, 52, 'Mila Carter', '99 Bay St, Montreal', 'Cleaner'),
(200000053, 53, 'Owen Foster', '88 Queen St, Vancouver', 'Receptionist'),
(200000054, 54, 'Zara Nguyen', '77 Broadway, NY', 'Housekeeper'),
(200000055, 55, 'Luke Adams', '66 Main St, Chicago', 'Cleaner'),
(200000056, 56, 'Nora Bennett', '55 Elm St, Dallas', 'Receptionist'),
(200000057, 57, 'Ethan Hayes', '44 Pine St, Miami', 'Housekeeper'),
(200000058, 58, 'Sophie Turner', '33 Ocean Blvd, LA', 'Cleaner'),
(200000059, 59, 'Caleb Watson', '22 Sunset Dr, SF', 'Receptionist'),
(200000060, 60, 'Holly James', '11 Market St, Seattle', 'Housekeeper'),

(200000061, 61, 'Ryan Brooks', '90 Bay St, Toronto', 'Cleaner'),
(200000062, 62, 'Ella Ward', '89 Queen St, Montreal', 'Receptionist'),
(200000063, 63, 'Noah Diaz', '78 King Rd, Vancouver', 'Housekeeper'),
(200000064, 64, 'Maya Foster', '67 Broadway, NY', 'Cleaner'),
(200000065, 65, 'Liam Scott', '56 Main St, Chicago', 'Receptionist'),
(200000066, 66, 'Chloe Hayes', '45 Elm St, Dallas', 'Housekeeper'),
(200000067, 67, 'Jack Murphy', '34 Pine St, Miami', 'Cleaner'),
(200000068, 68, 'Ava Brooks', '23 Ocean Blvd, LA', 'Receptionist'),
(200000069, 69, 'Leo Nguyen', '12 Sunset Dr, SF', 'Housekeeper'),
(200000070, 70, 'Grace Cole', '11 Market St, Seattle', 'Cleaner'),

(200000071, 71, 'Ethan Bell', '100 King St, Toronto', 'Receptionist'),
(200000072, 72, 'Sophia Reed', '99 Bay St, Montreal', 'Housekeeper'),
(200000073, 73, 'Lucas Hayes', '88 Queen St, Vancouver', 'Cleaner'),
(200000074, 74, 'Mia Carter', '77 Broadway, NY', 'Receptionist'),
(200000075, 75, 'Noah Brooks', '66 Main St, Chicago', 'Housekeeper');

/* ##################################################
********** PART C: Database Queries **********
*/ ##################################################

-- QUERY 1
-- Creating a Query that gives customers full name and the hotel name and price and checkin and out 
-- Date as well as booking status. Specfically for the Marriott Marquis Hotel 
SELECT 
	Customer.FullName,
    Hotel.HotelName, 
    Room.Price, 
    Booking.CheckInDate, 
    Booking.CheckOutDate,
    Booking.StatusofBooking
FROM Booking
JOIN Customer ON Booking.CustomerID = Customer.IDNumber
JOIN Room ON Booking.RoomID = Room.RoomID
JOIN Hotel ON Room.HotelID = Hotel.HotelID 
WHERE Hotel.HotelName = 'Marriott Marquis'; -- For the webiste this value would not be hardcoded but user selected 

-- QUERY 2 
-- Creating a query that filters hotel rooms by price and location
SELECT 
	Hotel.HotelName, 
    Hotel.Address, 
    Room.Price, 
    Room.Availability
FROM Hotel
JOIN Room ON Hotel.HotelID = Room.HotelID
WHERE Hotel.Address LIKE '%New York City%' -- Again for a website these filter values would be user selected 
	AND Room.Price < 200
	AND Room.Availability = TRUE; 
    
-- QUERY 3 
-- To implement a query that uses aggregation. This query will count how many booking each 
-- Hotel has. 
SELECT HotelName, COUNT(Booking.BookingID) AS NumberOfBookings 
FROM Booking
JOIN Room ON Booking.RoomID = Room.RoomID
JOIN Hotel ON Room.HotelID = Hotel.HotelID
GROUP BY HotelName ; 

-- QUERY 4
-- To implement a query that uses nested queries. We will create a query where we find all rooms
-- That cost more than the average room price (Two SELECT's). While also adding Room infor and HotelName 
SELECT 
	Hotel.HotelName, 
    Room.RoomID,
    Room.Price,
    Room.CapacityOfRoom,
    Room.RoomView
FROM Room
JOIN Hotel ON Room.HotelID = Hotel.HotelID
WHERE Room.Price > (
    SELECT AVG(Room.Price)
    FROM Room
);

-- QUERY 5 
-- This is an extra query that will show avaialable rooms thats have reported problems, so that 
-- Customers will be able to avoid them, and/or employees can ensure that they dont place customers 
-- In those rooms
SELECT
	Hotel.HotelName, 
    Room.RoomID,
    Room.Availability,
    Problems_with_Room.Problem
FROM Room
JOIN Hotel ON Room.HotelID = Hotel.HotelID
JOIN Problems_with_Room ON Room.RoomID = Problems_with_Room.RoomID 
WHERE Room.Availability = TRUE ; 


/* ##################################################
********** PART D: Database Modifications **********
*/ ##################################################

-- ********************
-- Trigger for when a renting is created so that room turns unavailable 
-- ********************
DELIMITER // 
CREATE TRIGGER update_room_availability_after_renting 
AFTER INSERT ON Renting 
FOR EACH ROW 
BEGIN 
	UPDATE Room
    SET Availability = FALSE 
	WHERE Room.RoomID = NEW.RoomID ; -- 
END // 
DELIMITER ; 

-- ********************************************************
-- This trigger ensures there are no overlapping rentings with date and time 
-- ********************************************************

DELIMITER //
CREATE TRIGGER prevent_overlapping_rentings
BEFORE INSERT ON Renting
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Renting
        JOIN Booking b1 ON Renting.BookingID = b1.BookingID 
        JOIN Booking b2 ON b2.BookingID = NEW.BookingID -- where b1 is an existing booking (which connects to renting) and b2 the new booking being converted to renting 
        WHERE Renting.RoomID = NEW.RoomID
        AND (
            b2.CheckInDate < b1.CheckOutDate
            AND b2.CheckOutDate > b1.CheckInDate
        )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Rentings Overlap';
    END IF;
END //
DELIMITER ;

-- **********************************************************************************
-- Trigger for archiving bookings and rentings for if a booking/renting is deleted 
-- **********************************************************************************

-- Booking archive 
DELIMITER //
CREATE TRIGGER archive_booking_before_delete
BEFORE DELETE ON Booking
FOR EACH ROW
BEGIN
    INSERT INTO BookingArchive
    VALUES (
        OLD.BookingID,
        OLD.CustomerID,
        OLD.RoomID,
        OLD.StatusofBooking,
        OLD.BookingDate,
        OLD.CheckInDate,
        OLD.CheckOutDate
    );
END //
DELIMITER ;

-- Renting Archive 
DELIMITER //
CREATE TRIGGER archive_renting_before_delete
BEFORE DELETE ON Renting
FOR EACH ROW
BEGIN
    INSERT INTO RentingArchive
    VALUES (
        OLD.RentingID,
        OLD.BookingID, 
        OLD.CustomerID,
        OLD.HotelID, 
        OLD.RoomID,
        OLD.PaymentStatus, 
        OLD.CheckInTime,
        OLD.CheckOutTime
    );
END //
DELIMITER ;

-- Adding a new trigger that will make the room available after renting is deleted 
-- Typically done after they check out, so that the room always stays available 
DELIMITER //
CREATE TRIGGER restore_availability
AFTER DELETE ON Renting
FOR EACH ROW
BEGIN
    UPDATE Room
    SET Availability = TRUE
    WHERE RoomID = OLD.RoomID;
END //
DELIMITER ;

-- **********************
-- TESTING TRIGGERS
-- **********************

-- Check initial availability
SELECT Availability FROM Room WHERE RoomID = 1;

-- Insert renting (should change availability) 
-- INSERT INTO Renting 
-- VALUES (999, 1, 1, 123456789, 1, 'Paid', '14:00:00', '11:00:00');

-- Check availability again (should now be FALSE)
SELECT Availability FROM Room WHERE RoomID = 1;

-- Delete renting (Should archive) 
DELETE FROM Renting WHERE RentingID = 999;

-- Check archive table
SELECT * FROM RentingArchive;

-- *********************
-- Insert Operations 
-- *********************
-- Doing Some basic insert operations 
-- Inserting a new customer 
INSERT INTO Customer (IDNumber, TypeOfID, FullName, Address, DateOfRegistration)
VALUES (789, 'Passport', 'John Doe', '123 First Street', '2026-02-03') ; 

-- Inserting a booking for said customer 
INSERT INTO Booking (BookingID, CustomerID, RoomID, StatusofBooking, BookingDate, CheckInDate, CheckOutDate)
VALUES (100, 789, 199, 'Confirmed', '2026-02-03', '2026-03-03', '2026-03-06' ) ; 

-- Test overlapping renting (should FAIL)
-- INSERT INTO Renting 
-- VALUES (1000, 1, 1, 123456789, 1, 'Paid', '10:00:00', '12:00:00');

-- INSERT INTO Renting 
-- VALUES (1001, 2, 2, 123456789, 1, 'Paid', '11:00:00', '13:00:00');

-- *********************
-- Update Operations 
-- *********************
-- Updating the Booking status (when customer cancels) 
UPDATE Booking 
SET StatusofBooking = 'Cancelled' 
WHERE BookingID = 100 ; 

-- Update Customer 
UPDATE Customer 
SET Address = '456 Second Street' 
WHERE IDNumber = 789 ; 

-- **********************
-- Delete Operations 
-- **********************

-- Need to delete the Renting with Booking ID 9 to then be able to delete the Booking 
DELETE FROM Renting WHERE BookingID = 9;
DELETE FROM Booking WHERE BookingID = 9;

DELETE FROM Renting WHERE RentingID = 3 ; 

/* ##################################################
********** PART E: Database Indexes **********
*/ ##################################################

-- **********************
-- Index for Hotel Name 
-- **********************
-- EXPLANATION: Used for Query 1 for when we filter using HotelName 
CREATE INDEX idx_hotel_name ON Hotel (HotelName) ; 

-- ***********************
-- Index for Room Prices
-- ***********************
-- EXPLANATION: Used for the Second Query and the Fourth 
CREATE INDEX idx_room_price ON Room (Price) ; 

-- ********************
-- Index for RoomID 
-- ********************
-- EXPLANATION: Used in the triggers when checking overlapping rentings and when we join renting with
-- Room in some of the queries.
CREATE INDEX idx_renting_room ON Renting (RoomID) ; 

-- *****************************
-- Index for Room Availability
-- *****************************
-- EXPLANATION: Two queries requires the filtering of available rooms, indexing would help improve the 
-- Preformance of those queries 
CREATE INDEX idx_room_availability ON Room (Availability) ; 

/* ##################################################
********** PART F: Database Views **********
*/ ##################################################

-- ********************
-- View 1: number of available rooms per area 
-- ********************

CREATE VIEW RoomsPerArea AS
SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(h.address, ',', 2), ',', -1)) AS Area, 
COUNT(*) AS AvailableRooms FROM Hotel h
JOIN Room r ON h.HotelID = r.HotelID WHERE r.Availability = TRUE
GROUP BY Area;

-- ********************
-- View 2: aggregated capacity of all the rooms of a specific hotel
-- ********************

CREATE VIEW roomCapacity AS
SELECT h.HotelName, SUM(r.CapacityOfRoom) AS TotalCapacity FROM Hotel h
JOIN Room r ON h.HotelID = r.HotelID
GROUP BY h.HotelID, h.HotelName;
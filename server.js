

/*************************** CONNECTING TO MYSQL **************************/
// This section is inspired by Webslesson (https://www.youtube.com/watch?v=wg9iwG8XfWY&list=PLxl69kCRkiI3j7RHumBhAr7MyZ4ehk9Q8&index=6)
const express = require("express"); //Imports Express for building the server
const mysql = require("mysql2"); //Imports mysql2 for database connection
const app = express(); //Creates Express app
const port = 3000; //Port for server to run on

app.use(express.json()); //Middleware for JSON data
app.use(express.static("public")); //Middleware for static files

const db = mysql.createConnection({ //Connects to ehotels in MySQL
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: "ehotels"
});

db.connect(error => { //Connect to database or draw error
    if (error) {
        console.error(error);
    }
    else {
        console.log("Connected to MySQL");
    }
});

/*************************** AREA FILTER OPTIONS **************************/

app.get("/areas", (req, res) => { //Retrieve data using query for fetch "/areas"
    const query = "SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Address, ',', 2), ',', -1)) AS Area FROM Hotel ORDER BY Area"; //Query for database

    db.query(query, (error, results) => { //Sends query to database
        if (error) { //Outputs any error that occured while sending query and recieving data
            console.error("Error fetching areas:", error);
            return res.status(500).json({ error: "Failed to fetch areas" }); //Internal server error
        }
        res.json(results); //Returns json version of results from query
    });
});

/*********************** HOTEL CHAINS FILTER OPTIONS **********************/

app.get("/hotel-chains", (req,res) => { //Retrieve data using query for fetch "/hotel-chains"
    const query = "SELECT DISTINCT ChainName FROM Hotel ORDER BY ChainName"; //Query for database

    db.query(query, (error, results) => { //Sends query to database
        if (error) { //Outputs any error that occured while sending query and recieving data
            console.error("Error fetching hotel chains:", error);
            return res.status(500).json({ error: "Failed to fetch hotel chains" }); //Internal server error
        }
        res.json(results); //Returns json version of results from query
    });
})

/*********************** FILTER BUTTON ON HOMESCREEN **********************/

app.post("/search-rooms", (req, res) => { //Sends query and recieves data for fetch "/search-rooms"
    const { startDate, endDate, capacity, area, chain, rating, totalRooms, price } = req.body; //Information being sent from fetch

    let query = "SELECT r.*, h.HotelName, h.ChainName, h.StarRating, h.Address, h.NumOfRooms FROM Room r JOIN Hotel h ON r.HotelID = h.HotelID WHERE r.Availability = TRUE"; //Query for database
    let params = [];

    if (capacity) { //Adds capacity fetch to query and adds it to params for sending if it is being filtered
        query += " AND r.CapacityOfRoom = ?";
        params.push(Number(capacity));
    }
    if (area) { //Adds area fetch to query and adds it to params for sending if it is being filtered
        query += " AND h.Address LIKE ?";
        params.push("%" + area + "%");
    }
    if (chain) { //Adds chain fetch to query and adds it to params for sending if it is being filtered
        query += " AND h.ChainName = ?";
        params.push(chain);
    }
    if (rating) { //Adds rating fetch to query and adds it to params for sending if it is being filtered
        query += " AND h.StarRating = ?";
        params.push(Number(rating));
    }
    if (totalRooms) { //Adds totalRooms fetch to query and adds it to params for sending if it is being filtered
        query += " AND h.NumOfRooms <= ?";
        params.push(Number(totalRooms));
    }
    if (price) { //Adds price fetch to query and adds it to params for sending if it is being filtered
        query += " AND r.Price <= ?";
        params.push(Number(price));
    }
    if (startDate && endDate) { //Adds startDate and endDate fetch to query and adds it to params for sending if it is being filtered
        query += " AND r.RoomID NOT IN (SELECT RoomID FROM Booking WHERE NOT (CheckOutDate < ? OR CheckInDate > ?))";
        params.push(startDate, endDate);
    }

    db.query(query, params, (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Error fetching options:", error);
            return res.status(500).json({ error: "Failed to fetch room options" }); //Internal server error
        }
        res.json(results); //Returns json version of the recieved data from the database (in this case, all filtered rooms)
    });
});

/***************************** CHECK CUSTOMER *****************************/

app.post("/check-customer", (req, res) => { //Sends query and recieves data for fetch "/check-customer"
    const { IDNumber } = req.body; //Information being sent from fetch
    if (!IDNumber) {
        return res.status(400).json({ exists: false, message: "IDNumber is required" }); //Bad request
    }
    const query = "SELECT IDNumber FROM Customer WHERE IDNumber = ?"; //Query for database

    db.query(query, [IDNumber], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Error checking customer:", error);
            return res.status(500).json({ error: "Failed to check Customer in database" }); //Internal server error
        }
        if (results.length > 0) {
            res.json({ exists: true, CustomerID: results[0].CustomerID }); //Returns json version of the recieved data from the database (in this case, exists boolean and customerID)
        } 
        else { //Returns exists boolean as false if customerID does not exist
            res.json({ exists: false });
        }
    });
});

/***************************** CREATE CUSTOMER ****************************/

app.post("/create-customer", (req, res) => { //Sends query and recieves data for fetch "/create-customer"
    const { IDNumber, TypeOfID, FullName, Address, DateOfRegistration } = req.body; //Information being sent from fetch
    const query = "INSERT INTO Customer (IDNumber, TypeOfID, FullName, Address, DateOfRegistration) VALUES (?, ?, ?, ?, ?)"; //Query for database

    db.query(query, [IDNumber, TypeOfID, FullName, Address, DateOfRegistration], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Error creating Customer:", error);
            return res.status(500).json({ success: false, message: "Error creating Customer" }); //Internal server error
        }
        res.json({ success: true, CustomerID: results.insertId }); //Returns json version of the recieved data from the database (in this case, success boolean and customerID)
    });
});

/***************************** CREATE BOOKING *****************************/

app.post("/confirm-booking", (req, res) => { //Sends query and recieves data for fetch "/confirm-booking"
    const { CustomerID, roomID, checkInDate, checkOutDate } = req.body; //Information being sent from fetch
    const BookingID = Math.floor(Math.random() * 1000000000); //Create random bookingID
    const bookingDate = new Date().toISOString().slice(0, 19).replace("T", " "); //Source: ChatGPT (https://chatgpt.com/)
    const query = "INSERT INTO Booking (BookingID, CustomerID, RoomID, StatusofBooking, BookingDate, CheckInDate, CheckOutDate) VALUES (?, ?, ?, ?, ?, ?, ?)"; //Query for database

    db.query(query, [BookingID, CustomerID, roomID, "Pending", bookingDate, checkInDate, checkOutDate], (error, result) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Error creating booking:", error);
            return res.status(500).json({ success: false, message: error.message }); //Internal server error
        }
        res.json({ success: true, BookingID }); //Returns json version of the recieved data from the database (in this case, success boolean and bookingID)
    });
});

/****************** CREATE TEMPORARY BOOKING FOR RENTING ******************/

app.post("/create-temp-booking", (req, res) => { //Sends query and recieves data for fetch "/create-temp-booking"
    const { BookingID, CustomerID, RoomID, checkInDate, checkOutDate } = req.body; //Information being sent from fetch
    const bookingDate = new Date().toISOString().slice(0, 19).replace("T", " "); //Source: ChatGPT (https://chatgpt.com/)
    const query = "INSERT INTO Booking (BookingID, CustomerID, RoomID, StatusofBooking, BookingDate, CheckInDate, CheckOutDate) VALUES (?, ?, ?, ?, ?, ?, ?)"; //Query for database

    db.query(query, [BookingID, CustomerID, RoomID, "Confirmed", bookingDate, checkInDate, checkOutDate], (error) => { //Sends query to database (must have array because of "?" in query)
            if (error) { //Outputs any error that occured while sending query and updating database
                console.error("Booking error:", error);
                return res.status(500).json({ success: false }); //Internal server error
            }
            res.json({ success: true }); //Returns json version of the recieved data from the database (in this case, just success boolean)
        }
    );
});

/***************************** CREATE RENTING *****************************/
app.post("/create-renting", (req, res) => { //Sends query and recieves data for fetch "/create-renting"
    const {RentingID, BookingID, CustomerID, HotelID, RoomID, checkInTime, checkOutTime} = req.body; //Information being sent from fetch
    const query = "INSERT INTO Renting (RentingID, BookingID, CustomerID, HotelID, RoomID, PaymentStatus, CheckInTime, CheckOutTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"; //Query for database

    db.query(query, [RentingID, BookingID, CustomerID, HotelID, RoomID, "Not Paid", checkInTime, checkOutTime], (error) => { //Sends query to database (must have array because of "?" in query)
            if (error) { //Outputs any error that occured while sending query and updating database
                console.error("Create renting error:", error);
                return res.status(500).json({ success: false }); //Internal server error
            }
            res.json({ success: true, rentingID: RentingID }); //Returns json version of the recieved data from the database (in this case, success boolean and rentingID)
        }
    );
});

/*********************** UPDATE RENTING AVAILABILITY **********************/

app.post("/confirm-renting", (req, res) => { //Sends query and recieves data for fetch "/confirm-renting"
    const { roomID } = req.body; //Information being sent from fetch
    const query = "UPDATE Room SET Availability = FALSE WHERE RoomID = ?"; //Query for database

    db.query(query, [roomID], (error) => { //Sends query to database (must have array because of "?" in query)
            if (error) { //Outputs any error that occured while sending query and updating database
                console.error("Update availability failed:", error);
                return res.status(500).json({ success: false }); //Internal server error
            }
            res.json({ success: true }); //Returns json version of the recieved data from the database (in this case, just success boolean)
        }
    );
});

/***************************** EMPLOYEE LOGIN *****************************/

app.post("/check-employee", (req,res) => { //Sends query and recieves data for fetch "/check-employee"
    const { employeeId } = req.body; //Information being sent from fetch
    const query = "SELECT * FROM Employee WHERE SSN_SIN = ?"; //Query for database

    db.query(query, [employeeId], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Check employeeID failed:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json({ valid: results.length > 0 }); //Returns json version of the recieved data from the database (in this case, whether employeeID exists (> 0))
    });
});

/****************************** MANAGER LOGIN *****************************/

app.post("/check-manager", (req, res) => { //Sends query and recieves data for fetch "/check-manager"
    const { employeeId } = req.body; //Information being sent from fetch
    const query = "SELECT * FROM Employee WHERE SSN_SIN = ? AND PositionName = 'Manager'"; //Query for database (will return employeeID that has positionName = Manager)

    db.query(query, [employeeId], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Check managerID failed:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json({ valid: results.length > 0 }); //Returns json version of the recieved data from the database (in this case, whether managerID exists (> 0))
    });
});

/***************************** SEARCH BOOKING *****************************/

app.post("/booking/:id", (req, res) => { //Sends query and recieves data for fetch "/booking/:id"
    const bookingId = req.params.id; //gets id value from request
    const query = "SELECT * FROM Booking WHERE BookingID = ?"; //Query for database

    db.query(query, [bookingId], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Retrieving bookingID failed:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json(results[0]); //Returns json version of the recieved data from the database (in this case, bookingID)
    });
});

/***************************** UPDATE PAYMENT *****************************/

app.post("/update-payment", (req, res) => { //Sends query and recieves data for fetch "/update-payment"
    const { rentingId, status } = req.body; //Information being sent from fetch
    const query = "UPDATE Renting SET PaymentStatus = ? WHERE RentingID =?"; //Query for database

    db.query(query, [status, rentingId], (error) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and updating database
            console.error("Update paymentStatus failed:", error);
            return res.status(500).json({ success: false, message: "Error updating PaymentStatus" }); //Internal server error
        }
        res.json({ success: true }); //Returns json version of the recieved data from the database (in this case, just success boolean)
    });
});

/************************** VIEW 1: RoomsPerArea **************************/

app.get("/rooms-per-area", (req, res) => { //Retrieve data using query for fetch "/rooms-per-area"
    const query = "SELECT * FROM RoomsPerArea"; //Query for database

    db.query(query, (error, results) => { //Sends query to database
        if (error) { //Outputs any error that occured while sending query and recieving data
            console.error("Error loading View 1:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json(results); //Returns json version of results from query
    });
});

/************************** VIEW 2: roomCapacity **************************/

app.get("/room-capacity", (req, res) => { //Retrieve data using query for fetch "/room-capacity"
    const query = "SELECT * FROM roomCapacity"; //Query for database

    db.query(query, (error, results) => { //Sends query to database
        if (error) { //Outputs any error that occured while sending query and recieving data
            console.error("Error loading View 2:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json(results); //Returns json version of results from query
    });
});

/************************ TABLES FOR MANAGER PORTAL ***********************/

app.get("/api/:table", (req, res) => { //Retrieve data using query for fetch "/api/:table"
    const table = req.params.table; //gets table value from request
    const query = "SELECT * FROM ??"; //Query for database

    db.query(query, [table], (error, results) => { //Sends query to database (must have array because of "?" in query)
        if (error) { //Outputs any error that occured while sending query and recieving data
            console.error("Error loading table:", error);
            return res.status(500).json(error); //Internal server error
        }
        res.json(results); //Returns json version of results from query
    });
});


/************ SAVE EDITS (ADD/DELETE/UPDATE) FOR MANAGER PORTAL ***********/
//Source: ChatGPT (https://chatgpt.com/)
app.post('/api/:table', (req, res) => {
    const table = req.params.table;
    const data = req.body;

    db.query(`DELETE FROM ??`, [table], (err) => {
        if (err) return res.status(500).send(err);
        if (!data.length) return res.sendStatus(200);

        const columns = Object.keys(data[0]);
        const values = data.map(row => columns.map(col => row[col]));

        db.query(`INSERT INTO ?? (${columns.join(",")}) VALUES ?`, [table, values], (err) => {
            if (err) return res.status(500).send(err);
            res.sendStatus(200);
        });
    });
});

/**************************************************************************/

app.listen(port); //Starts server on port 3000

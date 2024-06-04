**Flight Database Management System**

This project is a Python-based database management system for managing flight and pilot information using SQLite. It allows users to perform various operations such as inserting, updating, deleting, and querying flight and pilot data.

**Features**
    Create Tables: Automatically creates necessary database tables if they do not exist.
    Insert Flight: Add new flight details to the database.
    Insert Pilot: Add new pilot details to the database.
    Assign Pilot to Flight: Assign a pilot to a specific flight.
    Display All Flights: View all flights along with their assigned pilots.
    Search Flight: Search for a specific flight by its ID and view its details.
    Update Flight: Update the details of an existing flight.
    Delete Flight: Remove a flight from the database.
    Exit: Close the database connection and exit the program.

**Usage**
Run the program.
    Choose an option from the menu:
        Insert Flight Details
        Insert Pilot Details
        Assign a Pilot to a Flight
        Display all available Flights
        Search for a Flight
        Update a Flight
        Delete a Flight
        Exit
Follow the prompts to enter the required details for the selected operation.

**Requirements**
    Python 3.x
    SQLite

**Notes**
Ensure FlightDB.db is in the same directory as the script or specify the correct path in the sqlite3.connect() method.
Input validation is handled for integer inputs to prevent errors.

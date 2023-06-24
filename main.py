import sqlite3

# Class to perform various database operations
class DBOperations:
    def __init__(self):
        # Connect to the database
        self.conn = sqlite3.connect("FlightDB.db")
        self.cur = self.conn.cursor()

    # Method to get a valid integer input from the user
    def get_valid_integer_input(self, prompt):
        while True:
            try:
                # Try to convert the user input to an integer
                value = int(input(prompt))
                return value
            except ValueError:
                print("Invalid input. Please enter an integer.")

    # Method to create tables in the database if they do not already exist
    def create_tables(self):
        try:
            # Create the Aircraft table
            self.cur.execute("CREATE TABLE IF NOT EXISTS Aircraft (AircraftID INTEGER PRIMARY KEY, AircraftName TEXT)"
            )

            # Create the Pilot table
            self.cur.execute("CREATE TABLE IF NOT EXISTS Pilot (PilotID INTEGER PRIMARY KEY, PilotName TEXT)"
            )

            # Create the Flight table
            self.cur.execute("CREATE TABLE IF NOT EXISTS Flight (FlightID INTEGER PRIMARY KEY, FlightOrigin TEXT, FlightDestination TEXT, AircraftID INTEGER, FOREIGN KEY (AircraftID) REFERENCES Aircraft (AircraftID))"
            )

            # Create the FlightPilot table
            self.cur.execute("CREATE TABLE IF NOT EXISTS FlightPilot (FlightID INTEGER, PilotID INTEGER, FOREIGN KEY (FlightID) REFERENCES Flight (FlightID), FOREIGN KEY (PilotID) REFERENCES Pilot (PilotID), PRIMARY KEY (FlightID, PilotID))"
            )

            # Commit the changes to the database
            self.conn.commit()
            print("Tables created successfully")
        except sqlite3.Error as e:
            print("Error occurred while creating tables:", e)

    # Method to insert a flight into the Flight table
    def insert_flight(self, flight):
        try:
            self.cur.execute("INSERT INTO Flight (FlightID, FlightOrigin, FlightDestination, AircraftID) VALUES (?, ?, ?, ?)", (flight.get_flight_id(), flight.get_flight_origin(), flight.get_flight_destination(), flight.get_aircraft_id()),
            )
            self.conn.commit()
            print("Flight inserted successfully")
        except sqlite3.Error as e:
            print("Error occurred while inserting flight:", e)

    # Method to insert a pilot into the Pilot table
    def insert_pilot(self, pilot):
        try:
            self.cur.execute("INSERT INTO Pilot (PilotID, PilotName) VALUES (?, ?)", (pilot.get_pilot_id(), pilot.get_pilot_name()),
            )
            self.conn.commit()
            print("Pilot inserted successfully")
        except sqlite3.Error as e:
            print("Error occurred while inserting pilot:", e)

    # Method to assign a pilot to a flight in the FlightPilot table
    def assign_pilot_to_flight(self, flight_id, pilot_id):
        try:
            self.cur.execute("INSERT INTO FlightPilot (FlightID, PilotID) VALUES (?, ?)", (flight_id, pilot_id),
            )
            self.conn.commit()
            print("Pilot assigned to flight successfully")
        except sqlite3.Error as e:
            print("Error occurred while assigning pilot to flight:", e)

    # Method to select and print all flights from the Flight table
    def select_all_flights(self):
        try:
            self.cur.execute("SELECT * FROM Flight")
            flights = self.cur.fetchall()

            flight_count = 0  # Variable to store the count of flights
            pilot_count = 0  # Variable to store the count of pilots

            for flight in flights:
                print("Flight ID:", flight[0])
                print("Flight Origin:", flight[1])
                print("Flight Destination:", flight[2])
                print("Aircraft ID:", flight[3])

                # Get the pilots assigned to the flight from the FlightPilot table
                self.cur.execute(
                    "SELECT Pilot.PilotID, Pilot.PilotName FROM Pilot INNER JOIN FlightPilot ON FlightPilot.PilotID = Pilot.PilotID WHERE FlightPilot.FlightID = ?", (flight[0],)
                )
                pilots = self.cur.fetchall()
                print("Pilots:")
                for pilot in pilots:
                    pilot_id = pilot[0]
                    pilot_name = pilot[1]
                    print("- Pilot ID:", pilot_id)
                    print("  Pilot Name:", pilot_name)
                    pilot_count += 1

                print()
                flight_count += 1
              
            print()
            print("Summary Statistics:")
            print("Total Flights:", flight_count)
            print("Total Assigned Pilots:", pilot_count)
      
        except sqlite3.Error as e:
            print("Error occurred while selecting flights:", e)

    # Method to search for a flight by its ID in the Flight table
    def search_flight(self, flight_id):
        try:
            self.cur.execute(
                "SELECT * FROM Flight WHERE FlightID = ?", (flight_id,),
            )
            flight = self.cur.fetchone()

            if flight:
                print("Flight ID:", flight[0])
                print("Flight Origin:", flight[1])
                print("Flight Destination:", flight[2])
                print("Aircraft ID:", flight[3])

                # Get the pilot IDs assigned to the flight from the FlightPilot table
                self.cur.execute(
                    "SELECT PilotID FROM FlightPilot WHERE FlightID = ?", (flight[0],)
                )
                pilot_ids = self.cur.fetchall()
                print("Pilot IDs:")
                for pilot_id in pilot_ids:
                    print("- Pilot ID:", pilot_id[0])
            else:
                print("Flight not found")
        except sqlite3.Error as e:
            print("Error occurred while searching flight:", e)

    # Method to update a flight in the Flight table
    def update_flight(self, flight):
        try:
            self.cur.execute("UPDATE Flight SET FlightOrigin = ?, FlightDestination = ?, AircraftID = ? WHERE FlightID = ?",
                (
                    flight.get_flight_origin(),
                    flight.get_flight_destination(),
                    flight.get_aircraft_id(),
                    flight.get_flight_id(),
                ),
            )
            self.conn.commit()
            print("Flight updated successfully")
        except sqlite3.Error as e:
            print("Error occurred while updating flight:", e)

    # Method to delete a flight from the Flight table
    def delete_flight(self, flight_id):
        try:
            self.cur.execute("DELETE FROM Flight WHERE FlightID = ?", (flight_id,),
            )
            self.conn.commit()
            print("Flight deleted successfully")
        except sqlite3.Error as e:
            print("Error occurred while deleting flight:", e)

    # Method to close the database connection
    def close_connection(self):
        self.conn.close()

# Class representing a Flight
class Flight:
    def __init__(self, flight_id, origin, destination, aircraft_id):
        self.flight_id = flight_id
        self.origin = origin
        self.destination = destination
        self.aircraft_id = aircraft_id

    def get_flight_id(self):
        return self.flight_id

    def get_flight_origin(self):
        return self.origin

    def get_flight_destination(self):
        return self.destination

    def get_aircraft_id(self):
        return self.aircraft_id

# Class representing a Pilot
class Pilot:
    def __init__(self, pilot_id, pilot_name):
        self.pilot_id = pilot_id
        self.pilot_name = pilot_name

    def get_pilot_id(self):
        return self.pilot_id

    def get_pilot_name(self):
        return self.pilot_name

# Create an instance of the DBOperations class
db = DBOperations()

# Create the necessary database tables if they don't already exist
db.create_tables()

while True:
    print() 
    print("1. Insert Flight Details")
    print("2. Insert Pilot Details")
    print("3. Assign a Pilot to a Flight")
    print("4. Display all available Flights")
    print("5. Search for a Flight")
    print("6. Update a Flight")
    print("7. Delete a Flight")
    print("8. Exit")
    print()
    # Get user choice as an integer from 1 to 8
    choice = db.get_valid_integer_input("Enter an integer from 1-8 to operate the menu: ")

    if choice == 1:
        # Prompt the user for flight details
        flight_id = db.get_valid_integer_input("Enter Flight ID: ")
        origin = input("Enter Flight Origin: ")
        destination = input("Enter Flight Destination: ")
        aircraft_id = db.get_valid_integer_input("Enter Aircraft ID: ")

        # Create a Flight object
        flight = Flight(flight_id, origin, destination, aircraft_id)

        # Insert the flight into the Flight table
        db.insert_flight(flight)
    elif choice == 2:
        # Prompt the user for pilot details
        pilot_id = db.get_valid_integer_input("Enter Pilot ID: ")
        pilot_name = input("Enter Pilot Name: ")

        # Create a Pilot object
        pilot = Pilot(pilot_id, pilot_name)

        # Insert the pilot into the Pilot table
        db.insert_pilot(pilot)
    elif choice == 3:
        # Prompt the user for flight and pilot IDs
        flight_id = db.get_valid_integer_input("Enter Flight ID: ")
        pilot_id = db.get_valid_integer_input("Enter Pilot ID: ")

        # Assign the pilot to the flight in the FlightPilot table
        db.assign_pilot_to_flight(flight_id, pilot_id)
    elif choice == 4:
        # Select and display all flights with their assigned pilots
        db.select_all_flights()
    elif choice == 5:
        # Prompt the user for a flight ID to search
        flight_id = db.get_valid_integer_input("Enter Flight ID: ")

        # Search for the flight and display its details along with assigned pilot IDs
        db.search_flight(flight_id)
    elif choice == 6:
        # Prompt the user for flight details
        flight_id = db.get_valid_integer_input("Enter Flight ID: ")
        origin = input("Enter new Flight Origin: ")
        destination = input("Enter new Flight Destination: ")
        aircraft_id = db.get_valid_integer_input("Enter new Aircraft ID: ")

        # Create a Flight object with updated details
        flight = Flight(flight_id, origin, destination, aircraft_id)

        # Update the flight in the Flight table
        db.update_flight(flight)
    elif choice == 7:
        # Prompt the user for a flight ID to delete
        flight_id = db.get_valid_integer_input("Enter Flight ID: ")

        # Delete the flight from the Flight table
        db.delete_flight(flight_id)
    elif choice == 8:
        # Close the database connection and exit the program
        db.close_connection()
        break
    else:
        print("Invalid choice. Please try again.")
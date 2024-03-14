import 'package:flutter/material.dart';
import 'package:cobhs/start/loginPage.dart';
import 'viewBookingsPage.dart';
import 'createBookingPage.dart';
import 'cancelBookingPage.dart';
import 'submitFeedbackPage.dart';

const Color darkBlue = Color(0xFF555DBE); // Updated dark blue color
const Color lightBlue = Color(0xFF8C9EFF); // Updated light blue color

class MainCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoBHS Customer"),
        backgroundColor: darkBlue, // Setting app bar color to dark blue
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  "Customer Menu",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
              ),
              ListTile(
                title: Text(
                  "View Bookings",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewBookingsPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Create Booking",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBookingPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Cancel Booking",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CancelBookingPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Submit Feedback",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubmitFeedbackPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Switch Accounts",
                  style: TextStyle(color: Colors.white), // Making text white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: darkBlue, // Setting solid dark blue color for the body
        child: Center(
          child: Text(
            "Main Admin Page Content",
            style: TextStyle(color: Colors.white), // Making text white
          ),
        ),
      ),
    );
  }
}

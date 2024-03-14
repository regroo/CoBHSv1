import 'package:cobhs/student/viewBookings.dart';
import 'package:flutter/material.dart';
import 'package:cobhs/start/loginPage.dart';

const Color darkBlue = Color(0xff555dbe); // Updated dark blue color
const Color lightBlue = Color(0xFF8C9EFF); // Updated light blue color

class MainHPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoBHS Student"),
        backgroundColor: darkBlue, // Setting app bar color to dark blue
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: ListView(
            children: [
              DrawerHeader(
                child: Text("Student Menu",
                    style: TextStyle(color: Colors.white)), // Making text white
              ),
              ListTile(
                title: Text("View Timetable",
                    style: TextStyle(color: Colors.white)), // Making text white
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewBookings()),
                  );
                },
              ),
              ListTile(
                title: Text("Cancel Booking",
                    style: TextStyle(color: Colors.white)), // Making text white
                onTap: () {
                  // Navigate to the cancel booking page
                },
              ),
              ListTile(
                title: Text("View Payslip",
                    style: TextStyle(color: Colors.white)), // Making text white
                onTap: () {
                  // Navigate to the create payslip page
                },
              ),
              ListTile(
                title: Text("View Feedback",
                    style: TextStyle(color: Colors.white)), // Making text white
                onTap: () {
                  // Navigate to the change details page
                },
              ),
              ListTile(
                title: Text("Switch Accounts",
                    style: TextStyle(color: Colors.white)), // Making text white
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
        color: darkBlue, // Setting solid color background to dark blue
        child: Center(
          child: Text("Main Admin Page Content",
              style: TextStyle(color: Colors.white)), // Making text white
        ),
      ),
    );
  }
}

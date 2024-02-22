import 'package:flutter/material.dart';

const Color darkBlue = Color(0xac3884d4);
const Color lightBlue = Color(0x485788b7);

class MainCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoBHS Customer"),
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: ListView(
            children: [
              DrawerHeader(
                child: Text("Customer Menu"),
              ),
              ListTile(
                title: Text("View Bookings"),
                onTap: () {
                  // Navigate to the approve feedback page
                },
              ),
              ListTile(
                title: Text("Create Booking"),
                onTap: () {
                  // Navigate to the cancel booking page
                },
              ),
              ListTile(
                title: Text("Cancel Booking"),
                onTap: () {
                  // Navigate to the create payslip page
                },
              ),
              ListTile(
                title: Text("Submit Feedback"),
                onTap: () {
                  // Navigate to the change details page
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkBlue, lightBlue],
          ),
        ),
        child: Center(
          child: Text("Main Admin Page Content"),
        ),
      ),
    );
  }
}

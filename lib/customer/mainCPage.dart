import 'package:flutter/material.dart';
import 'package:cobhs/start/loginPage.dart';
import 'viewBookingsPage.dart';
import 'createBookingPage.dart';
import 'cancelBookingPage.dart';
import 'submitFeedbackPage.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewBookingsPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Create Booking"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBookingPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Cancel Booking"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CancelBookingPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Submit Feedback"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubmitFeedbackPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Switch Accounts"),
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

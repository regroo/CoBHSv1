import 'package:flutter/material.dart';
import 'package:cobhs/start/loginPage.dart';

const Color darkBlue = Color(0xac3884d4);
const Color lightBlue = Color(0x485788b7);

class MainHPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoBHS Student"),
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: ListView(
            children: [
              DrawerHeader(
                child: Text("Student Menu"),
              ),
              ListTile(
                title: Text("View Timetable"),
                onTap: () {
                  // Navigate to the approve feedback page
                },
              ),
              ListTile(
                title: Text("Cancel Booking"),
                onTap: () {
                  // Navigate to the cancel booking page
                },
              ),
              ListTile(
                title: Text("View Payslip"),
                onTap: () {
                  // Navigate to the create payslip page
                },
              ),
              ListTile(
                title: Text("View Feedback"),
                onTap: () {
                  // Navigate to the change details page
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

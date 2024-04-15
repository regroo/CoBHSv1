import 'package:flutter/material.dart';
import 'package:cobhs/start/loginPage.dart';
import 'approveFeedback.dart';
import 'cancelBooking.dart';
import 'createPayslip.dart';
import 'changeDetails.dart';
import 'createAccount.dart';
import 'deleteAccount.dart';
import 'changePass.dart';
import 'setBookingTimes.dart';
import 'viewAllBookings.dart';

const Color darkBlue = Color(0xFF555DBE); // Updated dark blue color
const Color lightBlue = Color(0xFF8C9EFF); // Updated light blue color

class MainAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue, // Updated app bar color
        title: Text("CoBHS Admin"),
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: SingleChildScrollView(
            // Wrapping ListView with SingleChildScrollView
            child: Column(
              children: [
                DrawerHeader(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                ),
                ListTile(
                  title: Text(
                    "Approve Feedback",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ApproveFeedbackPage()),
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
                    "Create Payslip",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatePayslipPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Change Details",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeDetailsPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteAccountPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Set Booking times",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetBookingTimes()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "View all bookings",
                    style: TextStyle(color: Colors.white), // Making text white
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllBookings()),
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

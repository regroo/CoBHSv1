import 'package:cobhs/start/loginPage.dart';
import 'package:flutter/material.dart';
import 'approveFeedback.dart';
import 'cancelBooking.dart';
import 'createPayslip.dart';
import 'changeDetails.dart';
import 'createAccount.dart';
import 'deleteAccount.dart';
import 'changePass.dart';
import 'setBookingTimes.dart';

const Color darkBlue = Color(0xac3884d4);
const Color lightBlue = Color(0x485788b7);

class MainAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoBHS Admin"),
      ),
      drawer: Drawer(
        child: Container(
          color: darkBlue, // Setting solid color background for the drawer
          child: ListView(
            children: [
              DrawerHeader(
                child: Text("Admin Menu"),
              ),
              ListTile(
                title: Text("Approve Feedback"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApproveFeedbackPage()),
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
                title: Text("Create Payslip"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePayslipPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Change Details"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeDetailsPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Create Account"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Delete Account"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteAccountPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Change Password"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Set Booking times"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SetBookingTimes()),
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

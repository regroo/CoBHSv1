import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'registerPage.dart';
import 'package:cobhs/admin/mainAPage.dart';
import 'package:cobhs/customer/mainCPage.dart';
import 'package:cobhs/student/mainHPage.dart';
import 'package:cobhs/globals.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  void _login() async {
    String enteredUsername = loginUsernameController.text;
    String enteredPassword = loginPasswordController.text;

    try {
      // Retrieve user document from Firestore based on entered username
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isEqualTo: enteredUsername)
          .get();

      // Check if a user with the entered username exists
      if (userQuery.docs.isNotEmpty) {
        // Get the first user document (assuming username is unique)
        var userDocument = userQuery.docs.first;

        // Retrieve user password hash from Firestore
        String userPasswordHash = userDocument['userPass'];
        int userType = userDocument['userType'];

        // Hash the entered password
        String hashedPassword =
            sha256.convert(utf8.encode(enteredPassword)).toString();

        // Compare hashed passwords
        if (userPasswordHash == hashedPassword && userType == 0) {
          Globals.currentUsername =
              enteredUsername; // Access Globals and set currentUsername
          Globals.currentUserID = userDocument.id;
          _showMessage(context, "Admin Login Successful!");
        }
        if (userPasswordHash == hashedPassword && userType == 1) {
          Globals.currentUsername =
              enteredUsername; // Access Globals and set currentUsername
          Globals.currentUserID = userDocument.id;
          _showMessage(context, "Customer Login Successful!");
        }
        if (userPasswordHash == hashedPassword && userType == 2) {
          Globals.currentUsername =
              enteredUsername; // Access Globals and set currentUsername
          Globals.currentUserID = userDocument.id;
          _showMessage(context, "Student Login Successful!");
        }
        if (userPasswordHash != hashedPassword) {
          _showMessage(
              context, "Invalid username or password. Please try again.");
        }
      } else {
        _showMessage(
            context, "Invalid username or password. Please try again.");
      }
    } catch (e) {
      _showMessage(context, "Login failed. Error: $e");
    }
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (message == "Admin Login Successful!") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainAPage()),
                  );
                } else if (message == "Customer Login Successful!") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainCPage()),
                  );
                } else if (message == "Student Login Successful!") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainHPage()),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text(""),
      ),
      backgroundColor: darkBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "City of Bristol Hair Salon",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: loginUsernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: loginPasswordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        primary: lightBlue,
                      ),
                      child: Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: lightBlue,
                      ),
                      child: Text("Sign up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

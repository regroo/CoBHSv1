import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'loginPage.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class RegisterPage extends StatelessWidget {
  final TextEditingController registerNameController;
  final TextEditingController registerUsernameController;
  final TextEditingController registerPasswordController;

  RegisterPage({
    Key? key,
  })  : registerNameController = TextEditingController(),
        registerUsernameController = TextEditingController(),
        registerPasswordController = TextEditingController(),
        super(key: key);

  void _register(BuildContext context) async {
    String enteredName = registerNameController.text;
    String enteredEmail = registerUsernameController.text;
    String enteredPassword = registerPasswordController.text;

    // Hash the password
    String hashedPassword =
        sha256.convert(utf8.encode(enteredPassword)).toString();

    try {
      // Check for existing user with the same email
      QuerySnapshot emailQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userEmail', isEqualTo: enteredEmail)
          .get();

      // Check for existing user with the same username
      QuerySnapshot usernameQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isEqualTo: enteredName)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        _showMessage(
            context, "Email already exists. Please use a different email.");
      } else if (usernameQuery.docs.isNotEmpty) {
        _showMessage(context,
            "Username already exists. Please choose a different username.");
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );

        // Add user details to Firestore
        await FirebaseFirestore.instance.collection('Users').add({
          'userName': enteredName,
          'userPass': hashedPassword,
          'userEmail': enteredEmail,
          'userType': 1,
        });

        _showMessage(context, "Registration Successful!");
      }
    } catch (e) {
      _showMessage(context, "Registration failed. Error: $e");
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
                if (message == "Registration Successful!") {
                  // Navigate to LoginPage only if registration is successful
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
        title: Text("Register"),
        backgroundColor: darkBlue,
      ),
      body: Container(
        color: darkBlue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: registerNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                controller: registerUsernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                controller: registerPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _register(context);
                },
                child: Text("Register"),
                style: ElevatedButton.styleFrom(
                  primary: lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

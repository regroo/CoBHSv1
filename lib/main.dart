import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cobhs/firebase/firebase_options.dart';
import 'package:cobhs/start/loginPage.dart';

const Color darkBlue = Color(0xac3884d4);
const Color lightBlue = Color(0x485788b7); // Adjust light blue color

const messageLimit = 30;

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // Call a method to wait for 3 seconds before navigating to login page
    _navigateToLoginPageAfterDelay();
  }

  Future<void> _navigateToLoginPageAfterDelay() async {
    // Wait for 3 seconds
    await Future.delayed(Duration(seconds: 3));
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              darkBlue,
              lightBlue
            ], // Gradient colors from dark blue to light blue
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 120.0), // Adjust padding
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align the Column to the top
              children: [
                Text(
                  "City of Bristol Hair Salon",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80), // Decrease the height
                CircularProgressIndicator(), // Loading indicator
              ],
            ),
          ),
        ),
      ),
    );
  }
}

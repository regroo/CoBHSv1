import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color darkBlue = Color(0xFF555DBE); // Adjusted dark blue color
const Color lightBlue = Color(0xFF8C9EFF);

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _buttonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
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
                controller: _usernameController,
                onChanged: (value) {
                  setState(() {
                    _buttonClicked = false; // Reset button state
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _buttonClicked
                    ? () {
                        deleteAccount();
                      }
                    : () {
                        setState(() {
                          _buttonClicked = true;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  primary: _buttonClicked ? Colors.red : darkBlue,
                ),
                child: Text(
                  _buttonClicked ? 'Confirm Delete' : 'Delete Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    final username = _usernameController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final querySnapshot =
        await usersCollection.where('userName', isEqualTo: username).get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account with username $username not found')),
      );
    } else {
      final userId = querySnapshot.docs.first.id;
      await usersCollection.doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted for username: $username')),
      );
    }

    setState(() {
      _buttonClicked = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}

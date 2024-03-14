import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class ChangeDetailsPage extends StatefulWidget {
  @override
  _ChangeDetailsPageState createState() => _ChangeDetailsPageState();
}

class _ChangeDetailsPageState extends State<ChangeDetailsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  bool _showUserDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text("Change Details"),
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
                onPressed: () {
                  searchUser();
                },
                style: ElevatedButton.styleFrom(
                  primary: lightBlue,
                ),
                child: Text('Search User'),
              ),
              if (_showUserDetails) ...[
                SizedBox(height: 20),
                Text(
                  'Current Email: ${_emailController.text}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Current User Type: ${_userTypeController.text}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _userTypeController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'New User Type',
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
                  onPressed: () {
                    updateUserDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: lightBlue,
                  ),
                  child: Text('Update Details'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchUser() async {
    final username = _usernameController.text.trim();

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
        SnackBar(content: Text('User with username $username not found')),
      );
    } else {
      final userData = querySnapshot.docs.first.data();
      setState(() {
        _emailController.text = userData['userEmail'];
        _userTypeController.text = userData['userType'].toString();
        _showUserDetails = true;
      });
    }
  }

  Future<void> updateUserDetails() async {
    final username = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newUserType = _userTypeController.text.trim();

    if (username.isEmpty || newEmail.isEmpty || newUserType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final querySnapshot =
        await usersCollection.where('userName', isEqualTo: username).get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User with username $username not found')),
      );
    } else {
      final userId = querySnapshot.docs.first.id;

      // Validate email format using regular expression
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(newEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid email')),
        );
        return;
      }

      // Validate user type
      final userTypeInt = int.tryParse(newUserType);
      if (userTypeInt == null ||
          (userTypeInt != 0 && userTypeInt != 1 && userTypeInt != 2)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please enter a valid user type (0, 1, or 2)')),
        );
        return;
      }

      try {
        await usersCollection.doc(userId).update({
          'userEmail': newEmail,
          'userType': userTypeInt,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User details updated successfully')),
        );

        setState(() {
          _showUserDetails = false;
          _emailController.clear();
          _userTypeController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user details')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _userTypeController.dispose();
    super.dispose();
  }
}

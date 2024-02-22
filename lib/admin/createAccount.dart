import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _userType = 'admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _userType,
              items: [
                DropdownMenuItem<String>(
                  value: 'admin',
                  child: Text('Admin'),
                ),
                DropdownMenuItem<String>(
                  value: 'customer',
                  child: Text('Customer'),
                ),
                DropdownMenuItem<String>(
                  value: 'student',
                  child: Text('Student'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _userType = value!;
                });
              },
              decoration: InputDecoration(labelText: 'User Type'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createAccount();
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createAccount() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final usersCollection = FirebaseFirestore.instance.collection('Users');

    // Check if username already exists
    final existingUsernames =
        await usersCollection.where('userName', isEqualTo: username).get();

    if (existingUsernames.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username already exists')),
      );
      return;
    }

    // Check if email already exists
    final existingEmails =
        await usersCollection.where('userEmail', isEqualTo: email).get();

    if (existingEmails.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email already exists')),
      );
      return;
    }

    try {
      // Hash the password using SHA-256
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      await usersCollection.add({
        'userName': username,
        'userPass': hashedPassword,
        'userEmail': email,
        'userType': _userType == 'admin'
            ? 0
            : _userType == 'customer'
                ? 1
                : 2,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully')),
      );

      // Clear text field values after successful creation
      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                primary: _buttonClicked
                    ? Colors.red
                    : Theme.of(context).primaryColor,
              ),
              child: Text(_buttonClicked ? 'Confirm Delete' : 'Delete Account'),
            ),
          ],
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

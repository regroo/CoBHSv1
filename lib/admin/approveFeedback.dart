import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApproveFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approve Feedback"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xac3884d4), // darkBlue
              Color(0x485788b7), // lightBlue
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FeedbackList(),
          ),
        ),
      ),
    );
  }
}

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackListState createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Feedback')
          .where('approved', isEqualTo: false)
          .orderBy('order')
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('Error fetching feedback: ${snapshot.error}');
          return Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.black),
          );
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Text(
            'No feedback to approve.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        } else {
          final feedback = snapshot.data!.docs[0];
          final feedbackId = feedback.id;
          final userName = feedback['userName'];
          final feedbackText = feedback['feedback'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('User: $userName', style: TextStyle(color: Colors.black)),
              SizedBox(height: 20),
              Text('Feedback: $feedbackText',
                  style: TextStyle(color: Colors.black)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Approve the feedback
                  FirebaseFirestore.instance
                      .collection('Feedback')
                      .doc(feedbackId)
                      .update({'approved': true}).then((_) {
                    print('Feedback approved');
                    setState(() {}); // Refresh the widget
                  }).catchError(
                          (error) => print('Error approving feedback: $error'));
                },
                child: Text('Approve'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Decline the feedback
                  FirebaseFirestore.instance
                      .collection('Feedback')
                      .doc(feedbackId)
                      .delete()
                      .then((_) {
                    print('Feedback declined');
                    setState(() {}); // Refresh the widget
                  }).catchError(
                          (error) => print('Error declining feedback: $error'));
                },
                child: Text('Decline'),
              ),
            ],
          );
        }
      },
    );
  }
}

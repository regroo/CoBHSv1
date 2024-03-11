import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobhs/globals.dart';

class SubmitFeedbackPage extends StatefulWidget {
  @override
  _SubmitFeedbackPageState createState() => _SubmitFeedbackPageState();
}

class _SubmitFeedbackPageState extends State<SubmitFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Enter your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitFeedback();
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback() async {
    final feedbackText = _feedbackController.text.trim();
    if (feedbackText.isEmpty) {
      _showError('Please enter feedback');
      return;
    }

    final order = await _getNextOrder();
    if (order == null) {
      _showError('Failed to get order number');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Feedback').add({
        'approved': false,
        'userName': Globals.currentUsername, // Use Globals.currentUsername here
        'feedback': feedbackText,
        'order': order,
      });
      _showSuccess('Feedback submitted successfully');
      _feedbackController.clear();
    } catch (error) {
      _showError('Failed to submit feedback');
      print('Error submitting feedback: $error');
    }
  }

  Future<int?> _getNextOrder() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('order', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final lastOrder = querySnapshot.docs.first['order'];
        return lastOrder + 1;
      } else {
        return 1; // If no feedback exists yet, start from order 1
      }
    } catch (error) {
      print('Error getting next order number: $error');
      return null;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}

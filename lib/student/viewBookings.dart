import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobhs/globals.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class ViewBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Bookings"),
        backgroundColor: darkBlue,
      ),
      body: Container(
        color: darkBlue,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Bookings')
              .where('userId', isEqualTo: Globals.currentUserID)
              .orderBy('bookingTime', descending: false)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text('No bookings found',
                        style: TextStyle(color: Colors.white)));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var booking = snapshot.data!.docs[index];
                  var bookingTime = booking['bookingTime'];
                  var userName = booking['userName'];
                  return ListTile(
                    title: Text('Booking ${index + 1}: $bookingTime',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text('Customer Username: $userName',
                        style: TextStyle(color: Colors.white)),
                  );
                },
              );
            }
            return Center(
                child: Text('No bookings found',
                    style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}

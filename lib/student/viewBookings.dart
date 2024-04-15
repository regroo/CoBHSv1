import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobhs/globals.dart';
import 'package:cobhs/start/loginPage.dart';

const Color darkBlue = Color(0xff555dbe); // Updated dark blue color
const Color lightBlue = Color(0xFF8C9EFF); // Updated light blue color

class ViewBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Bookings"),
        backgroundColor: darkBlue, // Setting app bar color to dark blue
      ),
      body: Container(
        color: darkBlue, // Setting solid color background to dark blue
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(Globals.currentUserID)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>?;

              if (userData == null || userData['bookingIds'] == null) {
                return Center(child: Text('No bookings found'));
              }

              List<String> bookingIds =
                  List<String>.from(userData['bookingIds']);

              if (bookingIds.isEmpty) {
                return Center(child: Text('No bookings found'));
              }

              return ListView.builder(
                itemCount: bookingIds.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Bookings')
                        .doc(bookingIds[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var bookingData =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (bookingData != null) {
                          var bookingTime = bookingData['bookingTime'];
                          var userName = bookingData['userName'];
                          return ListTile(
                            title: Text('Booking Time: $bookingTime',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text('Customer Username: $userName',
                                style: TextStyle(color: Colors.white)),
                          );
                        }
                      }
                      return Text('No data found');
                    },
                  );
                },
              );
            }
            return Center(child: Text('No data found'));
          },
        ),
      ),
    );
  }
}

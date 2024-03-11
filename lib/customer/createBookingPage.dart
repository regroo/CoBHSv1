import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:cobhs/globals.dart';

class CreateBookingPage extends StatefulWidget {
  @override
  _CreateBookingPageState createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  List<String> timeSlots = [];
  String? selectedTimeSlot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTimeSlots();
  }

  Future<void> _fetchTimeSlots() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot? timesDocument = await FirebaseFirestore.instance
          .collection('Bookings')
          .doc('TIMES')
          .get();

      if (timesDocument != null && timesDocument.exists) {
        Map<String, dynamic>? data =
            timesDocument.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic>? selectedDays = data['selectedDays'] as List<dynamic>?;

          if (selectedDays != null) {
            // Access selectedDays here
            QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('userType', isEqualTo: 2)
                .get();

            final List<String> userDocumentIds =
                userSnapshot.docs.map((doc) => doc.id).toList();

            DateTime now = DateTime.now();
            DateTime twoWeeksLater = now.add(Duration(days: 14));

            for (DateTime date = now;
                date.isBefore(twoWeeksLater);
                date = date.add(Duration(days: 1))) {
              if (selectedDays.contains(_getDayOfWeek(date))) {
                for (int hour = 8; hour < 18; hour++) {
                  String formattedHour = hour.toString().padLeft(2, '0');
                  String timeSlot =
                      '${date.year}-${date.month}-${date.day} $formattedHour:00';

                  bool isBooked = true;
                  for (String userId in userDocumentIds) {
                    QuerySnapshot existingBooking = await FirebaseFirestore
                        .instance
                        .collection('Bookings')
                        .where('bookingTime', isEqualTo: timeSlot)
                        .where('userId', isEqualTo: userId)
                        .get();
                    if (existingBooking.docs.isEmpty) {
                      isBooked = false;
                      break;
                    }
                  }

                  if (!isBooked) {
                    timeSlots.add(timeSlot);
                  }
                }
              }
            }

            setState(() {
              selectedTimeSlot = timeSlots.isNotEmpty ? timeSlots[0] : null;
              isLoading = false;
            });
          }
        }
      }
    } catch (error) {
      print('Error fetching time slots: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createBooking() async {
    if (selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userType', isEqualTo: 2)
          .get();

      final List<String> userDocumentIds =
          userSnapshot.docs.map((doc) => doc.id).toList();

      List<String> availableUserIds = [];
      for (String userId in userDocumentIds) {
        QuerySnapshot existingBooking = await FirebaseFirestore.instance
            .collection('Bookings')
            .where('bookingTime', isEqualTo: selectedTimeSlot)
            .where('userId', isEqualTo: userId)
            .get();
        if (existingBooking.docs.isEmpty) {
          availableUserIds.add(userId);
        }
      }

      if (availableUserIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No available users for booking')),
        );
        return;
      }

      var randomDocIndex = Random().nextInt(availableUserIds.length);
      var userId = availableUserIds[randomDocIndex];

      await FirebaseFirestore.instance.collection('Bookings').add({
        'bookingTime': selectedTimeSlot,
        'userName': Globals.currentUsername,
        'userId': userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking created successfully')),
      );
    } catch (error) {
      print('Error creating booking: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking')),
      );
    }
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Booking"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Time Slot:'),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedTimeSlot,
                    onChanged: (value) {
                      setState(() {
                        selectedTimeSlot = value;
                      });
                    },
                    items: timeSlots.map((timeSlot) {
                      return DropdownMenuItem<String>(
                        value: timeSlot,
                        child: Text(timeSlot),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _createBooking,
                    child: Text('Book Appointment'),
                  ),
                ],
              ),
            ),
    );
  }
}

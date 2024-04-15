import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobhs/globals.dart';
import 'dart:math';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class CreateBookingPage extends StatefulWidget {
  @override
  _CreateBookingPageState createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  String? selectedTimeSlot;
  List<String> timeSlots = [];
  bool isLoading = true;
  Map<String, List<Map<String, dynamic>>> userBookings = {};

  @override
  void initState() {
    super.initState();
    _fetchTimeSlots();
    _fetchUserBookings();
  }

  Future<void> _fetchTimeSlots() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot timesDocument = await FirebaseFirestore.instance
          .collection('Bookings')
          .doc('TIMES')
          .get();

      Map<String, dynamic>? data =
          timesDocument.data() as Map<String, dynamic>?;

      if (data != null) {
        List<dynamic>? selectedDays = data['selectedDays'] as List<dynamic>?;

        if (selectedDays != null) {
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
                timeSlots.add(timeSlot);
              }
            }
          }
        }
      }

      setState(() {
        selectedTimeSlot = timeSlots.isNotEmpty ? timeSlots[0] : null;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching time slots: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserBookings() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userType', isEqualTo: 2)
          .get();

      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        String userId = userDoc.id;
        QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
            .collection('Bookings')
            .where('userId', isEqualTo: userId)
            .get();
        userBookings[userId] = bookingSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    } catch (error) {
      print('Error fetching user bookings: $error');
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

      // Assign weights based on the number of bookings
      Map<String, double> userWeights = {};
      for (String userId in availableUserIds) {
        double weight = 1 /
            pow(userBookings[userId]!.length + 1, 4); // Exponential weighting
        userWeights[userId] = weight;
      }

      // Sort availableUserIds based on weights
      availableUserIds
          .sort((a, b) => userWeights[b]!.compareTo(userWeights[a]!));

      var userId = availableUserIds.first;

      // Create booking document
      DocumentReference bookingRef =
          await FirebaseFirestore.instance.collection('Bookings').add({
        'bookingTime': selectedTimeSlot,
        'userName': Globals.currentUsername,
        'userId': userId,
      });

      // Update user document with booking ID
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'bookingIds': FieldValue.arrayUnion([bookingRef.id]),
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
        backgroundColor: darkBlue,
      ),
      backgroundColor: darkBlue,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: darkBlue,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Time Slot:',
                    style: TextStyle(color: Colors.white),
                  ),
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
                        child: Text(
                          timeSlot,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: darkBlue,
                    ),
                    dropdownColor: darkBlue,
                    isExpanded: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _createBooking,
                    child: Text(
                      'Book Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: lightBlue,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

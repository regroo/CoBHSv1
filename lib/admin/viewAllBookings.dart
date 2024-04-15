import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class ViewAllBookings extends StatefulWidget {
  @override
  _ViewAllBookingsState createState() => _ViewAllBookingsState();
}

class _ViewAllBookingsState extends State<ViewAllBookings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _bookings = [];
  bool _isLoading = true;
  String _selectedDay = ''; // Initialize selected day

  // Define list of days of the week
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = daysOfWeek[DateTime.now().weekday - 1];
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      DateTime now = DateTime.now();
      DateTime selectedDate = now;
      for (int i = 0; i < daysOfWeek.length; i++) {
        if (daysOfWeek[i] == _selectedDay) {
          selectedDate = now.add(Duration(days: i));
          break;
        }
      }
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

      QuerySnapshot snapshot = await _firestore
          .collection('Bookings')
          .where('bookingTime',
              isGreaterThanOrEqualTo: '$formattedDate 00:00',
              isLessThanOrEqualTo: '$formattedDate 23:59')
          .get();

      setState(() {
        _bookings = snapshot.docs;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching bookings: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int bookingCount = _bookings.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: _selectedDay,
              onChanged: (newValue) {
                setState(() {
                  _selectedDay = newValue!;
                  _fetchBookings();
                });
              },
              items: daysOfWeek.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(
                    day,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              dropdownColor:
                  darkBlue, // Set background color of the dropdown menu
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(), // Remove the default underline
            ),
            Text(
              'Total Bookings: $bookingCount',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        color: darkBlue,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(lightBlue),
                ),
              )
            : _bookings.isNotEmpty
                ? ListView.builder(
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> bookingData =
                          _bookings[index].data() as Map<String, dynamic>;
                      return Card(
                        color: darkBlue, // Set background color of the card
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            'Student User Name: ${bookingData['userName']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Booking Time: ${bookingData['bookingTime']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No bookings for today!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
      ),
    );
  }
}

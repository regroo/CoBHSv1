import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color darkBlue = Color(0xff555dbe);
const Color lightBlue = Color(0xFF8C9EFF);

class SetBookingTimes extends StatefulWidget {
  @override
  _SetBookingTimesState createState() => _SetBookingTimesState();
}

class _SetBookingTimesState extends State<SetBookingTimes> {
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> startTimes = ['08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM'];
  List<String> endTimes = ['05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM'];
  List<String> selectedDays = [];
  String selectedStartTime = '08:00 AM';
  String selectedEndTime = '05:00 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text("Set Booking Times"),
      ),
      body: Container(
        color: darkBlue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select start and end times:',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedStartTime,
                      onChanged: (value) {
                        setState(() {
                          selectedStartTime = value!;
                        });
                      },
                      items: startTimes.map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      dropdownColor:
                          darkBlue, // Set dropdown menu background color
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedEndTime,
                      onChanged: (value) {
                        setState(() {
                          selectedEndTime = value!;
                        });
                      },
                      items: endTimes.map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      dropdownColor:
                          darkBlue, // Set dropdown menu background color
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select days of the week:',
                style: TextStyle(color: Colors.white),
              ),
              Wrap(
                children: daysOfWeek.map((day) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: selectedDays.contains(day),
                        onChanged: (value) {
                          setState(() {
                            if (value != null && value) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                          });
                        },
                      ),
                      Text(day, style: TextStyle(color: Colors.white)),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveBookingTimes();
                },
                child: Text('Save Booking Times',
                    style: TextStyle(color: darkBlue)),
                style: ElevatedButton.styleFrom(
                  primary: lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBookingTimes() async {
    try {
      await FirebaseFirestore.instance.collection('Bookings').doc('TIMES').set({
        'selectedDays': selectedDays,
        'selectedStartTime': selectedStartTime,
        'selectedEndTime': selectedEndTime,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Booking times saved successfully',
                style: TextStyle(color: darkBlue))),
      );
    } catch (error) {
      print('Error saving booking times: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to save booking times',
                style: TextStyle(color: darkBlue))),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import '../../widget/Chart/columChart.dart';
import '../../widget/Calender/calenderDays.dart';
import '../../color/appColors.dart';
import '../../widget/ProgressBar/customeProgressBar.dart';
import '../../widget/ProgressBar/multipleProgressBar.dart';
import '../../widget/ProgressBar/segmentedProgressBar.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;

  CalendarScreen({required this.userId});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, Map<String, dynamic>> statistics = {
    DateTime(2024, 4, 19): {
      'steps': 5000,
      'distance': '3.5 km',
      'activeTime': '2h',
    },
    DateTime(2024, 4, 20): {
      'steps': 7000,
      'distance': '5.2 km',
      'activeTime': '3h',
    },
    DateTime(2024, 4, 21): {
      'steps': 4500,
      'distance': '4.0 km',
      'activeTime': '2.5h',
    },
    DateTime(2024, 4, 22): {
      'steps': 6000,
      'distance': '4.8 km',
      'activeTime': '2h',
    },
    DateTime(2024, 2, 23): {
      'steps': 8000,
      'distance': '6.2 km',
      'activeTime': '3.5h',
    },
    DateTime(2024, 2, 24): {
      'steps': 5500,
      'distance': '4.5 km',
      'activeTime': '2h',
    },
    DateTime(2024, 2, 25): {
      'steps': 6500,
      'distance': '5.0 km',
      'activeTime': '3h',
    },
  };

  DateTime selectedDate = DateTime.now();
  Map<String, dynamic> selectedStatistics = {};

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime lastDay = today.subtract(Duration(days: 6));
    return Scaffold(
      drawer: const SidePanel(),
      appBar: TopNavBar(
        title: 'DAILY STATISTICS',
        trailingIcon1: Icons.calendar_month_outlined,
        trailingIcon2: Icons.share,
        trailingOnPressed1: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 5.0,
          bottom: 0.0,
          left: 18.0,
          right: 18.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CalendarDays(
                    lastDay: DateTime.now(),
                    onSelectDate: (DateTime selectedDate) {
                      setState(() {
                        this.selectedDate = selectedDate;
                        this.selectedStatistics =
                            statistics[selectedDate] ?? {};
                      });
                    },
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explored',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              MultipleProgressBar(
                cityName: ['Stuttgart', 'Heilbronn'],
                cityProgress: [1.2, 1.0],
                progressList: [0.2, 0.1],
                backgroundColors: [
                  const Color.fromARGB(255, 205, 205, 205),
                  const Color.fromARGB(255, 205, 205, 205),
                ],
                progressColors: [
                  const Color.fromARGB(255, 42, 210, 48),
                  const Color.fromARGB(255, 42, 210, 48),
                ],
                cityDetails: {},
              ),
              SizedBox(height: 10),
              SegmentedProgressBar(
                progressList: [0.4, 0.3, 0.2],
                segmentColors: [
                  const Color.fromARGB(255, 0, 140, 254),
                  Color.fromARGB(255, 0, 0, 255),
                  const Color.fromARGB(255, 140, 0, 255),
                ],
                title: 'Travled by',
                labels: ['Train', 'Bike', 'Car'],
                icons: [Icons.train, Icons.pedal_bike, Icons.car_rental],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: _buildStatistics(selectedDate, selectedStatistics),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(DateTime date, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Steps',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (stats.isNotEmpty) ...[
          Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
          Text('Steps: ${stats['steps'] ?? 'N/A'}'),
          Text('Distance: ${stats['distance'] ?? 'N/A'}'),
          Text('Active Time: ${stats['activeTime'] ?? 'N/A'}'),
          SizedBox(height: 20),
          Text(
            'Hourly Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Distance: ${stats['distance'] ?? 'N/A'}'),
          SizedBox(height: 10),
          SizedBox(height: 200, child: ColumnChart()),
          Text('Distance: ${stats['distance'] ?? 'N/A'}'),
        ] else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(height: 200, width: 500, child: ColumnChart()),
          ),
      ],
    );
  }
}

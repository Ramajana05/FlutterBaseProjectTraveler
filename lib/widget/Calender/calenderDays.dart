import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDays extends StatelessWidget {
  final DateTime lastDay;
  final Function(DateTime) onSelectDate;

  const CalendarDays({
    Key? key,
    required this.lastDay,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 6;
            i >= 0;
            i--) // Iterate from 6 (last day) to 0 (current day)
          Column(
            children: [
              Text(
                '${DateFormat('E').format(lastDay.subtract(Duration(days: i)))}', // Subtract i days from the last day
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  // Handle date selection
                  onSelectDate(lastDay.subtract(
                      Duration(days: i))); // Subtract i days from the last day
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${DateFormat('d').format(lastDay.subtract(Duration(days: i)))}', // Subtract i days from the last day
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

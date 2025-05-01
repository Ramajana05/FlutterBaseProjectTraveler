import '../../widget/ListView/RecentVisitedPlacesListView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentVisitedPlacesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> places;

  const RecentVisitedPlacesScreen({Key? key, required this.places})
    : super(key: key);

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.isAfter(today)) {
      return "Today";
    } else if (dateTime.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  String formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedPlaces = List.from(places);
    sortedPlaces.sort(
      (a, b) => DateTime.parse(
        b['timestamp'],
      ).compareTo(DateTime.parse(a['timestamp'])),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Recent Visited Places')),
      body: ListView.builder(
        itemCount: sortedPlaces.length,
        itemBuilder: (context, index) {
          final place = sortedPlaces[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            typeIcons[place['type']] ?? Icons.location_on,
                            color: typeColors[place['type']] ?? Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Text(
                            place['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatTimestamp(place['timestamp'] ?? ''),
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place['city'] ?? '',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          Text(
                            place['longitude'] ?? '',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          Text(
                            place['latitude'] ?? '',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        formatTime(place['timestamp'] ?? ''),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

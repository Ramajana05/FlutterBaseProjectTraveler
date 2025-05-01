import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Map<String, IconData> typeIcons = {
  'Building': Icons.business,
  'Highway': Icons.directions_car,
  'Leisure': Icons.local_play,
  'Landuse': Icons.landscape,
  'Natural': Icons.nature,
  'Amenity': Icons.local_cafe,
  'Waterway': Icons.water,
  'Railway': Icons.train,
  'Tree': Icons.park,
};

final Map<String, Color> typeColors = {
  'Building': Colors.grey,
  'Highway': Colors.black,
  'Leisure': Colors.orange,
  'Landuse': Colors.brown,
  'Natural': Colors.green,
  'Amenity': Colors.blue,
  'Waterway': Colors.lightBlue,
  'Railway': Colors.red,
  'Tree': Colors.green,
};

class RecentVisitedPlacesListView extends StatelessWidget {
  final List<Map<String, dynamic>> places;

  const RecentVisitedPlacesListView({
    Key? key,
    required this.places,
  }) : super(key: key);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final place in places)
          Card(
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
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            place['longitude'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            place['latitude'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formatTime(place['timestamp'] ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

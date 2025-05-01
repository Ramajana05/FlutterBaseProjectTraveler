import 'dart:math';
import 'package:flutter/material.dart';
import '../color/appcolors.dart';

class FriendListItem extends StatelessWidget {
  final String friendName;
  final String cityName;
  final String countryName;
  final double distance;

  const FriendListItem({
    required this.friendName,
    required this.cityName,
    required this.countryName,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    String formattedDistance = _formatDistance(distance);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? null
          : background,
      child: ListTile(
        contentPadding: EdgeInsets.all(6),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Icon(
              Icons.person,
              color: randomColor,
              size: 50,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          friendName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$cityName, $countryName',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$formattedDistance  ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _showFriendDetails(friendName);
        },
      ),
    );
  }

  void _showFriendDetails(String friendName) {}

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }
}

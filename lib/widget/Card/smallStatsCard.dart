import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class SmallStatsCard extends StatelessWidget {
  final String value;
  final dynamic icon;
  final String title;
  final BuildContext context;

  const SmallStatsCard({
    Key? key,
    required this.value,
    required this.icon,
    required this.title,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        child: Card(
          elevation: 2,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon is IconData
                          ? Icon(
                              icon,
                              size: 36,
                            )
                          : icon,
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  const CustomProgressBar({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBarWidth = screenWidth / 2; // 1/3 of the screen width

    return Container(
      width: progressBarWidth,
      height: 20.0,
      child: Stack(
        children: [
          Container(
            width: progressBarWidth,
            height: 20.0,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              height: 20.0,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

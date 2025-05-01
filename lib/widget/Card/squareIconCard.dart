import 'package:flutter/material.dart';

class SquareIconCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color iconColor;

  const SquareIconCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  _SquareIconCardState createState() => _SquareIconCardState();
}

class _SquareIconCardState extends State<SquareIconCard> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 30,
                color: widget.iconColor,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

class CircularLoadingIndicator extends StatefulWidget {
  final String loadingText;
  final String? time;
  final VoidCallback? onTimerDone;

  const CircularLoadingIndicator({
    Key? key,
    required this.loadingText,
    this.time,
    this.onTimerDone,
  }) : super(key: key);

  @override
  _CircularLoadingIndicatorState createState() =>
      _CircularLoadingIndicatorState();
}

class _CircularLoadingIndicatorState extends State<CircularLoadingIndicator> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer(duration, () {
      if (widget.onTimerDone != null) {
        widget.onTimerDone!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0), // Adjust the padding as needed
      child: Row(
        children: [
          SizedBox(
            width:
                20, // Adjust size of the container according to your preference
            height:
                20, // Adjust size of the container according to your preference
            child: CircularProgressIndicator(
              strokeWidth: 3, // Adjust thickness of the circle
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color of the circle
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.loadingText,
                style:
                    TextStyle(fontSize: 14, color: Colors.white), // Text color
              ),
              if (widget.time != null)
                Text(
                  widget.time!,
                  style: TextStyle(
                      fontSize: 14, color: Colors.white), // Text color
                ),
            ],
          ),
        ],
      ),
    );
  }
}

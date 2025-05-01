import 'package:flutter/material.dart';

class BigStatsCard extends StatefulWidget {
  final Widget iconSmall;
  final String title;
  final String belowTitle;
  final BuildContext context;

  const BigStatsCard({
    Key? key,
    required this.iconSmall,
    required this.title,
    required this.belowTitle,
    required this.context,
  }) : super(key: key);

  @override
  _BigStatsCardState createState() => _BigStatsCardState();
}

class _BigStatsCardState extends State<BigStatsCard> {
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    final Color iconColor = brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0);

    return Flexible(
      child: GestureDetector(
        child: Card(
          elevation: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.iconSmall is Icon
                              ? Icon(
                                  (widget.iconSmall as Icon).icon,
                                  size: 29,
                                  color: iconColor,
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      iconColor, BlendMode.srcIn),
                                  child: widget.iconSmall,
                                ),
                          SizedBox(width: 10),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.belowTitle,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

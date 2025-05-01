import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  final List<double> progressList;
  final List<Color> segmentColors;
  final String title;
  final List<String> labels;
  final List<IconData> icons;

  const SegmentedProgressBar({
    required this.progressList,
    required this.segmentColors,
    required this.title,
    required this.labels,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBarWidth = screenWidth * 0.8; // Adjust width as needed

    // Calculate the width factors for each segment based on progress values
    List<double> widthFactors = [];
    double totalProgress = progressList.reduce((a, b) => a + b);
    for (int i = 0; i < progressList.length; i++) {
      widthFactors.add(progressList[i] / totalProgress);
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white60,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10.0, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: progressBarWidth,
            height: 20.0,
            child: Stack(
              children: List.generate(progressList.length, (index) {
                double leftPosition = index == 0
                    ? 0
                    : widthFactors.sublist(0, index).reduce((a, b) => a + b) *
                        progressBarWidth;
                double width = widthFactors[index] * progressBarWidth;
                return Positioned(
                  left: leftPosition,
                  width: width,
                  child: Container(
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: segmentColors[index],
                      borderRadius: index == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            )
                          : (index == progressList.length - 1)
                              ? BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                )
                              : null,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < 3; i++)
                    if (i < icons.length && i < labels.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(
                                icons[i],
                                size: 25.0,
                                color: segmentColors[i],
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                labels[i],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 3; i < 6; i++)
                    if (i < icons.length && i < labels.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(
                                icons[i],
                                size: 25.0,
                                color: segmentColors[i],
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                labels[i],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

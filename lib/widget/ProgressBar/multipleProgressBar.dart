import 'package:flutter/material.dart';

class MultipleProgressBar extends StatefulWidget {
  final List<double> progressList;
  final List<Color> backgroundColors;
  final List<Color> progressColors;
  final List<String> cityName;
  final List<double> cityProgress;
  final Map<String, Map<String, double>> cityDetails;

  const MultipleProgressBar({
    required this.progressList,
    required this.backgroundColors,
    required this.progressColors,
    required this.cityName,
    required this.cityProgress,
    required this.cityDetails,
  });

  @override
  _MultipleProgressBarState createState() => _MultipleProgressBarState();
}

class _MultipleProgressBarState extends State<MultipleProgressBar> {
  late List<bool> _showDetails;

  @override
  void initState() {
    super.initState();
    _showDetails = List<bool>.filled(widget.cityName.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBarWidth = screenWidth * 0.9;

    return Container(
      width: progressBarWidth,
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.transparent
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.progressList.length, (index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showDetails[index] = !_showDetails[index];
                  });
                },
                child: Card(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(widget.cityName[index]),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: widget.backgroundColors[index],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: widget.progressList[index],
                                    child: Container(
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: widget.progressColors[index],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${(widget.progressList[index] * 100).toInt()}%',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_showDetails[index])
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  widget.cityDetails[widget.cityName[index]] !=
                                          null
                                      ? widget
                                          .cityDetails[widget.cityName[index]]!
                                          .entries
                                          .map((entry) {
                                          return _buildDetailProgressBar(
                                              entry.key, entry.value);
                                        }).toList()
                                      : [],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailProgressBar(String label, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.location_city, size: 20.0),
          SizedBox(width: 10.0),
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: 15.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Text(label),
        ],
      ),
    );
  }
}

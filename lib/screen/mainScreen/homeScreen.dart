import 'dart:math';
import '../../color/appColors.dart';
import '../../screen/otherScreen/notificationScreen.dart';
import '../../screen/otherScreen/recentVisitedPlacesScreen.dart';
import '../../widget/Card/bigStatsCard.dart';
import '../../widget/Card/smallStatsCard.dart';
import '../../widget/Card/squareIconCard.dart';
import '../../widget/ListView/RecentVisitedPlacesListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../provider/locationProvider.dart';
import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import 'discoverScreen.dart';
import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import '../../model/friendListItem.dart';
import '../../logic/userBackendService.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId}) {
    print('HOME SCREEN INIIALIDES WITH ID: $userId');
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  LocationProvider locationProvider = LocationProvider();
  String cityNameAndCountryName = '';
  String latAndLongName = '';
  late double _lastLatitude;
  late double _lastLongitude;
  late Timer _checkIfNotMovingTimer;

  // Step Counter logic
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _stepCount = 0;

  List<String> squares = ['Square 1', 'Square 2', 'Square 3'];
  List<String> selectedSquares = [];
  Map<String, Color> squareColors = {
    'Square 1': Colors.red,
    'Square 2': Colors.green,
    'Square 3': Colors.blue,
  };

  final List<Map<String, dynamic>> cardData = [
    {
      'text': '400m',
      'iconColor': Colors.blue,
      'backgroundColor': Colors.blue.withOpacity(0.1),
    },
    {
      'text': '3km',
      'iconColor': const Color.fromARGB(255, 210, 17, 244),
      'backgroundColor': const Color.fromARGB(
        255,
        210,
        17,
        244,
      ).withOpacity(0.1),
    },
    {
      'text': '21km',
      'iconColor': Color.fromARGB(219, 0, 255, 0),
      'backgroundColor': Color.fromARGB(219, 0, 255, 0).withOpacity(0.1),
    },
    {
      'text': '42km',
      'iconColor': Color.fromARGB(255, 255, 0, 0),
      'backgroundColor': Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
    },
    {
      'text': '397km',
      'iconColor': Colors.blue,
      'backgroundColor': Colors.blue.withOpacity(0.1),
    },
  ];

  bool showAllPlaces = false;
  List<Map<String, dynamic>> places = [
    {
      'name': 'Berlin Central Station',
      'city': 'Berlin',
      'longitude': '13.3695',
      'latitude': '52.5251',
      'type': 'Building',
      'timestamp':
          DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
    },
    {
      'name': 'Brandenburg Gate',
      'city': 'Berlin',
      'longitude': '13.3777',
      'latitude': '52.5163',
      'type': 'Leisure',
      'timestamp':
          DateTime.now()
              .subtract(Duration(days: 1, hours: 3))
              .toIso8601String(),
    },
    {
      'name': 'A100 Highway',
      'city': 'Berlin',
      'longitude': '13.4350',
      'latitude': '52.4900',
      'type': 'Highway',
      'timestamp': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    },
    {
      'name': 'Tiergarten Park',
      'city': 'Berlin',
      'longitude': '13.3501',
      'latitude': '52.5145',
      'type': 'Natural',
      'timestamp':
          DateTime.now().subtract(Duration(hours: 10)).toIso8601String(),
    },
    {
      'name': 'Coffee Fellows',
      'city': 'Berlin',
      'longitude': '13.3924',
      'latitude': '52.5208',
      'type': 'Amenity',
      'timestamp':
          DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
    },
    {
      'name': 'Spree River',
      'city': 'Berlin',
      'longitude': '13.4050',
      'latitude': '52.5200',
      'type': 'Waterway',
      'timestamp': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
    },
    {
      'name': 'Alexanderplatz Station',
      'city': 'Berlin',
      'longitude': '13.4132',
      'latitude': '52.5219',
      'type': 'Railway',
      'timestamp':
          DateTime.now()
              .subtract(Duration(days: 3, hours: 5))
              .toIso8601String(),
    },
    {
      'name': 'Old Oak Tree',
      'city': 'Berlin',
      'longitude': '13.3765',
      'latitude': '52.5140',
      'type': 'Tree',
      'timestamp':
          DateTime.now()
              .subtract(Duration(days: 1, hours: 1))
              .toIso8601String(),
    },
  ];

  bool isLoading = true;

  void onSelect(String square) {
    setState(() {
      if (selectedSquares.contains(square)) {
        selectedSquares.remove(square);
      } else {
        selectedSquares.add(square);
      }
    });
  }

  String _steps = '0';
  String _pedestrianStatus = 'stopped';

  bool _permissionGranted = false;

  String _unit = 'Steps';

  Timer? _resetStepsTimer;
  Timer? _hourlyUpdateTimer;

  @override
  void initState() {
    super.initState();
    _lastLatitude = 0.0;
    _lastLongitude = 0.0;
    initPlatformState();
    _checkLocationStatus();
    _startResetStepsTimer();
    _startHourlyUpdateTimer();
    _startLocationCheckTimer();
  }

  @override
  void dispose() {
    _resetStepsTimer?.cancel();
    _hourlyUpdateTimer?.cancel();
    _timer?.cancel();
    _checkIfNotMovingTimer?.cancel();
    super.dispose();
  }

  void _startResetStepsTimer() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      final now = DateTime.now();

      if (now.hour == 5 && now.minute == 37) {
        setState(() {
          _unit = '0';
        });
      }
    });
  }

  void _startHourlyUpdateTimer() {
    _hourlyUpdateTimer = Timer.periodic(Duration(hours: 1), (timer) {});
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(err) {
    print('Error occurred');
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('Event occurred: $event.toString()');
    setState(() {
      _pedestrianStatus = event.status.toString();
    });
  }

  void onPedestrianStatusError(err) {
    print('Error occurred: $err');
    setState(() {
      _pedestrianStatus = 'unknown';
    });
  }

  Future<bool> checkPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void initPlatformState() async {
    if (await checkPermission()) {
      setState(() {
        _permissionGranted = true;
      });

      setState(() {
        _stepCountStream = Pedometer.stepCountStream;
        _stepCountStream.listen(onStepCount).onError(onStepCountError);

        _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
        _pedestrianStatusStream
            .listen(onPedestrianStatusChanged)
            .onError(onPedestrianStatusError);
      });
    }

    if (!mounted) return;
  }

  String convertStepsTo(String unit) {
    switch (unit) {
      case 'Kilometers':
        return (int.parse(_steps) / 1300).toStringAsFixed(1);
      case 'Meters':
        return (int.parse(_steps) / 1.3).toStringAsFixed(1);
      case 'Centimeters':
        return (int.parse(_steps) / 0.013).toStringAsFixed(1);
      case 'Inches':
        return (int.parse(_steps) / 0.03).toStringAsFixed(1);
      case 'Feet':
        return (int.parse(_steps) / 0.4).toStringAsFixed(1);
      case 'Yard':
        return (int.parse(_steps) / 1.2).toStringAsFixed(1);
      case 'Miles':
        return (int.parse(_steps) / 2100).toStringAsFixed(1);
    }

    return _steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidePanel(),
      appBar: TopNavBar(
        title: 'TRAVELER',
        trailingIcon1: Icons.notifications_outlined,
        trailingIcon2: Icons.mail_outline,
        trailingOnPressed1: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 0.0,
          left: 18.0,
          right: 18.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      cardData.map<Widget>((data) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SquareIconCard(
                            icon: Icons.person,
                            text: data['text'],
                            iconColor: data['iconColor'],
                            backgroundColor: data['backgroundColor'],
                          ),
                        );
                      }).toList(),
                ),
              ),
              Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          BigStatsCard(
                            iconSmall: Image.asset(
                              'assets/icons/pin2.png', // Replace with your asset path
                              width: 25,
                              height: 25,
                            ),
                            title: '$cityNameAndCountryName',
                            belowTitle: '$latAndLongName',
                            context: context,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SmallStatsCard(
                            value: convertStepsTo(_unit),
                            icon: Icons.directions_walk,
                            title:
                                _unit == 'Steps'
                                    ? 'Total Steps'
                                    : 'Total Distance Walked',
                            context: context,
                          ),
                          SmallStatsCard(
                            value: '${convertStepsTo('Kilometers')} km',
                            icon: Icons.social_distance_sharp,
                            title: 'Total Distance',
                            context: context,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Visited Places',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RecentVisitedPlacesScreen(places: places),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text('See all', style: TextStyle(fontSize: 14)),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Column(
                children:
                    places.take(3).map((place) {
                      return ListTile(
                        leading: Icon(Icons.place),
                        title: Text(place['name']),
                        subtitle: Text('${place['city']} - ${place['type']}'),
                        trailing: Text(
                          DateFormat(
                            'dd MMM',
                          ).format(DateTime.parse(place['timestamp'])),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startLocationCheckTimer() {
    _checkLocationStatus();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkLocationStatus();
    });
  }

  void _checkLocationStatus() async {
    bool permissionGranted = await Permission.location.isGranted;

    if (!permissionGranted) {
      setState(() {
        cityNameAndCountryName = 'Where are you?';
        latAndLongName = 'Turn your Location on';
      });
      return;
    }

    if (locationProvider.location == null) {
      setState(() {});
    } else {
      String latitude = locationProvider.location.latitude.toString();
      String longitude = locationProvider.location.longitude.toString();
      String cityName = locationProvider.location.cityName;
      String countryName = locationProvider.location.countryCode;

      setState(() {
        cityNameAndCountryName = '$cityName, ${countryName.toUpperCase()}';
        latAndLongName = '$latitude, $longitude';
        if (latitude == '0.0' ||
            latitude.isEmpty ||
            longitude == '0.0' ||
            longitude.isEmpty) {
          cityNameAndCountryName = 'Where are you?';
          latAndLongName = 'Turn your Location on';
        }
      });
      _lastLatitude = double.parse(latitude);
      _lastLongitude = double.parse(longitude);
    }
  }

  Widget _buildRecentVisitedPlacesSection() {
    List<Map<String, dynamic>> sortedPlaces = List.from(places);
    sortedPlaces.sort(
      (a, b) => DateTime.parse(
        b['timestamp'],
      ).compareTo(DateTime.parse(a['timestamp'])),
    );

    final latestPlaces = sortedPlaces.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: latestPlaces.length,
          itemBuilder: (context, index) {
            final place = latestPlaces[index];
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
            );
          },
        ),
      ],
    );
  }

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
}

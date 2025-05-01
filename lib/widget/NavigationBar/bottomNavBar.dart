import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Add this import
import '../../screen/mainScreen/calendarScreen.dart';
import '../../screen/mainScreen/homeScreen.dart';
import '../../screen/mainScreen/discoverScreen.dart';
import '../../screen/mainScreen/profilepage.dart';
import '../../screen/mainScreen/mapScreen.dart';
import '../../color/appColors.dart'; // Update import for the correct colors

class CustomBottomTabBar extends StatefulWidget {
  int index = 0;
  final String username;
  final String userId;

  CustomBottomTabBar(
      {int trans_index = 0, required this.username, required this.userId}) {
    index = trans_index;
  }

  @override
  State<CustomBottomTabBar> createState() => _CustomBottomTabBarState();
}

class _CustomBottomTabBarState extends State<CustomBottomTabBar> {
  late List<Widget> screens;
  double? currentLatitude;
  double? currentLongitude;

  List<dynamic> navIcons = [
    Icons.home_outlined,
    Icons.search,
    'assets/icons/pin2.png',
    Icons.bar_chart,
    Icons.person_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((position) {
      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
        screens = [
          HomeScreen(userId: widget.userId),
          DiscoverScreen(
              currentLatitude: currentLatitude!,
              currentLongitude: currentLongitude!,
              loggedInUserId: widget.userId),
          MapScreen(),
          CalendarScreen(userId: widget.userId),
          ProfilePage(username: widget.username),
        ];
      });
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLatitude == null || currentLongitude == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget selectedScreen = screens[widget.index];

    return Scaffold(
      extendBody: true,
      body: selectedScreen,
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.only(
          right: 15,
          left: 15,
          bottom: 17,
        ),
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color.fromARGB(44, 255, 254, 254)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 1, 1, 1),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: navIcons.map((icon) {
            int index = navIcons.indexOf(icon);
            bool isSelected = widget.index == index;
            return Material(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.transparent
                      : Colors.white,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.index = index;
                  });
                },
                child: Card(
                  color: isSelected
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Color.fromRGBO(255, 255, 255, 0.064)
                          : Colors.white
                      : MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.transparent
                          : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: isSelected ? 3 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: icon is IconData
                        ? Icon(
                            icon,
                            color: isSelected
                                ? logoPurple
                                : MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : null,
                          )
                        : Image.asset(
                            icon,
                            width: 25,
                            height: 25,
                            color: isSelected
                                ? logoPurple
                                : MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : null,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

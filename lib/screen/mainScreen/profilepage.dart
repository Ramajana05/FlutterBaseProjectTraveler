import 'dart:io';
import 'dart:math';

import '../../provider/locationProvider.dart';
import '../../screen/otherScreen/followerAndFriendsScreen.dart';
import '../../screen/otherScreen/loginScreen.dart';
import '../../widget/Card/squareIconCard.dart';
import '../../widget/ProgressBar/multipleProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import '../../widget/ProgressBar/customeProgressBar.dart';
import '../../color/appcolors.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Image? _selectedImage;
  LocationProvider locationProvider = LocationProvider();

  final List<Map<String, dynamic>> cardData = [
    {
      'text': '',
      'iconColor': Colors.blue,
      'backgroundColor': Colors.blue.withOpacity(0.1),
    },
    {
      'text': '',
      'iconColor': const Color.fromARGB(255, 217, 0, 255),
      'backgroundColor': const Color.fromARGB(
        255,
        217,
        4,
        255,
      ).withOpacity(0.1),
    },
    {
      'text': '',
      'iconColor': Colors.red,
      'backgroundColor': Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
    },
    {
      'text': '',
      'iconColor': Color.fromARGB(255, 17, 255, 0),
      'backgroundColor': Colors.green.withOpacity(0.1),
    },
    {
      'text': '',
      'iconColor': Color.fromARGB(255, 255, 119, 0),
      'backgroundColor': Color.fromARGB(255, 255, 106, 0).withOpacity(0.1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    String cityName = locationProvider.location.cityName;
    String countryName = locationProvider.location.countryCode;
    return Scaffold(
      drawer: const SidePanel(),
      appBar: TopNavBar(
        title: 'PROFILE',
        trailingIcon2: Icons.logout,
        trailingOnPressed2: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Stuttgart, DE', // Your active time value here
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _onProfilePictureClicked,
                            child: Container(
                              width: 120,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image:
                                      _selectedImage != null
                                          ? _selectedImage!.image
                                          : AssetImage('assets/Darkmode.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildSquareWithNumber(
                                    label: 'Friends',
                                    number: 100,
                                    onPressed: () {
                                      print('Friends clicked');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  FollowerAndFriendsScreen(
                                                    trans_index: 0,
                                                  ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildSquareWithNumber(
                                    label: 'Following',
                                    number: 50,
                                    onPressed: () {
                                      print('Following clicked');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  FollowerAndFriendsScreen(
                                                    trans_index: 1,
                                                  ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 90,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text('See all', style: TextStyle(fontSize: 14)),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                MultipleProgressBar(
                  cityName: [
                    'Stuttgart',
                    'Ludwigsburg',
                    'München',
                    'Berlin',
                    'Heilbronn',
                  ],
                  cityProgress: [1.2, 4.0, 4.0, 4.0, 4.0],
                  progressList: [0.8, 0.66, 0.55, 0.39, 0.20],
                  backgroundColors: [
                    const Color.fromARGB(255, 205, 205, 205),
                    const Color.fromARGB(255, 205, 205, 205),
                    const Color.fromARGB(255, 205, 205, 205),
                    const Color.fromARGB(255, 205, 205, 205),
                    const Color.fromARGB(255, 205, 205, 205),
                  ], // Example background colors
                  progressColors: [
                    const Color.fromARGB(255, 42, 210, 48),
                    const Color.fromARGB(255, 42, 210, 48),
                    const Color.fromARGB(255, 42, 210, 48),
                    const Color.fromARGB(255, 42, 210, 48),
                    const Color.fromARGB(255, 42, 210, 48),
                  ],
                  cityDetails: {},
                ),
                SizedBox(height: 20),
                Text(
                  'Traveler Member since 26 Jun 2024',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : Color.fromARGB(255, 181, 181, 181),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSquareWithNumber({
    required String label,
    required int number,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(number.toString(), style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  void _onProfilePictureClicked() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _selectedImage = Image.file(File(pickedImage.path));

        saveImageToDatabase(pickedImage.path);
      });
    }
  }

  void saveImageToDatabase(String imagePath) {}

  Future<String> getLocationName() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String city = placemark.locality ?? '';
        String country = placemark.country ?? '';
        return '$city, $country';
      }
    } catch (e) {
      print('Error retrieving location: $e');
    }
    return '';
  }
}

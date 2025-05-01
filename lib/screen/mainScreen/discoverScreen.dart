import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/User.dart';
import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import '../../model/friendListItem.dart';
import '../otherScreen/cameraScreen.dart';
import '../../logic/locationService.dart';

class DiscoverScreen extends StatefulWidget {
  final double currentLatitude;
  final double currentLongitude;
  final String loggedInUserId;

  DiscoverScreen({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.loggedInUserId,
  });

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late CameraDescription myCamera;
  TextEditingController searchController = TextEditingController();
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    setState(() {
      myCamera = cameras.first;
    });
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.122:3000/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<User> fetchedUsers =
          data.map((json) => User.fromJson(json)).toList();

      for (User user in fetchedUsers) {
        if (user.id != int.parse(widget.loggedInUserId)) {
          final locationService = LocationService();
          final cityCountry = await locationService.getCityAndCountry(
            user.currentLatitude ?? 0.0,
            user.currentLongitude ?? 0.0,
          );
          final updatedUser = user.copyWith(
            cityName: cityCountry['city'],
            countryName: cityCountry['country'],
          );

          setState(() {
            final double distance = calculateDistance(
              widget.currentLatitude,
              widget.currentLongitude,
              updatedUser.currentLatitude ?? 0.0,
              updatedUser.currentLongitude ?? 0.0,
            );

            users.add(updatedUser.copyWith(distance: distance));
            users.sort((a, b) => a.distance.compareTo(b.distance));
            filteredUsers = users.where((user) {
              final query = searchController.text.toLowerCase();
              return user.username != null &&
                  user.username!.toLowerCase().contains(query);
            }).toList();
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3;
    final double phi1 = lat1 * pi / 180;
    final double phi2 = lat2 * pi / 180;
    final double deltaPhi = (lat2 - lat1) * pi / 180;
    final double deltaLambda = (lon2 - lon1) * pi / 180;

    final double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user.username != null &&
            user.username!.toLowerCase().contains(query);
      }).toList();
      filteredUsers.sort((a, b) => a.distance.compareTo(b.distance));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidePanel(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35.0),
            _buildSearchBar(),
            Expanded(
              child: Center(
                child:
                    isLoading ? CircularProgressIndicator() : _buildFriends(),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 40.0,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: TextStyle(fontSize: 14.0, height: 1),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                fillColor:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(camera: myCamera),
                ),
              );
            },
            child: Image.asset(
              'assets/icons/qr.png',
              width: 24,
              height: 24,
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.white
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriends() {
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return FriendListItem(
          friendName: user.username ?? 'Unknown',
          cityName: user.cityName ?? 'Unknown',
          countryName: user.countryName ?? 'Unknown',
          distance: user.distance,
        );
      },
    );
  }
}

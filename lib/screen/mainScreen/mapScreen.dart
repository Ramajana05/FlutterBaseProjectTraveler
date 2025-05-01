import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import '../../widget/LoadingIndicator/circularLoadingIndicator.dart';
import '../../widget/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../widget/NavigationBar/topNavBar.dart';
import '../../widget/sidePanelWidget.dart';
import '../../color/appColors.dart';

import '../../../provider/locationProvider.dart'; // Adjust the path accordingly
import '../../../logic/locationService.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  IconData _selectedIcon = Icons.home;
  final TextEditingController _searchController = TextEditingController();
  bool isVisible = true;
  LocationProvider locationProvider = LocationProvider();
  LocationService locationService = LocationService();

  String? _temperature;
  bool _isGreen = false;
  String _coordinates = '';
  List<String> _suggestions = [];
  Timer? _debounce;

  void _toggleColor() {
    setState(() {
      _isGreen = !_isGreen;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeLocationUpdates();
  }

  void _initializeLocationUpdates() {
    locationProvider.addListener(_getLocation);
    _getLocation();
  }

  void _getLocation() {
    String latitude = locationProvider.location.latitude.toString();
    String longitude = locationProvider.location.longitude.toString();
  }

  Future<void> _searchCity(String city) async {
    final coordinates = await locationService.getCoordinates(city);
    setState(() {
      _coordinates =
          'Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}';
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        final suggestions = await locationService.getCitySuggestions(query);
        setState(() {
          _suggestions = suggestions;
        });
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    locationProvider.removeListener(_getLocation);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.of(context).platformBrightness;
    final Color color =
        platformBrightness == Brightness.dark
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color.fromARGB(255, 0, 0, 0);

    return Scaffold(
      drawer: const SidePanel(),
      appBar: TopNavBar(
        title: 'TRAVELER',
        trailingWidget1: Image.asset(
          'assets/icons/ghost.png',
          width: 24,
          height: 24,
          color: _isGreen ? Colors.green : color,
        ),
        trailingOnPressed1: () {
          _toggleColor();
        },
      ),
      body: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildIconDropdown(),
                      SizedBox(width: 10),
                      Expanded(child: _buildSearchBar()),
                    ],
                  ),
                  _buildSuggestions(),
                ],
              ),
            ),
            Center(
              child: Visibility(
                visible: _coordinates.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _coordinates,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Icon(icon, color: Color.fromARGB(255, 0, 157, 255)),
      ),
    );
  }

  Widget _buildIconDropdown() {
    return PopupMenuButton<IconData>(
      icon: Icon(_selectedIcon, size: 30),
      tooltip: "",
      offset: Offset(0, 50),
      onSelected: (IconData result) {
        setState(() {
          _selectedIcon = result;
        });
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<IconData>>[
            PopupMenuItem<IconData>(
              value: null,
              child: Container(
                width: 200,
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildIcon(Icons.person),
                    _buildIcon(Icons.people),
                    _buildIcon(Icons.wordpress_outlined),
                  ],
                ),
              ),
            ),
          ],
      child: null,
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, icon);
        },
        child: Icon(icon),
      ),
    );
  }

  Widget _buildImageIcon(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, imagePath);
        },
        child: Image.asset(imagePath, width: 24, height: 24),
      ),
    );
  }

  Widget _buildNetworkImageIcon(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, imageUrl);
        },
        child: Image.network(imageUrl, width: 24, height: 24),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: _onSearchChanged,
        onSubmitted: (value) {
          _searchCity(value);
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return _suggestions.isNotEmpty
        ? Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]),
                onTap: () {
                  _searchController.text = _suggestions[index];
                  _searchCity(_suggestions[index]);
                  setState(() {
                    _suggestions = [];
                  });
                },
              );
            },
          ),
        )
        : Container();
  }
}

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../logic/locationService.dart';
import '../model/locationModel.dart';

class LocationProvider with ChangeNotifier {
  LocationService _locationService = LocationService();
  late LocationModel _location;

  LocationModel get location => _location;

  LocationProvider() {
    _location =
        LocationModel(latitude: 0, longitude: 0, cityName: '', countryCode: '');

    _locationService.locationStream.listen((LocationData? locationData) {
      if (locationData != null) {
        _updateLocation(locationData);
      }
    });
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    LocationData? locationData = await _locationService.getLocation();
    if (locationData != null) {
      await _updateLocation(locationData);
    }
  }

  Future<void> _updateLocation(LocationData locationData) async {
    final cityAndCountry = await _locationService.getCityAndCountry(
        locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);

    _location = LocationModel(
      latitude: locationData.latitude ?? 0.0,
      longitude: locationData.longitude ?? 0.0,
      cityName: cityAndCountry['city'] ?? '',
      countryCode: cityAndCountry['country'] ?? '',
    );
    notifyListeners();
  }
}

import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Location _location = Location();

  Future<LocationData?> getLocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData? _locationData;

      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      _locationData = await _location.getLocation();
      return _locationData;
    } catch (e) {
      print('Could not get location: $e');
      return null;
    }
  }

  Stream<LocationData> get locationStream => _location.onLocationChanged;

  Future<Map<String, double>> getCoordinates(String city) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$city&limit=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        double latitude = double.parse(data[0]['lat']);
        double longitude = double.parse(data[0]['lon']);
        return {'latitude': latitude, 'longitude': longitude};
      }
    }
    return {'latitude': 0.0, 'longitude': 0.0};
  }

  Future<List<String>> getCitySuggestions(String query) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=5'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data.map<String>((result) => result['display_name']).toList();
    }
    return [];
  }

  Future<Map<String, String>> getCityAndCountry(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Validate that 'address' exists
      if (data['address'] == null) {
        print("No address data available for lat: $latitude, lon: $longitude");
        return {'city': 'Unknown', 'country': 'Unknown'};
      }

      String city = data['address']['city'] ??
          data['address']['town'] ??
          data['address']['village'] ??
          'Unknown';
      String countryCode = data['address']['country_code'] ?? 'Unknown';

      if (city.startsWith("City of ")) {
        city = city.replaceFirst("City of ", "");
      }

      String country = _getCountryName(countryCode);

      return {'city': city, 'country': country};
    } else {
      print("Failed to fetch location data: HTTP ${response.statusCode}");
      return {'city': 'Unknown', 'country': 'Unknown'};
    }
  }

  String _getCountryName(String countryCode) {
    Map<String, String> countryNames = {
      // Example: Adding some country code-to-name mappings
      'us': 'United States',
      'de': 'Germany',
      'fr': 'France'
    };

    return countryNames[countryCode.toLowerCase()] ?? countryCode.toUpperCase();
  }
}

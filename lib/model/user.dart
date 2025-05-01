class User {
  final int id;
  final String? username;
  final String? email;
  final String? password;
  final String? color;
  final bool visibility;
  final DateTime createdAt;
  final DateTime updateDate;
  final double? currentLatitude;
  final double? currentLongitude;
  final double distance;
  final String? cityName;
  final String? countryName;

  User({
    required this.id,
    this.username,
    this.email,
    this.password,
    this.color,
    required this.visibility,
    required this.createdAt,
    required this.updateDate,
    this.currentLatitude,
    this.currentLongitude,
    this.distance = 0.0,
    this.cityName,
    this.countryName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['UserID'],
      username: json['Username'],
      email: json['Email'],
      password: json['Password'],
      color: json['Color'],
      visibility: json['Visibility'] ?? false,
      createdAt: DateTime.parse(json['CreatedAt']),
      updateDate: DateTime.parse(json['UpdateDate']),
      currentLatitude: json['Current_Latitude'] != null
          ? double.tryParse(json['Current_Latitude'].toString())
          : null,
      currentLongitude: json['Current_Longitude'] != null
          ? double.tryParse(json['Current_Longitude'].toString())
          : null,
      cityName: json['CityName'],
      countryName: json['CountryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': id,
      'Username': username,
      'Email': email,
      'Password': password,
      'Color': color,
      'Visibility': visibility,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdateDate': updateDate.toIso8601String(),
      'Current_Latitude': currentLatitude,
      'Current_Longitude': currentLongitude,
      'CityName': cityName,
      'CountryName': countryName,
    };
  }

  User copyWith({
    double? distance,
    String? cityName,
    String? countryName,
  }) {
    return User(
      id: this.id,
      username: this.username,
      email: this.email,
      password: this.password,
      color: this.color,
      visibility: this.visibility,
      createdAt: this.createdAt,
      updateDate: this.updateDate,
      currentLatitude: this.currentLatitude,
      currentLongitude: this.currentLongitude,
      distance: distance ?? this.distance,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
    );
  }
}

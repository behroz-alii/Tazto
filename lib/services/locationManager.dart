import 'package:tazto/services/saved_location.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();

  factory LocationManager() {
    return _instance;
  }

  LocationManager._internal();

  Map<String, SavedLocation> savedLocations = {};

  void saveLocation(String type, String address, double latitude, double longitude) {
    savedLocations[type] = SavedLocation(
      type: type,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void updateLocations(Map<String, SavedLocation> locations) {
    savedLocations = Map.from(locations);
  }
}
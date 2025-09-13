import 'package:flutter/material.dart';

class SavedLocation {
  final String type;
  String address;
  final double latitude;
  final double longitude;

  SavedLocation({
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String get displayType {
    switch (type) {
      case 'home':
        return 'Home';
      case 'office':
        return 'Office';
      case 'other':
        return 'Other Place';
      default:
        return type;
    }
  }

  IconData get icon {
    switch (type) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.work_outline;
      case 'other':
        return Icons.location_on_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  Color get color {
    switch (type) {
      case 'home':
        return Color(0xFF6A5AE0);
      case 'office':
        return Color(0xFF0FABBC);
      case 'other':
        return Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SavedLocation.fromMap(Map<String, dynamic> map) {
    return SavedLocation(
      type: map['type'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

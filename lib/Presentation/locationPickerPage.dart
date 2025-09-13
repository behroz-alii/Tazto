import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:tazto/services/locationManager.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  LatLng? _selectedLatLng; // New variable to track the selected location
  String? _selectedAddress;
  final TextEditingController _searchController = TextEditingController();

  final String apiKey = "AIzaSyBEFokPXfnNuUkTWz1OCbbdQbfPc_qPLm8"; // 🔑

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
      _selectedLatLng = _currentLatLng; // Set initial selected location
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLatLng!, 15),
      );
    }

    await _getAddressFromLatLng(_currentLatLng!);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["results"].isNotEmpty) {
          setState(() {
            _selectedAddress = data["results"][0]["formatted_address"];
            _searchController.text = _selectedAddress!;
          });
        }
      }
    } catch (e) {
      print("Error getting address from latlng: $e");
    }
  }

  Future<List<String>> _searchPlaces(String query) async {
    if (query.isEmpty) return [];

    // URL encode the query
    final encodedQuery = Uri.encodeComponent(query);
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedQuery&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK") {
          return (data["predictions"] as List)
              .map((p) => p["description"] as String)
              .toList();
        } else {
          // Handle different API status codes
          print("Places API error: ${data["status"]}");
          return [];
        }
      } else {
        print("HTTP error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error searching places: $e");
      return [];
    }
  }

  Future<void> _moveToPlace(String place) async {
    final encodedPlace = Uri.encodeComponent(place);
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedPlace&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["results"].isNotEmpty) {
          final location = data["results"][0]["geometry"]["location"];
          final latLng = LatLng(location["lat"], location["lng"]);

          setState(() {
            _currentLatLng = latLng;
            _selectedLatLng = latLng; // Update selected location
            _selectedAddress = data["results"][0]["formatted_address"];
            _searchController.text = _selectedAddress!;
          });

          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(latLng, 15),
            );
          }
        }
      }
    } catch (e) {
      print("Error moving to place: $e");
    }
  }

  void _showLocationTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context, 'home');
                },
              ),
              ListTile(
                leading: Icon(Icons.work, color: Colors.green),
                title: Text('Office'),
                onTap: () {
                  Navigator.pop(context, 'office');
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.orange),
                title: Text('Other Place'),
                onTap: () {
                  Navigator.pop(context, 'other');
                },
              ),
            ],
          ),
        );
      },
    ).then((selectedType) {
      if (selectedType != null && _selectedLatLng != null && _selectedAddress != null) {
        // Save the location using LocationManager
        LocationManager().saveLocation(
          selectedType,
          _selectedAddress!,
          _selectedLatLng!.latitude,
          _selectedLatLng!.longitude,
        );

        // Return the selected address to the previous screen
        Navigator.pop(context, {
          "address": _selectedAddress!,
          "latitude": _selectedLatLng!.latitude,
          "longitude": _selectedLatLng!.longitude,
          "type": selectedType
        });
      }
    });
  }

  void _saveLocation(String type) {
    // Here you would save the location to your database or shared preferences
    // For now, we'll just print it
    print('Saving location as $type: ${_selectedAddress}');

    // You can implement your storage logic here
    // For example, using shared_preferences:
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('$type_location', json.encode({
    //   'address': _selectedAddress,
    //   'latitude': _selectedLatLng!.latitude,
    //   'longitude': _selectedLatLng!.longitude
    // }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Location Picker", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.orangeAccent
      ),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              _mapController = controller;
              await _getAddressFromLatLng(_currentLatLng!);
            },
            onCameraMove: (position) {
              setState(() {
                _currentLatLng = position.target;
              });
            },
            onCameraIdle: () {
              if (_currentLatLng != null) {
                _getAddressFromLatLng(_currentLatLng!);
              }
            },
          ),

          // 📍 Center pin
          const Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),

          // 🔍 Search bar
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: TypeAheadField<String>(
              controller: _searchController,
              suggestionsCallback: (pattern) async {
                return await _searchPlaces(pattern);
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Search location",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(suggestion),
                );
              },
              onSelected: (suggestion) {
                _moveToPlace(suggestion);
              },
            ),
          ),

          // ✅ Confirm button
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent
              ),
              onPressed: () async {
                if (_selectedLatLng != null && _selectedAddress == null) {
                  await _getAddressFromLatLng(_selectedLatLng!);
                }

                if (_selectedAddress != null) {
                  // Show the location type selector
                  _showLocationTypeSelector();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please pick a location first")),
                  );
                }
              },
              child: const Text("Confirm Location", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
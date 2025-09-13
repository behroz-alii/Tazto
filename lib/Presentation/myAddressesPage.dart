import 'package:flutter/material.dart';
import 'package:tazto/services/saved_location.dart';

class MyAddressesPage extends StatefulWidget {
  final Map<String, SavedLocation> savedLocations;
  final Function(Map<String, SavedLocation>) onLocationsUpdated;

  const MyAddressesPage({
    Key? key,
    required this.savedLocations,
    required this.onLocationsUpdated,
  }) : super(key: key);

  @override
  _MyAddressesPageState createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  late Map<String, SavedLocation> _savedLocations;

  @override
  void initState() {
    super.initState();
    _savedLocations = Map.from(widget.savedLocations);
  }

  void _editAddress(SavedLocation location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController addressController = TextEditingController(text: location.address);

        return AlertDialog(
          title: Text('Edit ${location.displayType} Address'),
          content: TextField(
            controller: addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter address',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (addressController.text.trim().isNotEmpty) {
                  setState(() {
                    _savedLocations[location.type] = SavedLocation(
                      type: location.type,
                      address: addressController.text.trim(),
                      latitude: location.latitude,
                      longitude: location.longitude,
                    );
                  });
                  widget.onLocationsUpdated(_savedLocations);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${location.displayType} address updated')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAddress(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Address'),
          content: Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _savedLocations.remove(type);
                });
                widget.onLocationsUpdated(_savedLocations);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Addresses'),
      ),
      body: _savedLocations.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No addresses saved',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add addresses for quick access',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView(
        padding: EdgeInsets.all(16),
        children: _savedLocations.entries.map((entry) {
          final location = entry.value;
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(location.icon, color: location.color), // This should work now
              title: Text(location.displayType),
              subtitle: Text(location.address),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, size: 20),
                    onPressed: () => _editAddress(location),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _deleteAddress(location.type),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tazto/Presentation/restaurantRegistrationPage.dart';
import 'dart:io';
import 'package:tazto/Presentation/privacyPolicy.dart';
import 'package:tazto/Presentation/helpSupportPage.dart';
import 'package:tazto/Presentation/settingsPage.dart';
import 'package:tazto/Presentation/myAddressesPage.dart';
import 'package:tazto/services/locationManager.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _imageError = false;

  //to access saved locations
  final LocationManager _locationManager = LocationManager();

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _imageError = false; // Reset error state when user selects an image
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: CircleAvatar(
                      radius: screenWidth * 0.18,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : _imageError
                          ? null // Don't try to load network image if there was an error
                          : const NetworkImage(
                        "https://via.placeholder.com/150",
                      ),
                      child: _profileImage == null || _imageError
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Name
            const Text(
              "John Doe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // Email
            Text(
              "johndoe@email.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Account Details Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.shopping_bag,
                    title: "My Favorite Restaurants",
                    onTap: () {},
                  ),

                  _buildProfileOption(
                    icon: Icons.local_offer_outlined,
                    title: "Special Offers & Promo",
                    onTap: () {},
                  ),

                  _buildProfileOption(
                    icon: Icons.credit_card,
                    title: "Payment Methods",
                    onTap: () {},
                  ),

                  _buildProfileOption(
                    icon: Icons.location_on,
                    title: "My Addresses",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyAddressesPage(
                            savedLocations: _locationManager.savedLocations,
                            onLocationsUpdated: (updatedLocations) {
                              // Update the location manager with new locations
                              _locationManager.updateLocations(updatedLocations);
                              setState(() {}); // Refresh the UI if needed
                            },
                          ),
                        ),
                      );

                    },
                  ),


                  _buildProfileOption(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                    },
                  ),

                  _buildProfileOption(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));},
                  ),

                  _buildProfileOption(
                    icon: Icons.restaurant,
                    title: "Become TazTo",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                          const RestaurantRegistrationPage()));
                    },
                  ),

                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpSupportPage()));},
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add logout functionality
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tazto/Presentation/restaurantRegistrationPage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.18,
                    backgroundImage: const NetworkImage(
                      "https://via.placeholder.com/150",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
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
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Account Details Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy",
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.restaurant,
                    title: "Become TazTo",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestaurantRegistrationPage() ));
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
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

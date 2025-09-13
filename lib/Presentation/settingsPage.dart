// settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazto/services/themeProvider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? null
              : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orangeAccent,
              Colors.orange,
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.1, 0.1, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isDarkMode
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.settings,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Appearance Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode
                      ? null
                      : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appearance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildSettingsOption(
                      context,
                      Icons.dark_mode,
                      "Dark Mode",
                      "Switch between light and dark theme",
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                        activeColor: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildSettingsOption(
                      context,
                      Icons.text_fields,
                      "Font Size",
                      "Adjust the text size throughout the app",
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      onTap: () {
                        // Implement font size settings
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notifications Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode
                      ? null
                      : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildSettingsOption(
                      context,
                      Icons.notifications_active,
                      "Order Updates",
                      "Get notified about your order status",
                      Switch(
                        value: true,
                        onChanged: (value) {
                          // Implement notification toggle
                        },
                        activeColor: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // App Info Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode
                      ? null
                      : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Info",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildInfoItem("App Version", "1.0.0", isDarkMode),
                    const SizedBox(height: 15),
                    _buildInfoItem("Build Number", "12345", isDarkMode),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Widget trailing, {
        VoidCallback? onTap,
      }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
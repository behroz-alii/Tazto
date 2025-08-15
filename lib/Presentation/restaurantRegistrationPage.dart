import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'menuCreationPage.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  const RestaurantRegistrationPage({Key? key}) : super(key: key);

  @override
  State<RestaurantRegistrationPage> createState() => _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _logoImage;

  // Restaurant details
  String _name = '';
  String _address = '';
  String _phone = '';
  String _email = '';
  String _password = '';

  Future<void> _pickLogoImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _logoImage = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _submitAndProceed() {
    if (_formKey.currentState!.validate() && _logoImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuCreationPage( // Will create this next
            restaurantName: _name,
            logoImage: _logoImage,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_logoImage == null
              ? 'Please upload a restaurant logo'
              : 'Please complete all fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('REGISTER RESTAURANT',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Futuristic Header
              const Text(
                'JOIN THE TAZTO NETWORK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orangeAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Logo Upload Card
              _buildUploadCard(),
              const SizedBox(height: 32),

              // Restaurant Details Form
              _buildTextField(
                label: 'Restaurant Name',
                onChanged: (value) => _name = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                label: 'Address',
                onChanged: (value) => _address = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                label: 'Contact Number',
                keyboardType: TextInputType.phone,
                onChanged: (value) => _phone = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _email = value,
                validator: (value) => value!.isEmpty || !value!.contains('@')
                    ? 'Enter valid email' : null,
              ),
              _buildTextField(
                label: 'Password',
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) => value!.length < 6
                    ? 'Minimum 6 characters' : null,
              ),

              // Proceed Button
              const SizedBox(height: 40),
              _buildProceedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Column(
      children: [
        const Text(
          'RESTAURANT LOGO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickLogoImage,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _logoImage == null ? Colors.grey[200]! : Colors.orangeAccent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: _logoImage == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text('Upload Logo',
                    style: TextStyle(color: Colors.grey)),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.file(_logoImage!, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.orangeAccent,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitAndProceed,
        style: ElevatedButton.styleFrom(
          primary: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: const Text(
          'PROCEED TO UPLOAD MENU',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
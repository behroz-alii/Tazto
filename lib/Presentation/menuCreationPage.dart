import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum FoodCategory { Pizza, Burgers, Noodles, Meat, Vege, Desserts, Drinks }

class MenuCreationPage extends StatefulWidget {
  final String restaurantName;
  final File? logoImage;

  const MenuCreationPage({
    Key? key,
    required this.restaurantName,
    this.logoImage,
  }) : super(key: key);

  @override
  State<MenuCreationPage> createState() => _MenuCreationPageState();
}

class _MenuCreationPageState extends State<MenuCreationPage> {
  final ImagePicker _picker = ImagePicker();
  Set<FoodCategory> selectedCategories = {};
  List<MenuItem> _menuItems = [MenuItem.empty()]; // Start with one empty item

  void _addNewItem() {
    setState(() {
      _menuItems.add(MenuItem.empty());
    });
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _menuItems[index].image = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT MENU CATEGORIES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FoodCategory.values.map((category) {
            return FilterChip(
              label: Text(
                category.name.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              selected: selectedCategories.contains(category),
              selectedColor: Colors.orangeAccent,
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _submitMenu() {
    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one category')),
      );
      return;
    }

    // Validate menu items
    for (var item in _menuItems) {
      if (item.name.isEmpty || item.price <= 0 || item.image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please fill all required fields for each menu item')),
        );
        return;
      }
    }

    // TODO: Save to database/backend
    print('Selected categories: $selectedCategories');
    print('Menu items: $_menuItems');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('CREATE MENU FOR ${widget.restaurantName.toUpperCase()}',
            style: const TextStyle(
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
        child: Column(
          children: [
            // Header
            const Text(
              'ADD YOUR MENU ITEMS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orangeAccent,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Menu Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItemCard(index);
              },
            ),

            // Add Item Button
            const SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              onPressed: _addNewItem,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 40),

            // Category Selection
            _buildCategorySelection(),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitMenu,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'SAVE MENU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Header
          Row(
            children: [
              Text(
                'ITEM ${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (_menuItems.length > 1) // Show delete if more than one item
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => setState(() => _menuItems.removeAt(index)),
                  color: Colors.grey[400],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Image Upload
          GestureDetector(
            onTap: () => _pickImage(index),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _menuItems[index].image == null
                      ? Colors.grey[300]!
                      : Colors.orangeAccent,
                  width: 2,
                ),
              ),
              child: _menuItems[index].image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_photo_alternate,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to upload image',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_menuItems[index].image!,
                          fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Item Details Form
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Item Name',
              labelStyle: TextStyle(color: Colors.grey[600]),
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
              fillColor: Colors.white,
            ),
            onChanged: (value) => _menuItems[index].name = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefixText: 'Rs. ',
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
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                _menuItems[index].price = double.tryParse(value) ?? 0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              labelStyle: TextStyle(color: Colors.grey[600]),
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
              fillColor: Colors.white,
            ),
            maxLines: 2,
            onChanged: (value) => _menuItems[index].description = value,
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  String name;
  double price;
  String description;
  File? image;

  MenuItem({
    this.name = '',
    this.price = 0,
    this.description = '',
    this.image,
  });

  factory MenuItem.empty() => MenuItem();

  @override
  String toString() {
    return 'MenuItem{name: $name, price: $price, description: $description, image: ${image?.path}}';
  }
}

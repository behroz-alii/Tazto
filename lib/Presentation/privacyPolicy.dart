import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Privacy Policy Content
              _buildPolicySection(
                "Last Updated: September 9, 2025",
                "Your privacy is important to us. This Privacy Policy explains how TazTo collects, uses, discloses, and safeguards your information when you use our food delivery service.",
              ),

              _buildPolicySection(
                "1. Information We Collect",
                "We collect information you provide directly to us, such as when you create an account, place an order, or contact us for support. This may include:\n\n• Personal details (name, email, phone number)\n• Delivery address and location data\n• Payment information\n• Order history and preferences\n• Communications with restaurants and delivery partners",
              ),

              _buildPolicySection(
                "2. How We Use Your Information",
                "We use the information we collect to:\n\n• Process and deliver your food orders\n• Personalize your experience and recommendations\n• Communicate with you about orders, promotions, and updates\n• Improve our services and develop new features\n• Ensure the security and integrity of our platform",
              ),

              _buildPolicySection(
                "3. Location Information",
                "To provide accurate delivery services, we collect precise location data when you:\n\n• Set your delivery address\n• Allow location access for faster ordering\n• Track your order in real-time\n\nYou can control location permissions through your device settings.",
              ),

              _buildPolicySection(
                "4. Data Sharing with Restaurants & Delivery Partners",
                "We share necessary information with restaurants and delivery partners to fulfill your orders, including:\n\n• Your name and contact information\n• Delivery address and location\n• Order details and special instructions\n\nThese parties are required to protect your information and use it only for order fulfillment.",
              ),

              _buildPolicySection(
                "5. Payment Information Security",
                "We use industry-standard encryption to protect your payment information. Your full credit card details are never stored on our servers. We partner with PCI-compliant payment processors to ensure the security of your financial data.",
              ),

              _buildPolicySection(
                "6. Your Choices & Rights",
                "You can:\n\n• Access and update your personal information in the app\n• Opt-out of marketing communications\n• Request deletion of your account and data\n• Control cookie preferences through your browser\n\nContact us at privacy@tazto.com for privacy-related requests.",
              ),

              _buildPolicySection(
                "7. Data Retention",
                "We retain your personal information for as long as necessary to provide our services, comply with legal obligations, resolve disputes, and enforce our agreements. Order history is typically retained for 3 years for accounting and customer service purposes.",
              ),

              _buildPolicySection(
                "8. Children's Privacy",
                "Our services are not directed to individuals under 16. We do not knowingly collect personal information from children. If we become aware that a child has provided us with personal information, we will take steps to delete such information.",
              ),

              _buildPolicySection(
                "9. Changes to This Policy",
                "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last Updated\" date. You are advised to review this Privacy Policy periodically for any changes.",
              ),

              _buildPolicySection(
                "10. Contact Us",
                "If you have any questions about this Privacy Policy, please contact us at:\n\nTazTo Food Delivery\nEmail: privacy@tazto.com\nPhone: +1 (555) 123-TAZTO\nAddress: 123 Food Street, Culinary City, CC 12345",
              ),

              const SizedBox(height: 30),
              // Agreement Checkbox
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.orangeAccent),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "I have read and agree to the Privacy Policy",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Accept Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "I Understand",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
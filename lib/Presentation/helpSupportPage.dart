import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Colors.orangeAccent,
              Colors.orange,
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.1, 0.1, 1.0],
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
                    Icons.support_agent,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "How can we help you?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Quick Help Options
              const Text(
                "Quick Help",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 15),

              // FAQ Cards
              _buildHelpOption(
                context,
                Icons.restaurant_menu,
                "Order Issues",
                "Problems with your food order?",
                "Common order problems and solutions",
              ),

              _buildHelpOption(
                context,
                Icons.delivery_dining,
                "Delivery Problems",
                "Issues with delivery?",
                "Track your order or report delivery issues",
              ),

              _buildHelpOption(
                context,
                Icons.payment,
                "Payment & Refunds",
                "Payment issues or refund requests?",
                "Information about payments and refund process",
              ),

              _buildHelpOption(
                context,
                Icons.account_circle,
                "Account Issues",
                "Problems with your account?",
                "Login issues, password reset, and account management",
              ),

              const SizedBox(height: 30),

              // Contact Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
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
                    const Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "We're here to help you with any questions or concerns you may have about our service.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Support
                    _buildContactOption(
                      context,
                      Icons.email,
                      "Email Support",
                      "Send us an email and we'll respond within 24 hours",
                      "tazto.company@tazto.com",
                          () {
                        _launchEmail(context, "tazto.company@tazto.com");
                      },
                    ),

                    const SizedBox(height: 20),

                    // Live Chat
                    _buildContactOption(
                      context,
                      Icons.chat,
                      "Live Chat",
                      "Chat with our support team in real-time",
                      "Available 9AM - 11PM",
                          () {
                        _showComingSoon(context);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone Support
                    _buildContactOption(
                      context,
                      Icons.phone,
                      "Phone Support",
                      "Call us for immediate assistance",
                      "+1 (555) 123-TAZTO",
                          () {
                        _launchPhone(context, "+15551238296");
                      },
                    ),

                    const SizedBox(height: 20),

                    // FAQ Section
                    _buildContactOption(
                      context,
                      Icons.help_center,
                      "FAQs",
                      "Browse frequently asked questions",
                      "Find quick answers",
                          () {
                        _showFAQs(context);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Operating Hours
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Support Hours",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "• Email Support: 24/7\n• Live Chat: 9:00 AM - 11:00 PM (Local Time)\n• Phone Support: 10:00 AM - 8:00 PM (Local Time)",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Social Media
              const Text(
                "Follow Us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSocialIcon(context, Icons.facebook, () {
                    _showComingSoon(context);
                  }),
                  _buildSocialIcon(context, Icons.camera_alt, () {
                    _showComingSoon(context);
                  }),
                  _buildSocialIcon(context, Icons.chat, () {
                    _showComingSoon(context);
                  }),
                  _buildSocialIcon(context, Icons.play_arrow, () {
                    _showComingSoon(context);
                  }),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOption(BuildContext context, IconData icon, String title, String subtitle, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showHelpDetail(context, title, description);
        },
      ),
    );
  }

  Widget _buildContactOption(BuildContext context, IconData icon, String title, String subtitle, String actionText, VoidCallback onTap) {
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
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
                const SizedBox(height: 5),
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: Colors.orangeAccent,
      radius: 25,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  void _showHelpDetail(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showFAQs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Frequently Asked Questions"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFAQItem("How do I track my order?", "You can track your order in real-time from the 'My Orders' section in the app."),
                _buildFAQItem("What if my food arrives late?", "We monitor delivery times closely. If your food is significantly delayed, please contact us for assistance."),
                _buildFAQItem("How do I change my delivery address?", "You can update your delivery address from your profile settings before placing an order."),
                _buildFAQItem("What payment methods do you accept?", "We accept credit/debit cards, digital wallets, and cash on delivery."),
                _buildFAQItem("How do I report missing items?", "Please contact us immediately at tazto.company@tazto.com with your order number."),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 5),
          Text(answer),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is coming soon!"),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  void _launchEmail(BuildContext context, String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=TazTo Support Request&body=Hello TazTo team,',
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      _showComingSoon(context);
    }
  }

  void _launchPhone(BuildContext context, String phone) async {
    final Uri params = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      _showComingSoon(context);
    }
  }
}
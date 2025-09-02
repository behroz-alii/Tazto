import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:tazto/Presentation/orderConfirmationPage.dart';
import 'package:tazto/services/cartProvider.dart';

class PaymentMethodPage extends StatelessWidget {
  final int cartAmount; // in cents
  final double totalAmount; // in USD
  final String address;

  const PaymentMethodPage({
    super.key,
    required this.cartAmount,
    required this.totalAmount,
    required this.address,
  });

  // ✅ Your local backend (change IP if needed)
  String get _baseUrl => 'http://192.168.1.12:4242';

  Future<String> _createPaymentIntent() async {
    final uri = Uri.parse('$_baseUrl/create-payment-intent');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': cartAmount,
        'currency': 'usd',
      }),
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('Backend error: ${response.body}');
    }
    final data = jsonDecode(response.body);
    return data['clientSecret'] as String;
  }

  Future<void> _makeCardPayment(BuildContext context) async {
    try {
      final clientSecret = await _createPaymentIntent();

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tazto',
          style: ThemeMode.light,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Card Payment Successful')),
      );


      // Auto confirm order
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(
            totalAmount: totalAmount,
            address: address,
            paymentMethod: 'Card',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Card Payment Failed: $e')),
      );
    }
  }

  Future<void> _makeWalletPayment(BuildContext context) async {
    try {
      final clientSecret = await _createPaymentIntent();

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tazto',
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.light,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Wallet Payment Successful')),
      );

      // Auto confirm order
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(
            totalAmount: totalAmount,
            address: address,
            paymentMethod: 'Google Pay',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Wallet Payment Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Credit / Debit Card'),
            onTap: () => _makeCardPayment(context),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Google Pay'),
            onTap: () => _makeWalletPayment(context),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Cash on Delivery"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Just return 'Cash on Delivery' to CheckoutPage
              Navigator.pop(context, 'Cash on Delivery');
            },
          ),
        ],
      ),
    );
  }
}
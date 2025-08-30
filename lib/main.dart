import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/Presentation/homePage.dart';
import 'package:tazto/services/cartProvider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tazto/services/orderProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51RzyIdBDvjFtcu7epYN22x4Ue9O4Kjl3Do1eY9J08cCFQrhFDo4EpV7xbyDW1oIvfBbZ5dUt7ZCEQZ8ymvGbQIV3009TAxMhXQ"; // from Stripe Dashboard
  runApp(
    MultiProvider(
      providers:[ ChangeNotifierProvider(
        create: (context) => CartProvider(),),
        ChangeNotifierProvider(create: (context) => OrderProvider()),],
        child: MyApp(),
      ),
    );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tazto',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
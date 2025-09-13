import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazto/services/cartModel.dart';
import 'package:tazto/Presentation/homePage.dart';
import 'package:tazto/services/cartProvider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tazto/services/orderProvider.dart';
import 'package:tazto/services/themeProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51RzyIdBDvjFtcu7epYN22x4Ue9O4Kjl3Do1eY9J08cCFQrhFDo4EpV7xbyDW1oIvfBbZ5dUt7ZCEQZ8ymvGbQIV3009TAxMhXQ";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const TazToApp(),
    );
  }
}

class TazToApp extends StatelessWidget {
  const TazToApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TazTo',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeProvider.themeMode,
          home: HomePage(), // Remove const here
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.orangeAccent,
      colorScheme: const ColorScheme.light(
        primary: Colors.orangeAccent,
        secondary: Colors.orange,
        background: Colors.white,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.orange[800],
      colorScheme: ColorScheme.dark(
        primary: Colors.orange[800]!,
        secondary: Colors.orange[700]!,
        background: Colors.grey[900]!,
        surface: Colors.grey[800]!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[800],
      ),
    );
  }
}
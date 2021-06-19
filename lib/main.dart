import 'package:flutter/material.dart';
import 'screens/welcome/welcome.dart';
import 'screens/home/home.dart';
import 'screens/scan/add_receipt.dart';

void main() => runApp(StockUP());

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        AddReceiptScreen.id: (context) => AddReceiptScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
    );
  }
}

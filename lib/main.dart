import 'package:flutter/material.dart';
import 'screens/welcome/welcome.dart';
import 'screens/home/home.dart';
import 'screens/scan/add_receipt.dart';
import 'screens/login/sign_in.dart';

void main() => runApp(StockUP());

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        AddReceiptScreen.id: (context) => AddReceiptScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
      },
    );
  }
}

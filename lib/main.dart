import 'package:flutter/material.dart';
import 'screens/scan/add_files.dart';
import 'screens/welcome/welcome.dart';
import 'screens/home/home.dart';
import 'screens/scan/add_receipt.dart';
import 'screens/login/sign_in.dart';
import 'screens/login/sign_up.dart';

void main() => runApp(StockUP());

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AddFilesScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        AddReceiptScreen.id: (context) => AddReceiptScreen(),
        AddFilesScreen.id: (context) => AddFilesScreen(),
      },
    );
  }
}

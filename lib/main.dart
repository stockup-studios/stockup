import 'package:flutter/material.dart';
import 'screens/home/home.dart';
import 'screens/scan/add_receipt.dart';

void main() => runApp(StockUP());

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AddReceiptScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        AddReceiptScreen.id: (context) => AddReceiptScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stockup/screens/items/items.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/search/search.dart';
import 'package:stockup/screens/shopping_list/shopping_list.dart';
import 'package:stockup/screens/welcome/welcome.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/scan/add_receipt.dart';
import 'package:stockup/screens/login/sign_in.dart';
import 'package:stockup/screens/login/sign_up.dart';

void main() => runApp(StockUP());

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ItemsScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        AddReceiptScreen.id: (context) => AddReceiptScreen(),
        AddFilesScreen.id: (context) => AddFilesScreen(),
        ItemsScreen.id: (context) => ItemsScreen(),
        ShoppingListScreen.id: (context) => ShoppingListScreen(),
        SearchScreen.id: (context) => SearchScreen(),
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/business_logic/item/item_viewmodel.dart';
import 'package:stockup/models/appUser.dart';
import 'package:stockup/screens/items/items.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/search/search.dart';
import 'package:stockup/screens/shopping_list/shopping_list.dart';
import 'package:stockup/screens/welcome/welcome.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/scan/add_receipt.dart';
import 'package:stockup/screens/login/sign_in.dart';
import 'package:stockup/screens/login/sign_up.dart';
import 'package:stockup/services/auth/auth_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StockUP());
}

class StockUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser>.value(
            value: AuthImplementation().user, initialData: null),
        ChangeNotifierProvider<ItemViewModel>(
            create: (context) => ItemViewModel()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}

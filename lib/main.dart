// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stockup/business_logic/item/item_viewmodel.dart';
// import 'package:stockup/screens/auth_change.dart';
// import 'package:stockup/screens/items/item_list.dart';
// import 'package:stockup/screens/scan/add_files.dart';
// import 'package:stockup/screens/search/search.dart';
// import 'package:stockup/screens/shopping_list/shop_list.dart';
// import 'package:stockup/screens/welcome/welcome.dart';
// import 'package:stockup/screens/home/home.dart';
// import 'package:stockup/screens/scan/add_receipt.dart';
// import 'package:stockup/screens/login/sign_in.dart';
// import 'package:stockup/screens/login/sign_up.dart';
// import 'package:stockup/services/auth/auth_impl.dart';
// import 'models/app_user.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(StockUP());
// }
//
// class StockUP extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         StreamProvider<AppUser>.value(
//             value: AuthImplementation().user, initialData: AppUser()),
//         ChangeNotifierProvider<ItemViewModel>(
//             create: (context) => ItemViewModel()),
//       ],
//       child: MaterialApp(
//         initialRoute: HomeScreen.id,
//         debugShowCheckedModeBanner: false,
//         routes: {
//           AuthChange.id: (context) => AuthChange(),
//           WelcomeScreen.id: (context) => WelcomeScreen(),
//           SignInScreen.id: (context) => SignInScreen(),
//           SignUpScreen.id: (context) => SignUpScreen(),
//           HomeScreen.id: (context) => HomeScreen(),
//           AddReceiptScreen.id: (context) => AddReceiptScreen(),
//           AddFilesScreen.id: (context) => AddFilesScreen(),
//           ItemListScreen.id: (context) => ItemListScreen(),
//           ShopListScreen.id: (context) => ShopListScreen(),
//           SearchScreen.id: (context) => SearchScreen(),
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
//import 'package:stockup/models/models.dart';
//import 'package:stockup/services/auth/auth_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(StockUP());
}

class StockUP extends StatelessWidget {
  const StockUP({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockUP',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}

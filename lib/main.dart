import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/models/appUser.dart';
import 'package:stockup/screens/auth_change.dart';
import 'package:stockup/services/auth/auth_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: AppUser(),
      value: AuthImplementation().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.blueGrey.shade300,
          scaffoldBackgroundColor: Colors.grey.shade200,
          primaryColor: Colors.blueGrey.shade400,
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.blueGrey.shade50,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            unselectedIconTheme: IconThemeData(
              color: Colors.grey.shade400,
              // size: 25.0,
            ),
            selectedIconTheme: IconThemeData(
              color: Colors.black,
              // size: 25.0,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
        home: AuthChange(),
      ),
    );
  }
}

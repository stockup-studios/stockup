import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/models/appUser.dart';
import 'package:stockup/screens/authenticate/authenticate.dart';
import 'package:stockup/screens/home/home_screen.dart';

class AuthChange extends StatelessWidget {
  static const String id = 'auth_change';
  // returns home or authenticate widget
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}

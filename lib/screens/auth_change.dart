import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/business_logic/item/item_viewmodel.dart';
import 'package:stockup/business_logic/userData/userData_viewmodel.dart';
import 'package:stockup/models/app_user.dart';
import 'package:stockup/screens/login/sign_in.dart';
import 'package:stockup/services/database/database_impl.dart';

import 'home/home.dart';

class AuthChange extends StatelessWidget {
  static const String id = 'auth_change';
  // returns home or authenticate widget
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    //UserData userData = Provider.of<UserData>(context, listen: false);
    if (user == null) {
      return SignInScreen();
    } else {
      //userData.init(user);
      ItemViewModel itemViewModel =
          Provider.of<ItemViewModel>(context, listen: false);
      //itemViewModel.init(userData);
      return SignInScreen();
    }
  }
}

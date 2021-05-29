import 'package:flutter/material.dart';
import 'package:stockup/screens/authenticate/register.dart';
import 'package:stockup/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggle() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggle: toggle);
    } else {
      return Register(toggle: toggle);
    }
  }
}

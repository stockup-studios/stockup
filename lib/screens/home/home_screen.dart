import 'package:flutter/material.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthImplementation _auth = AuthImplementation();
    return Scaffold(
        appBar: AppBar(
      title: Text('Home'),
      actions: <Widget>[
        TextButton.icon(
          icon: Icon(Icons.person),
          label: Text('Logout'),
          onPressed: () async {
            await _auth.signOut();
          },
        )
      ],
    ));
  }
}

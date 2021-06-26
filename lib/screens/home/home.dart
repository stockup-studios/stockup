import 'package:flutter/material.dart';
import 'package:stockup/screens/login/sign_in.dart';
import 'package:stockup/services/auth/auth_impl.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  final String title = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthImplementation _auth = AuthImplementation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamed(context, SignInScreen.id);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: <SummaryTile>[
          for (int i = 1; i <= 3; ++i)
            SummaryTile('Summary Title $i', 'Description $i')
        ],
      ),
      bottomNavigationBar: kBottomNavigationBar,
    );
  }
}

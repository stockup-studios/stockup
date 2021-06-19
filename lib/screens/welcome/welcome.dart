import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  final String title = 'StockUP';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 40.0,
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Sign In'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade700),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Sign Up'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade700),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade100),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

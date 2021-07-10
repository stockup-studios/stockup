import 'package:animated_text_kit/animated_text_kit.dart';
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
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'StockUP',
                    curve: Curves.slowMiddle,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 60.0,
                    ),
                    speed: const Duration(milliseconds: 400),
                  ),
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.70,
                  child: OutlinedButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, SignInScreen.id);
                    },
                    child: Text('Sign In'),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade700),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.70,
                  child: OutlinedButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, SignUpScreen.id);
                    },
                    child: Text('Sign Up'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade700),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade100),
                    ),
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

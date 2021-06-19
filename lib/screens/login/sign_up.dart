import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: Center(child: Text('Image goes here')),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: TextField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                ),
                Container(
                  child: TextField(
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                ),
                Container(
                  child: TextField(
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm password'),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                ),
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
                TextButton(
                  onPressed: () {},
                  child: Text('Forgot password?'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.face),
                          Text('Sign Up'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.g_translate),
                          Text('Sign Up'),
                        ],
                      ),
                    ),
                  ],
                ),
                Text('Already Have an account?'),
                TextButton(
                  onPressed: () {},
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

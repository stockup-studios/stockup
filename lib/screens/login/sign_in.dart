import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                  margin:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                ),
                Container(
                  child: TextField(
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                  margin:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
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
                          Text('Sign In'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.g_translate),
                          Text('Sign In'),
                        ],
                      ),
                    ),
                  ],
                ),
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

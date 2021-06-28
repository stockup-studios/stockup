import 'package:flutter/material.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/login/sign_up.dart';
import 'package:stockup/services/auth/auth_impl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthImplementation _auth = AuthImplementation();
  final emailInput = GlobalKey<FormState>();
  final passwordInput = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: Form(
                        key: emailInput,
                        child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Enter your email',
                              labelText: 'Email'),
                          validator: (val) =>
                              val.contains('@') ? null : 'Enter a valid email',
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                    ),
                    Container(
                      child: Form(
                        key: passwordInput,
                        child: TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter your password',
                              labelText: 'Password'),
                          validator: (val) => val.length < 6
                              ? '6 or more characters password'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (emailInput.currentState.validate() &&
                              passwordInput.currentState.validate()) {
                            dynamic result = await _auth
                                .signInWithEmailPassword(email, password);
                            if (result == null) {
                              setState(() => error = 'Wrong email or password');
                            } else {
                              Navigator.pushNamed(context, HomeScreen.id);
                            }
                          }
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
                  ],
                ),
                Column(
                  children: [
                    Text(
                      error,
                      style: TextStyle(color: Colors.red[400], fontSize: 16.0),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue.shade900),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.facebookF),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Sign In'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red.shade900),
                            ),
                            onPressed: () async {
                              dynamic result = await _auth.signInWithGoogle();
                              if (result == null) {
                                setState(() =>
                                    error = 'Unable to sign in with google');
                              } else {
                                Navigator.pushNamed(context, HomeScreen.id);
                              }
                            },
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.google),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Sign In'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account? ",
                          ),
                          GestureDetector(
                            onTap: () {
                              return Navigator.pushNamed(
                                  context, SignUpScreen.id);
                            },
                            child: Text(
                              "Create account",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

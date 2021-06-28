import 'package:flutter/material.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/login/sign_in.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthImplementation _auth = AuthImplementation();
  final emailInput = GlobalKey<FormState>();
  final passwordInput = GlobalKey<FormState>();
  final confirmPassword = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                    ),
                    Container(
                      child: Form(
                        key: passwordInput,
                        child: TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: '6 or more characters password',
                              labelText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6 or more characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                    ),
                    Container(
                      child: Form(
                        key: confirmPassword,
                        child: TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter password again',
                              labelText: 'Confirm Password'),
                          validator: (val) => val != password
                              ? 'Password does not match'
                              : null,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (emailInput.currentState.validate() &&
                              passwordInput.currentState.validate() &&
                              confirmPassword.currentState.validate()) {
                            dynamic result = await _auth
                                .registerWithEmailPassword(email, password);
                            if (result == null) {
                              setState(
                                  () => error = 'Please supply a valid email');
                            } else {
                              Navigator.pushNamed(context, HomeScreen.id);
                            }
                          }
                        },
                        child: Text('Register'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignInScreen.id);
                          },
                          child: Text("Sign up",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
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

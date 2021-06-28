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
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

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
            child: Container(
              color: Colors.grey,
              child: Center(child: Text('Image goes here')),
            ),
          ),
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
                        key: _formKey,
                        child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Enter your email',
                              labelText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
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
                        key: _formKey2,
                        child: TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText:
                                  'Enter a password 6 or more characters long.',
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
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'Enter password again',
                            labelText: 'Confirm Password'),
                        validator: (val) =>
                            val != password ? 'Password does not match' : null,
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
                          if (_formKey.currentState.validate()) {
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

import 'package:flutter/material.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/login/sign_up.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Enter your email',
                          labelText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
                ),
                Container(
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter your password',
                          labelText: 'Password'),
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6 or more characters long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result =
                          await _auth.signInWithEmailPassword(email, password);
                      if (result == null) {
                        setState(() =>
                            error = 'Could not sign in with those credentials');
                      } else {
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                    }
                  },
                  child: Text('Sign In'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade700),
                  ),
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red[400], fontSize: 16.0),
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
                      onPressed: () async {
                        dynamic result = await _auth.signInWithGoogle();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.g_translate),
                          Text('Sign In'),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        return Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: Text(
                        "Create account",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

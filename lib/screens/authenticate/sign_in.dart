import 'package:flutter/material.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn({this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthImplementation _auth = AuthImplementation();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in to StockUP'),
        actions: <Widget>[
          TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.toggle();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter your email.',
                    labelText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Enter your password.',
                    labelText: 'Password'),
                validator: (val) => val.length < 6
                    ? 'Enter a password 6 or more characters long'
                    : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result =
                        await _auth.signInWithEmailPassword(email, password);
                    if (result == null) {
                      setState(() =>
                          error = 'Could not sign in with those credentials');
                    }
                  }
                },
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red[400], fontSize: 16.0),
              ),
              ElevatedButton(
                child: Text(
                  'Login with Google',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  dynamic result = await _auth.signInWithGoogle();
                  if (result == null) {
                    setState(() => error = 'Could not sign in with Google');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/sign_up/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Form(
                            key: _key,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                icon: Icon(Icons.email),
                                                hintText: 'Enter your email',
                                                labelText: 'Email',
                                                border: InputBorder.none,
                                              ),
                                              validator: model.emailValidator,
                                              onChanged: model.updateEmail,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              obscureText: true,
                                              autocorrect: false,
                                              decoration: const InputDecoration(
                                                icon: Icon(Icons.lock),
                                                hintText: 'Enter your password',
                                                labelText: 'Password',
                                                border: InputBorder.none,
                                              ),
                                              validator:
                                                  model.passwordValidator,
                                              onChanged: model.updatePassword,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              obscureText: true,
                                              autocorrect: false,
                                              decoration: const InputDecoration(
                                                icon: Icon(Icons.lock),
                                                hintText:
                                                    'Enter your password again',
                                                labelText: 'Confirm Password',
                                                border: InputBorder.none,
                                              ),
                                              validator:
                                                  model.passwordMatchValidator,
                                              onChanged:
                                                  model.updateConfirmPassword,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.75,
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  model.registerWithEmail();
                                }
                              },
                              child: Text('Sign Up'),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey.shade700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                    ),
                    TextButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => model.navigateToSignIn(),
                    ),
                  ],
                ),
              ),
            ],
          )),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}

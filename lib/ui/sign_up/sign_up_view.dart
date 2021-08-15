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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 30,
                        right: 10,
                      ),
                      child: Text(
                        'Sign up!',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                                        widthFactor: 0.9,

                                        //   child: Container(
                                        // decoration: BoxDecoration(
                                        //   color: Colors.grey[300],
                                        //   borderRadius:
                                        //       BorderRadius.circular(10),
                                        // ),
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
                                              filled: true,
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              // border: InputBorder.none,
                                            ),
                                            validator: model.emailValidator,
                                            onChanged: model.updateEmail,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.9,
                                        child: Container(
                                          // decoration: BoxDecoration(
                                          //   color: Colors.grey[300],
                                          //   borderRadius:
                                          //       BorderRadius.circular(10),
                                          // ),
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
                                                filled: true,
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                // border: InputBorder.none,
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
                                        widthFactor: 0.9,
                                        child: Container(
                                          // decoration: BoxDecoration(
                                          //   color: Colors.grey[300],
                                          //   borderRadius:
                                          //       BorderRadius.circular(10),
                                          // ),
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
                                                filled: true,
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                //border: InputBorder.none,
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
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
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

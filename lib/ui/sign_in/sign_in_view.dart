import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/sign_in/sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    //final passwordInput = GlobalKey<FormState>();
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Form(
              key: _key,
              child: Column(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 5.0),
                              child: TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                ),
                                validator: model.emailValidator,
                                onChanged: model.updateEmail,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 5.0),
                              child: TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.lock),
                                  hintText: 'Enter your password',
                                  labelText: 'Password',
                                ),
                                validator: model.passwordValidator,
                                onChanged: model.updatePassword,
                              ),
                            ),
                            SizedBox(height: 20),
                            FractionallySizedBox(
                              widthFactor: 0.7,
                              child: OutlinedButton(
                                onPressed: () async {
                                  if (_key.currentState.validate()) {
                                    dynamic result = model.signInEmail();
                                    if (result == null) {
                                      model.updateErrorEmail();
                                    } else {
                                      model.homeScreen();
                                    }
                                  }
                                },
                                child: Text('Sign In'),
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
                        Column(
                          children: [
                            Text(
                              model.getError(),
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 16.0),
                            ),
                            TextButton(
                              onPressed: () {}, // TODO: Implement in ViewModel
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
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
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red.shade900),
                                    ),
                                    onPressed: () {
                                      dynamic result = model.signInGoogle();
                                      if (result == null) {
                                        model.updateErrorGoogle();
                                      } else {
                                        model.homeScreen();
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
                                    "Don't have an account?",
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Create account',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: model.signUp,
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
            ),
          )

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       flex: 2,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Column(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                     horizontal: 50.0, vertical: 5.0),
          //                 child: Form(
          //                   key: key,
          //                   child: TextFormField(
          //                     autocorrect: false,
          //                     keyboardType: TextInputType.emailAddress,
          //                     decoration: const InputDecoration(
          //                       icon: Icon(Icons.email),
          //                       hintText: 'Enter your email',
          //                       labelText: 'Email',
          //                     ),
          //                     validator: model.emailValidator,
          //                     onChanged: model.updateEmail,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                     horizontal: 50.0, vertical: 5.0),
          //                 child: Form(
          //                   child: TextFormField(
          //                     obscureText: true,
          //                     autocorrect: false,
          //                     decoration: const InputDecoration(
          //                       icon: Icon(Icons.lock),
          //                       hintText: 'Enter your password',
          //                       labelText: 'Password',
          //                     ),
          //                     validator: model.passwordValidator,
          //                     onChanged: model.updatePassword,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 20),
          //               FractionallySizedBox(
          //                 widthFactor: 0.7,
          //                 child: OutlinedButton(
          //                   onPressed: () async {
          //                     if (key.currentState.validate()) {
          //                       dynamic result = model.signInEmail();
          //                       if (result == null) {
          //                         model.updateErrorEmail();
          //                       } else {
          //                         model.homeScreen();
          //                       }
          //                     }
          //                   },
          //                   child: Text('Sign In'),
          //                   style: ButtonStyle(
          //                     foregroundColor:
          //                         MaterialStateProperty.all<Color>(Colors.white),
          //                     backgroundColor: MaterialStateProperty.all<Color>(
          //                         Colors.grey.shade700),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text(
          //                 model.getError(),
          //                 style:
          //                     TextStyle(color: Colors.red[400], fontSize: 16.0),
          //               ),
          //               TextButton(
          //                 onPressed: () {}, // TODO: Implement in ViewModel
          //                 child: Text(
          //                   'Forgot password?',
          //                   style: TextStyle(
          //                     color: Colors.grey,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     ElevatedButton(
          //                       style: ButtonStyle(
          //                         backgroundColor:
          //                             MaterialStateProperty.all<Color>(
          //                                 Colors.blue.shade900),
          //                       ),
          //                       onPressed: () {},
          //                       child: Row(
          //                         children: [
          //                           FaIcon(FontAwesomeIcons.facebookF),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Text('Sign In'),
          //                         ],
          //                       ),
          //                     ),
          //                     ElevatedButton(
          //                       style: ButtonStyle(
          //                         backgroundColor:
          //                             MaterialStateProperty.all<Color>(
          //                                 Colors.red.shade900),
          //                       ),
          //                       onPressed: () {
          //                         dynamic result = model.signInGoogle();
          //                         if (result == null) {
          //                           model.updateErrorGoogle();
          //                         } else {
          //                           model.homeScreen();
          //                         }
          //                       },
          //                       child: Row(
          //                         children: [
          //                           FaIcon(FontAwesomeIcons.google),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Text('Sign In'),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: <Widget>[
          //                     Text(
          //                       "Don't have an account?",
          //                     ),
          //                     TextButton(
          //                       child: Text(
          //                         'Create account',
          //                         style: TextStyle(color: Colors.blue),
          //                       ),
          //                       onPressed: model.signUp,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/sign_in/password_reset/password_reset_view.dart';
import 'package:stockup/ui/sign_in/sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 40, right: 10),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'StockUP',
                          curve: Curves.slowMiddle,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 60.0,
                          ),
                          speed: const Duration(milliseconds: 400),
                        ),
                      ],
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
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                      widthFactor: 0.9,
                                      child: Container(
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
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              //border: InputBorder.none,
                                              filled: true,
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: model.passwordValidator,
                                            onChanged: model.updatePassword,
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
                          padding: const EdgeInsets.all(10.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  model.signInEmail();
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 40, right: 0),
              child: Column(
                children: [
                  Text(
                    model.getError(),
                    style: TextStyle(color: Colors.red[400], fontSize: 16.0),
                  ),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => PasswordResetView(),
                        isScrollControlled: true,
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                      ),
                      TextButton(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () => model.navigateToSignUp(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}

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
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
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
                                            validator: model.passwordValidator,
                                            onChanged: model.updatePassword,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 20),
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
                                model.signInEmail();
                              }
                            },
                            child: Text('Sign In'),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                      );
                      model.updateSuccessMessage();
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
          ],
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}

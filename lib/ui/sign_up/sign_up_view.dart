import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/sign_up/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 5),
                        child: Form(
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: 'Enter your email',
                                labelText: 'Email'),
                            validator: model.emailValidator,
                            onChanged: model.updateEmail,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 5),
                        child: Form(
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'Must be 6 or more characters',
                                labelText: 'Password'),
                            validator: model.passwordValidator,
                            onChanged: model.updatePassword,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 5),
                        child: Form(
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'Enter password again',
                                labelText: 'Confirm Password'),
                            validator: model.passwordMatchValidator,
                            onChanged: model.updateConfirmPassword,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.7,
                        child: OutlinedButton(
                          onPressed: () {}, // TODO: Implement in ViewModel
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
                        '', // TODO: Implement error handling in ViewModel
                        style:
                            TextStyle(color: Colors.red[400], fontSize: 16.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an account?',
                          ),
                          TextButton(
                            onPressed:
                                model.signIn, // TODO: Implement in ViewModel
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
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
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}

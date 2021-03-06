import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/sign_in/password_reset/password_reset_view_model.dart';

final _key = GlobalKey<FormState>();

class PasswordResetView extends StatelessWidget {
  const PasswordResetView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordResetViewModel>.reactive(
      builder: (context, model, child) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, right: 10, bottom: 5),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  child: Form(
                    key: _key,
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.email),
                        ),
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: model.emailValidator,
                      onChanged: (email) {
                        model.email = email;
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (model.getError() != '')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.getError(),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      await model.sendEmail();
                      if (model.getError() == '') {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => PasswordResetViewModel(),
    );
  }
}

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
      builder: (context, model, child) => ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20),
          Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            model.getError(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[400], fontSize: 16.0),
          ),
          // Container(
          //   alignment: Alignment.center,
          //padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          // decoration: BoxDecoration(
          //     color: Colors.grey[300],
          //     borderRadius: BorderRadius.circular(8)),
          SizedBox(height: 10),
          Form(
            key: _key,
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Enter your email',
                labelText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: model.emailValidator,
              onChanged: (email) {
                model.email = email;
              },
            ),
          ),

          SizedBox(height: 40),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: ElevatedButton(
              child: Text('Send password reset email',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
          SizedBox(height: 10),
        ],
      ),
      viewModelBuilder: () => PasswordResetViewModel(),
    );
  }
}

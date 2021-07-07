import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/welcome/welcome_view_model.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Expanded(
              child: Center(
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
              flex: 2,
            ),
            Expanded(
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.70,
                    child: OutlinedButton(
                      onPressed: model.signIn,
                      child: Text('Sign In'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade700),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.70,
                    child: OutlinedButton(
                      onPressed: model.signUp,
                      child: Text('Sign Up'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade700),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => WelcomeViewModel(),
    );
  }
}

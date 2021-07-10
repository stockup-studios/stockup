import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class SignInViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthImplementation>();
  String _email = '';
  String _password = '';
  String _error = '';

  String emailValidator(String val) {
    return val.contains('@') ? null : 'Enter a valid email';
  }

  String passwordValidator(String val) {
    return val.length < 6 ? '6 or more characters password' : null;
  }

  void updateEmail(val) {
    _email = val;
    notifyListeners();
  }

  void updatePassword(val) {
    _password = val;
    notifyListeners();
  }

  dynamic signInEmail() async {
    return await _authService.signInWithEmailPassword(_email, _password);
  }

  dynamic signInGoogle() async {
    return await _authService.signInWithGoogle();
  }

  void updateErrorEmail() {
    _error = 'Wrong email or password';
  }

  void updateErrorGoogle() {
    _error = 'Unable to sign in with google';
  }

  String getError() => _error;

  void signUp() {
    _navigationService.navigateTo(Routes.signUpView);
    notifyListeners();
  }

  void homeScreen() {
    _navigationService.navigateTo(Routes.userHomeView);
  }
}

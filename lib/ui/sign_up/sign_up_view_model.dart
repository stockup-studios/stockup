import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/services/auth/auth_impl.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthImplementation>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';

  String emailValidator(String val) {
    return val.contains('@') ? null : 'Enter a valid email';
  }

  String passwordValidator(String val) {
    return val.length < 6 ? '6 or more characters password' : null;
  }

  String passwordMatchValidator(String val) {
    return val == _password ? null : 'Password does not match';
  }

  void updateEmail(val) {
    _email = val;
    notifyListeners();
  }

  void updatePassword(val) {
    _password = val;
    notifyListeners();
  }

  void updateConfirmPassword(val) {
    _confirmPassword = val;
    notifyListeners();
  }

  dynamic registerWithEmail() async {
    dynamic result = await _authService.registerWithEmailPassword(_email, _password);
    return result;
  }

  void updateErrorEmail() {
    _error = 'Please supple a valid email';
    notifyListeners();
  }
  String getError() => _error;

  void homeScreen() {
    _navigationService.navigateTo(Routes.userHomeView);
    notifyListeners();
  }

  void signIn() {
    _navigationService.navigateTo(Routes.signInView);
    notifyListeners();
  }
}

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
    return val.length < 6 ? 'Password must be six or more characters' : null;
  }

  String passwordMatchValidator(String val) {
    return val == _password ? null : 'Passwords do not match';
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

  void registerWithEmail() async {
    dynamic result =
        await _authService.registerWithEmailPassword(_email, _password);
    if (result == null) {
      _updateErrorEmail();
    } else {
      await _navigateToHome();
    }
  }

  void _updateErrorEmail() {
    _error = 'Email already in use';
    notifyListeners();
  }

  String getError() => _error;

  Future _navigateToHome() async {
    await _navigationService.clearStackAndShow(Routes.userHomeView);
    notifyListeners();
  }

  Future navigateToSignIn() async {
    await _navigationService.replaceWith(Routes.signInView);
    notifyListeners();
  }
}

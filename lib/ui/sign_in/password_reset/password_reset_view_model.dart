import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/services/services.dart';

class PasswordResetViewModel extends BaseViewModel {
  static final _authService = locator<AuthImplementation>();

  String _email = '';
  String _error = '';

  String emailValidator(String val) {
    return val.contains('@') ? null : 'Enter a valid email';
  }

  String get email {
    return _email;
  }

  String getError() => _error;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  void _updateErrorEmail() {
    _error = 'Email is invalid. Try again';
    notifyListeners();
  }

  Future<void> sendEmail() async {
    dynamic result = await _authService.resetPassword(_email);
    if (result == null) {
      print('error reset');
      _updateErrorEmail();
    }
  }
}

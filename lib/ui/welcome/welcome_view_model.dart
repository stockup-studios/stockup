import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';

class WelcomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void signIn() {
    _navigationService.navigateTo(Routes.signInView);
    notifyListeners();
  }

  void signUp() {
    _navigationService.navigateTo(Routes.signUpView);
    notifyListeners();
  }
}

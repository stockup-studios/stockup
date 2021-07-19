import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/services/services.dart';

class UserHomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  static final _authService = locator<AuthImplementation>();

  void init() async {
    print('home view model init called');
    notifyListeners();
  }

  void signOut() async {
    await _authService.signOut();
    _navigationService.replaceWith(Routes.welcomeView);
  }

  final List<List<String>> messages = [
    [
      '1 Item Expired',
      'Yesterday | Marigold HL Milk',
    ],
    [
      '2 Items Expiring Soon',
      '2 days | Golden Churn Butter Block - Salted',
      '3 days | UFC Refresh 100% Natural Coconut Water',
    ],
    [
      '1 Shared List',
      'Click to view',
    ],
  ];
}

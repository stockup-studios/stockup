import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserItemShareViewModel extends BaseViewModel {
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  final _navigationService = locator<NavigationService>();
  static final _authService = locator<AuthImplementation>();

  UserItemList userItemList;
  List<String> sharedUsersEmail = [];

  String _shareWithEmail = '';
  String errorMessage = '';

  void init(UserItemList uiList) async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userItemList = uiList;
    await sharedUsersDB();
    notifyListeners();
  }

  Future<void> sharedUsersDB() async {
    sharedUsersEmail.clear();
    sharedUsersEmail = await _database.getItemListUsers(userItemList);
  }

  void shareWith(String input) {
    if (input.contains('@')) {
      _shareWithEmail = input;
      notifyListeners();
    }
  }

  Future<bool> share() async {
    dynamic temp;
    temp = await _database.getUserByEmail(_shareWithEmail);
    _shareWithEmail = '';

    if (temp != null) {
      await _database.updateSharedUserItemList(userItemList, temp);
      await sharedUsersDB();
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that email';
    }
    notifyListeners();
    return errorMessage == '';
  }

  Future navigateToUserItem() async {
    await _navigationService.replaceWith(Routes.userItemView);
    notifyListeners();
  }
}

import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserShopShareViewModel extends BaseViewModel {
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();

  UserShopList userShopList;
  List<String> sharedUsersEmail = [];

  String _shareWith = '';
  String errorMessage = '';

  void init(UserShopList uiList) async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userShopList = uiList;
    await sharedUsersdb();
    print('shared email length is ${sharedUsersEmail.length}');
    notifyListeners();
  }

  Future<void> sharedUsersdb() async {
    sharedUsersEmail.clear();
    print('shared users list cleared');
    sharedUsersEmail = await _database.getShopListUsers(userShopList);
  }

  // String get shareWith {
  //   return _shareWith;
  // }

  void shareWith(String input) {
    if (input.contains('@')) {
      _shareWith = input;
      // } else {
      //   _shareWithName = input;
      // }
      notifyListeners();
    }
  }

  // set shareWith(String shareWith) {
  //   _shareWith = shareWith;
  //   notifyListeners();
  // }

  Future<bool> share() async {
    dynamic temp;
    temp = await _database.getUserbyEmail(_shareWith);
    _shareWith = '';

    if (temp != null) {
      await _database.updateSharedUserShopList(userShopList, temp);
      await sharedUsersdb();
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that email';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

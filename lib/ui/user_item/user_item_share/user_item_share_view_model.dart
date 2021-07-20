import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserItemShareViewModel extends BaseViewModel {
  final _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _db;

  UserItemList userItemList;
  List<AppUser> sharedUsers = [];

  String _shareWith = '';
  String errorMessage = '';

  void init(UserItemList uiList) async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userItemList = uiList;
    await sharedUsersdb();
  }

  Future<void> sharedUsersdb() async {
    sharedUsers = await _db.getItemListUsers(userItemList);
  }

  String get shareWith {
    return _shareWith;
  }

  set shareWith(String shareWith) {
    _shareWith = shareWith;
    notifyListeners();
  }

  Future<bool> share() async {
    dynamic temp = await _db.getUser(shareWith);

    if (temp != null) {
      await _db.updateSharedUserItemList(userItemList, temp);
      await sharedUsersdb();
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

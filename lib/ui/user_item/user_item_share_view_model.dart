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

  void init(UserItemList userItemList) async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    await getSharedUsers();
    this.userItemList = userItemList;
  }

  Future<void> getSharedUsers() async {
    sharedUsers = await _db.getItemListUsers(userItemList);
  }

  String get shareWith {
    return _shareWith;
  }

  set shareWith(String shareWith) {
    _shareWith = shareWith;
    notifyListeners();
  }

  Future<dynamic> user() async {
    dynamic temp = await _db.getUser(shareWith);
    return temp;
  }

  Future<bool> share() async {
    // TODO: Check if user exists. If user exist, then add. Otherwise display error
    // dynamic temp = await _db.getUser(shareWith);
    dynamic temp = await user();
    T cast<T>(x) => x is T ? x : null;
    AppUser appuser = cast<AppUser>(temp);
    if (user != null) {
      await _db.updateSharedUserItemList(userItemList, appuser);
      await getSharedUsers();
      //userItemList.shared.add(AppUser(username: shareWith));
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

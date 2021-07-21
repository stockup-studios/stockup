import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserItemShareViewModel extends BaseViewModel {
  final _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _db;

  UserItemList userItemList;
  List<String> sharedUsersName = [];

  String _shareWithEmail = '';
  String _shareWithName = '';
  String errorMessage = '';

  void init(UserItemList uiList) async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userItemList = uiList;
    print(userItemList.uid);
    await sharedUsersdb();
  }

  // void refresh(UserItemList uiList) async {
  //   _db = DatabaseServiceImpl(uid: _authService.appUser.username);
  //   this.userItemList = uiList;
  //   print(userItemList.uid);
  //   await sharedUsersdb();
  // }

  // Future<List<String>> getSharedUsers(UserItemList uiList) async {
  //   _db = DatabaseServiceImpl(uid: _authService.appUser.username);
  //   this.userItemList = uiList;
  //   print(userItemList.uid);
  //   await sharedUsersdb();
  // }

  Future<void> sharedUsersdb() async {
    sharedUsersName.clear();
    print('shared users list cleared');
    sharedUsersName = await _db.getItemListUsers(userItemList);
  }

  // String get shareWith {
  //   return _shareWithEmail;
  // }

  void shareWith(String input) {
    if (input.contains('@')) {
      _shareWithEmail = input;
    } else {
      _shareWithName = input;
    }
    notifyListeners();
  }

  // set shareWithEmail(String email) {
  //   _shareWith = shareWith;
  //   notifyListeners();
  // }

  Future<bool> share() async {
    dynamic temp;
    if (_shareWithEmail == '') {
      temp = await _db.getUserbyName(_shareWithName);
    } else {
      temp = await _db.getUserbyEmail(_shareWithEmail);
    }

    if (temp != null) {
      await _db.updateSharedUserItemList(userItemList, temp);
      await sharedUsersdb();
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username or email';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

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
  //DatabaseServiceImpl _db;

  UserItemList userItemList;
  List<String> sharedUsersEmail = [];

  String _shareWithEmail = '';
  //String _shareWithName = '';
  String errorMessage = '';

  void init(UserItemList uiList) async {
    //String useruid = _authService.appUser.username;
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userItemList = uiList;
    await sharedUsersdb();
    notifyListeners();
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
    sharedUsersEmail.clear();
    sharedUsersEmail = await _database.getItemListUsers(userItemList);
  }

  // String get shareWith {
  //   return _shareWithEmail;
  // }

  void shareWith(String input) {
    if (input.contains('@')) {
      _shareWithEmail = input;
      // } else {
      //   _shareWithName = input;
      // }
      notifyListeners();
    }
  }

  // set shareWithEmail(String email) {
  //   _shareWith = shareWith;
  //   notifyListeners();
  // }

  Future<bool> share() async {
    dynamic temp;
    // if (_shareWithEmail == '') {
    //   temp = await _db.getUserbyName(_shareWithName);
    //   _shareWithName = '';
    // } else {
    temp = await _database.getUserbyEmail(_shareWithEmail);
    _shareWithEmail = '';

    if (temp != null) {
      await _database.updateSharedUserItemList(userItemList, temp);
      await sharedUsersdb();
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username or email';
    }
    notifyListeners();
    return errorMessage == '';
  }

  Future navigateToUserItem() async {
    await _navigationService.replaceWith(Routes.userItemView);
    notifyListeners();
  }
}

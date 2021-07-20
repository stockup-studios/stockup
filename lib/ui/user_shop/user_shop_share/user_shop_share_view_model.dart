import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';

class UserShopShareViewModel extends BaseViewModel {
  UserShopList userShopList;
  String _shareWith = '';
  String errorMessage = '';

  String get shareWith {
    return _shareWith;
  }

  set shareWith(String shareWith) {
    _shareWith = shareWith;
    notifyListeners();
  }

  void init(UserShopList userShopList) {
    this.userShopList = userShopList;
  }

  bool share() {
    // TODO: Check if user exists. If user exist, then add. Otherwise display error
    if (true) {
      userShopList.shared.add(AppUser(username: shareWith));
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

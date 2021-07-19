import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';

class UserItemShareViewModel extends BaseViewModel {
  UserItemList userItemList;
  String _shareWith = '';
  String errorMessage = '';

  String get shareWith {
    return _shareWith;
  }

  set shareWith(String shareWith) {
    _shareWith = shareWith;
    notifyListeners();
  }

  void init(UserItemList userItemList) {
    this.userItemList = userItemList;
  }

  bool share() {
    // TODO: Check if user exists. If user exist, then add. Otherwise display error
    if (true) {
      userItemList.shared.add(AppUser(username: shareWith));
      errorMessage = '';
    } else {
      errorMessage = 'Could not find anyone with that username';
    }
    notifyListeners();
    return errorMessage == '';
  }
}

import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';

class UserController {
  int targetUserILIndex = 0;
  int targetUserSLIndex = 0;
  List<UserItemList> userILs = [];
  List<UserShopList> userSLs = [];

  /// add a new userItemList into userILs
  void addUserIL(String userILName) {
    UserItemList userItemList =
        userILName.isEmpty ? UserItemList() : UserItemList(name: userILName);
    userILs.add(userItemList);
  }

  /// remove a userItemList at index
  void delUserIL(int index) {
    userILs.removeAt(index);
  }

  /// add a new userShopList into userSLs
  void addUserSL(String userILName) {
    UserShopList userItemList =
        userILName.isEmpty ? UserShopList() : UserShopList(name: userILName);
    userSLs.add(userItemList);
  }

  /// remove a userItemList at index
  void delUserSL(int index) {
    userSLs.removeAt(index);
  }
}

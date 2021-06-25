import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';

class AppUser {
  final String username;
  List<UserItemList> userItemLists;
  List<UserShopList> userShopLists;

  AppUser({this.username});

  @override
  String toString() {
    return username;
  }
}

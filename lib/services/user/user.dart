import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';

class User {
  static List<UserItemList> uils = [
    UserItemList(name: 'Personal Item List'),
    UserItemList(name: 'Second Item List'),
  ];
  static List<UserShopList> usls = [
    UserShopList(name: 'Personal Shop List'),
    UserShopList(name: 'Second Shop List'),
  ];
  static UserItemList targetUserItemList = uils[0];
  static UserShopList targetUserShopList = usls[0];
  static String email = 'default.user@users.com';
}

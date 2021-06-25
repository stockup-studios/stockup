import 'package:stockup/models/app_user.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop.dart';

class UserShopList {
  String name = '';
  List<UserShop> itemListing = [];
  List<AppUser> shared = [];

  UserShopList([this.name = 'Default Shopping List']);

  // TODO: implement the following functionality with firebase
  void addItem(Product product) {}
  void delItem(Product product) {}
  void addUser(AppUser user) {}
  void delUser(AppUser user) {}
  void clear() {}
  void moveItem(Product item, UserItemList itemList) {}
}

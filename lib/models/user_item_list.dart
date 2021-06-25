import 'package:stockup/models/app_user.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_shop_list.dart';

class UserItemList {
  String name = '';
  List<UserItem> itemListing = [];
  List<AppUser> shared = [];

  UserItemList([this.name = 'Default Shopping List']);

  // TODO: implement the following functionality with firebase
  void addItem(Product product) {}
  void delItem(Product product) {}
  void addUser(AppUser user) {}
  void delUser(AppUser user) {}
  void clear() {}
  void moveItem(Product item, UserShopList shopList) {}
}

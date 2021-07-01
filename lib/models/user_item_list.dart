import 'package:flutter/cupertino.dart';
import 'package:stockup/models/app_user.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';

class UserItemList extends ChangeNotifier {
  String name = '';
  List<UserItem> userItemListing = [];
  List<AppUser> shared = [];

  UserItemList({this.name = 'Default Shopping List'});

  /// add item to userItemListing and sorts based on increasing expiry date
  /// (userItems expiring soon will appear first)
  void addUserItem(UserItem userItem) {
    userItemListing.add(userItem);
    userItemListing.sort((UserItem lhs, UserItem rhs) =>
        lhs.expiryDate.compareTo(rhs.expiryDate));
    notifyListeners();
  }

  /// remove first occurrence of item from userItemListing
  /// userItemListing remains sorted by increasing expiry date
  void delUserItem(UserItem userItem) {
    userItemListing.remove(userItem);
    notifyListeners();
  }

  /// remove userItem from userItemListing at specified index
  /// userItemListing remains sorted by increasing expiry date
  void delUserItemAtIndex(int index) {
    userItemListing.removeAt(index);
    notifyListeners();
  }

  /// add AppUser to shared users
  void addUser(AppUser appUser) {
    shared.add(appUser);
    notifyListeners();
  }

  /// remove AppUser from shared users
  void delUser(AppUser appUser) {
    shared.remove(appUser);
    notifyListeners();
  }

  /// clear userItemListing
  void clear() {
    userItemListing.clear();
    notifyListeners();
  }

  /// adds userItem at index from userItemListing to target userShopList
  /// userItem at given index will be removed from userItemListing
  void moveUserItemAtIndex(int index, UserShopList userShopList) {
    UserItem userItem = userItemListing[index];
    UserShop userShop = UserShop(
        productName: userItem.productName,
        productID: userItem.productID,
        category: userItem.category,
        imageURL: userItem.imageURL);
    userShopList.addShopItem(userShop);
    delUserItemAtIndex(index);
    notifyListeners();
  }
}

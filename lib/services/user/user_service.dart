import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'user.dart';

/// retrieves data from static User model
/// Use for testing only!
class UserService {
  List<UserItemList> uils = User.uils;
  List<UserShopList> usls = User.usls;
  UserItemList targetUserItemList = User.targetUserItemList;
  UserShopList targetUserShopList = User.targetUserShopList;
  String email = User.email;

  List<UserItemList> getUILs() {
    return uils;
  }

  List<UserShopList> getUSLs() {
    return usls;
  }

  UserItemList getTargetUIL() {
    return targetUserItemList;
  }

  void setTargetUIL(UserItemList newTarget) {
    targetUserItemList = newTarget;
  }

  UserShopList getTargetUSL() {
    return targetUserShopList;
  }

  void setTargetUSL(UserShopList newTarget) {
    targetUserShopList = newTarget;
  }

  /// add item to userItemListing and sorts based on increasing expiry date
  /// (userItems expiring soon will appear first)
  void addUserItem(UserItem newItem) {
    targetUserItemList.userItemListing.add(newItem);
    targetUserItemList.userItemListing.sort((UserItem lhs, UserItem rhs) =>
        lhs.expiryDate.compareTo(rhs.expiryDate));
  }

  /// remove userItem from userItemListing at specified index
  /// userItemListing remains sorted by increasing expiry date
  void delUserItemAtIndex(int index) {
    targetUserItemList.userItemListing.removeAt(index);
  }

  /// adds userItem at index from userItemListing to target userShopList
  /// userItem at given index will be removed from userItemListing
  void moveUserItemAtIndex(int index) {
    UserItem userItem = targetUserItemList.userItemListing[index];
    UserShop userShop = UserShop(
        productName: userItem.productName,
        productID: userItem.productID,
        category: userItem.category,
        imageURL: userItem.imageURL);
    targetUserShopList.addShopItem(userShop);
    delUserItemAtIndex(index);
  }

  /// add one quantity of userShop to userShopListing
  void addUserShop(UserShop userShop) {
    int index = targetUserShopList.userShopListing.indexOf(userShop);
    if (index == -1) {
      targetUserShopList.userShopListing.add(userShop);
      return;
    }
    targetUserShopList.userShopListing[index].addQuantity();
  }

  /// remove one quantity of userShop from userShopListing
  /// if only one userShop left, userShop will be removed from list
  ///
  /// prints delShopItem::ItemMissingError to console if userShop does not exist
  void delUserShop(UserShop userShop) {
    int index = targetUserShopList.userShopListing.indexOf(userShop);
    if (index == -1) {
      print(
          'delShopItem::ItemMissingError for $userShop in ${targetUserShopList.userShopListing}');
    } else if (targetUserShopList.userShopListing[index].quantity == 0) {
      targetUserShopList.userShopListing.removeAt(index);
    } else if (targetUserShopList.userShopListing[index].quantity > 0) {
      targetUserShopList.userShopListing[index].delQuantity();
    }
  }

  /// userShop will be removed from list
  /// has the effect of removing all quantity of userShop from userShopListing
  ///
  /// prints delShopItem::ItemMissingError to console if userShop does not exist
  void delAllUserShop(UserShop userShop) {
    int index = targetUserShopList.userShopListing.indexOf(userShop);
    if (index == -1) {
      print(
          'delShopItem::ItemMissingError for $userShop in ${targetUserShopList.userShopListing}');
    } else {
      targetUserShopList.userShopListing.remove(userShop);
    }
  }

  /// adds userItem at index from userShopListing to target itemList
  /// userItem at given index will be removed from userShopListing
  void moveShopItemAtIndex(int index, UserItemList itemList) {
    UserShop userShop = targetUserShopList.userShopListing[index];
    UserItem userItem = UserItem(
        productName: userShop.productName,
        productID: userShop.productID,
        category: userShop.category,
        imageURL: userShop.imageURL);
    itemList.addUserItem(userItem);
    delUserShop(userShop);
  }
}

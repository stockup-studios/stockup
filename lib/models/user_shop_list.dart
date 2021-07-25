import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/models/app_user.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop.dart';

class UserShopList {
  String name = '';
  String uid;
  List<UserShop> userShopListing = [];
  List<AppUser> shared = [];

  UserShopList({this.name, this.uid});

  factory UserShopList.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return UserShopList(name: json['name'], uid: json['uid']);
  }

  get userItemListing => null;

  Map<String, dynamic> toJson() {
    return {'name': name, 'uid': uid};
  }

  UserShopList.demo(this.name);

  @override
  bool operator ==(Object other) {
    return (other is UserShopList) &&
        (this.name == other.name) &&
        (this.uid == other.uid);
  }

  /// add one quantity of userShop to userShopListing
  void addShopItem(UserShop userShop) {
    int index = userShopListing.indexOf(userShop);
    if (index == -1) {
      userShopListing.add(userShop);
      return;
    }
    userShopListing[index].addQuantity();
  }

  /// remove one quantity of userShop from userShopListing
  /// if only one userShop left, userShop will be removed from list
  ///
  /// prints delShopItem::ItemMissingError to console if userShop does not exist
  void delShopItem(UserShop userShop) {
    int index = userShopListing.indexOf(userShop);
    if (index == -1) {
      print('delShopItem::ItemMissingError for $userShop in $userShopListing');
    } else if (userShopListing[index].quantity == 0) {
      userShopListing.removeAt(index);
    } else if (userShopListing[index].quantity > 0) {
      userShopListing[index].delQuantity();
    }
  }

  /// userShop will be removed from list
  /// has the effect of removing all quantity of userShop from userShopListing
  ///
  /// prints delShopItem::ItemMissingError to console if userShop does not exist
  void delAllShopItem(UserShop userShop) {
    int index = userShopListing.indexOf(userShop);
    if (index == -1) {
      print('delShopItem::ItemMissingError for $userShop in $userShopListing');
    } else {
      userShopListing.remove(userShop);
    }
  }

  /// add AppUser to shared users
  void addUser(AppUser appUser) {
    shared.add(appUser);
  }

  /// remove AppUser from shared users
  void delUser(AppUser appUser) {
    shared.remove(appUser);
  }

  /// clear userShopListing
  void clear() {
    userShopListing.clear();
  }

  /// adds userItem at index from userShopListing to target itemList
  /// userShop at given index will be removed from userShopListing
  void moveShopItem(UserShop userShop, UserItemList itemList) {
    UserItem userItem = UserItem(
        productName: userShop.productName,
        productID: userShop.productID,
        category: userShop.category,
        imageURL: userShop.imageURL);
    itemList.addUserItem(userItem);
    delShopItem(userShop);
  }

  /// adds userItem at index from userShopListing to target itemList
  /// userItem at given index will be removed from userShopListing
  void moveShopItemAtIndex(int index, UserItemList itemList) {
    UserShop userShop = userShopListing[index];
    UserItem userItem = UserItem(
        productName: userShop.productName,
        productID: userShop.productID,
        category: userShop.category,
        imageURL: userShop.imageURL);
    itemList.addUserItem(userItem);
    delShopItem(userShop);
  }
}

import 'package:flutter/material.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:stockup/business_logic/userData/userData_basemodel.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database_impl.dart';

class UserData extends ChangeNotifier implements UserDataBaseModel {
  AppUser user;
  DatabaseServiceImpl _db;
  Map<String, dynamic> credentials;

  List<UserItem> _items =
      SortedList<UserItem>((r1, r2) => r2.expiryDate.compareTo(r1.expiryDate));

  /// Initialize with UserData.
  @override
  Future<void> init(AppUser user) async {
    this.user = user;

    _items.clear();

    //_db = DatabaseServiceImpl(this.uid: user.username);
    //credentials = await _db.getCredentials();

    //List<UserItem> unorderedItems = await _db.getUserItems();

    //_items.addAll(unorderedItems);
  }

  /// CREATE
  @override
  Future<void> addUserItem(UserItem item, bool toDatabase) async {
    _items.add(item);
    notifyListeners();

    Future<String> uid = _db.addUserItem(item, UserItemList());
    item.uid = await uid;
    _db.updateUserItem(item, UserItemList());

    if (toDatabase) {
      _db.updateGiantItem(item);
    }
  }

  /// READ
  @override
  List<UserItem> get items => _items;

  /// UPDATE
  @override
  Future<void> updateItem(UserItem item) async {
    _db.updateUserItem(item, UserItemList());
  }

  /// Clear all demo data and initialize the user with empty state.
  @override
  Future<void> demoDone() async {
    credentials['isDemo'] = false;
    items.forEach((item) => _db.deleteUserItem(item, UserItemList()));

    items.clear();
    notifyListeners();

    _db.updateCredentials(credentials);
  }

  /// DELETE
  @override
  Future<void> deleteUserItem(UserItem item) async {
    _items.removeWhere((itm) => itm.uid == item.uid);
    _db.deleteUserItem(item, UserItemList());
  }
}

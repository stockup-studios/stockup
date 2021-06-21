import 'package:flutter/material.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:stockup/business_logic/userData/userData_basemodel.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database_impl.dart';

class UserData extends ChangeNotifier implements UserDataBaseModel {
  AppUser user;
  DatabaseServiceImpl _db;
  Map<String, dynamic> credentials;

  List<Item> _items =
      SortedList<Item>((r1, r2) => r2.expiredDate.compareTo(r1.expiredDate));

  /// Initialize with UserData.
  @override
  Future<void> init(AppUser user) async {
    this.user = user;

    _items.clear();

    _db = DatabaseServiceImpl(uid: user.uid);
    credentials = await _db.getCredentials();

    List<Item> unorderedItems = await _db.getUserItems();

    _items.addAll(unorderedItems);
  }

  /// CREATE
  @override
  Future<void> addUserItem(Item item, bool toDatabase) async {
    _items.add(item);
    notifyListeners();

    Future<String> uid = _db.addUserItem(item);
    item.uid = await uid;
    _db.updateUserItem(item);

    if (toDatabase) {
      _db.updateGiantItem(item);
    }
  }

  /// READ
  @override
  List<Item> get items => _items;

  /// UPDATE
  @override
  Future<void> updateItem(Item item) async {
    _db.updateUserItem(item);
  }

  /// Clear all demo data and initialize the user with empty state.
  @override
  Future<void> demoDone() async {
    credentials['isDemo'] = false;
    items.forEach((item) => _db.deleteItem(item));

    items.clear();
    notifyListeners();

    _db.updateCredentials(credentials);
  }

  /// DELETE
  @override
  Future<void> deleteUserItem(Item item) async {
    _items.removeWhere((itm) => itm.uid == item.uid);
    _db.deleteItem(item);
  }
}

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserItemDetailViewModel extends BaseViewModel {
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  //DatabaseServiceImpl _db;

  UserItemList currentList;
  UserItem userItem;
  String _name = '';
  ProductCategory _category;
  DateTime _expiry;
  String _error = '';

  ProductCategory get category {
    return _category;
  }

  set category(ProductCategory category) {
    _category = category;
    notifyListeners();
  }

  DateTime get expiry {
    return _expiry;
  }

  set expiry(DateTime expiry) {
    _expiry = expiry;
    notifyListeners();
  }

  String get name {
    return _name;
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String getError() {
    return _error;
  }

  void _updateErrorExpiry() {
    _error = 'Item expired. Cannot change expiry date anymore';
    notifyListeners();
  }

  void changeExpiry(BuildContext context) async {
    if (expiry.isBefore(DateTime.now())) {
      _updateErrorExpiry();
    }
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: expiry,
      // DateTime.fromMillisecondsSinceEpoch(
      //     model.displayList[index].expiryDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
    );
    if (newDate != null) expiry = newDate;
  }

  void init(UserItem ui, UserItemList list) {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    userItem = ui;
    currentList = list;
    name = userItem.productName;
    category = userItem.category;
    expiry = DateTime.fromMillisecondsSinceEpoch(userItem.expiryDate);
  }

  void save() {
    userItem.productName = name;
    userItem.category = category;
    userItem.expiryDate = expiry.millisecondsSinceEpoch;
    _database.updateUserItem(userItem, currentList);
    notifyListeners();
  }
}

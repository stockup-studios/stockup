import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/models/user_item.dart';

class UserItemDetailViewModel extends BaseViewModel {
  UserItem userItem;
  String _name = '';
  ProductCategory _category;
  DateTime _expiry;

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

  void changeExpiry(BuildContext context) async {
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

  void init(UserItem ui) {
    userItem = ui;
    name = userItem.productName;
    category = userItem.category;
    expiry = DateTime.fromMillisecondsSinceEpoch(userItem.expiryDate);
  }

  void save() {
    userItem.productName = name;
    userItem.category = category;
    userItem.expiryDate = expiry.millisecondsSinceEpoch;
    notifyListeners();
  }
}

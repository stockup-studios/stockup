import 'package:flutter/material.dart';
import 'package:stockup/business_logic/item/item_basemodel.dart';
import 'package:stockup/business_logic/userData/userData_viewmodel.dart';
import 'package:stockup/models/item.dart';
import 'package:stockup/services/database/database_impl.dart';

class ItemViewModel extends ChangeNotifier implements ItemBaseModel {
  UserData userData;
  List<Item> categories;
  DatabaseServiceImpl _db;

  /// Initialize the model with UserData.
  @override
  void init(UserData userData) {
    this.userData = userData;
  }

  List<Item> tempItems;
  Item editItem;
  bool isEditing = false;
  bool isScanned = false;
  bool isOperated = false;
  String expression;

  /// Get data from image
  /// TODO: Scanner implementation has changed. Need to update this method!
  @override
  Future<void> imageToTempItem() async {
    // List<String> productNames = await Scanner.extractDataFromTxt();
    List<String> productNames;

    for (String name in productNames) {
      List<Item> match = await _db.searchGiantItems(name);
      for (Item item in match) {
        item.addedDate = DateTime.now();
      }
      tempItems.addAll(match);
    }

    notifyListeners();
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';
import 'package:flutter/foundation.dart';

class UserItem extends Product {
  final int productID;
  ProductCategory category;
  String productName;
  final String imageURL;
  String uid;
  int addedDate; // time added in milli seconds in relation to epoch time
  int expiryDate; // time of expiry in milli seconds in relation to epoch time

  UserItem(
      {@required this.productName,
      @required this.productID,
      @required this.category,
      @required this.imageURL,
      this.uid,
      this.expiryDate})
      : super(
            productName: productName,
            productID: productID,
            category: category,
            imageURL: imageURL) {
    addedDate = _getCurrentTime();
  }

  UserItem.demo(this.productName, this.category, this.imageURL, this.productID,
      this.expiryDate);

  int _getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  factory UserItem.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return UserItem(
        productName: json['product_name'],
        uid: json['uid'],
        category:
            CategoryExtension.getCategory(json['product_category'].toString()),
        imageURL: json['product_img_url'],
        productID: json['product_code'],
        expiryDate: json['expiry_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'uid': uid,
      'product_category': category.name,
      'product_img_url': imageURL,
      'product_code': productID,
      'expiry_date': expiryDate,
    };
  }

  /// estimates expiry date to one day from current time
  int _getEstimatedExpiry() {
    DateTime now = DateTime.now();
    if (expiryDate == null) {
      switch (category) {
        // case ProductCategory.bakery_cereals_spreads:
        //   return now.add(Duration(days: 4)).millisecondsSinceEpoch;
        // case ProductCategory.beers_wines_spirits:
        //   return now.add(Duration(days: 30)).millisecondsSinceEpoch;
        // case ProductCategory.dairy_chilled_frozen:
        //   return now.add(Duration(days: 5)).millisecondsSinceEpoch;
        // case ProductCategory.food_pantry:
        //   return now.add(Duration(days: 5)).millisecondsSinceEpoch;
        // case ProductCategory.fruit_vegetables:
        //   return now.add(Duration(days: 2)).millisecondsSinceEpoch;
        // case ProductCategory.meats_seafood:
        //   return now.add(Duration(days: 1)).millisecondsSinceEpoch;
        // case ProductCategory.snacks_drinks:
        //   return now.add(Duration(days: 1)).millisecondsSinceEpoch;
        default:
          return now
              .add(Duration(days: Random().nextInt(30) + 1))
              .millisecondsSinceEpoch;
      }
    } else {
      return expiryDate;
    }
  }

  static int getRecommendedExpiry(ProductCategory category) {
    DateTime current = DateTime.now();
    DateTime today = DateTime(current.year, current.month, current.day);
    switch (category) {
      case ProductCategory.bakery_cereals_spreads:
        return today.add(Duration(days: 7)).millisecondsSinceEpoch;
      case ProductCategory.beers_wines_spirits:
        return today.add(Duration(days: 60)).millisecondsSinceEpoch;
      case ProductCategory.dairy_chilled_frozen:
        return today.add(Duration(days: 5)).millisecondsSinceEpoch;
      case ProductCategory.food_pantry:
        return today.add(Duration(days: 30)).millisecondsSinceEpoch;
      case ProductCategory.fruit_vegetables:
        return today.add(Duration(days: 4)).millisecondsSinceEpoch;
      case ProductCategory.meats_seafood:
        return today.add(Duration(days: 3)).millisecondsSinceEpoch;
      case ProductCategory.snacks_drinks:
        return today.add(Duration(days: 40)).millisecondsSinceEpoch;
      case ProductCategory.others:
        return today.add(Duration(days: 1)).millisecondsSinceEpoch;
      default:
        return today.millisecondsSinceEpoch;
    }
  }

  /// update expiry date
  void updateExpiry(int millisecondsSinceEpoch) {
    expiryDate = millisecondsSinceEpoch;
  }

  int get daysLeft {
    int expiry = _getEstimatedExpiry();
    DateTime current = DateTime.now();
    DateTime today = DateTime(current.year, current.month, current.day);
    Duration difference =
        DateTime.fromMillisecondsSinceEpoch(expiry).difference(today);
    return (difference.inDays);
  }

  int get forCompare {
    return -daysLeft;
  }
}

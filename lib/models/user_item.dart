import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';
import 'package:flutter/foundation.dart';

class UserItem extends Product {
  final int productID;
  final ProductCategory category;
  final String productName;
  final String imageURL;
  String uid;
  int addedDate; // time added in milli seconds in relation to epoch time
  int expiryDate; // time of expiry in milli seconds in relation to epoch time

  // TO-DO check if addedDate might result in bugs
  UserItem(
      {@required this.productName,
      @required this.productID,
      @required this.category,
      @required this.imageURL,
      this.uid})
      : super(
            productName: productName,
            productID: productID,
            category: category,
            imageURL: imageURL) {
    addedDate = _getCurrentTime();
    expiryDate = _getEstimatedExpiry();
  }

  UserItem.demo(this.productName, this.category, this.imageURL, this.productID, this.expiryDate);

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'uid': uid,
      'product_category': category.name,
      'product_img_url': imageURL,
      'addedDate': addedDate,
    };
  }

  /// estimates expiry date to one day from current time
  int _getEstimatedExpiry() {
    DateTime now = DateTime.now();
    return now.add(const Duration(days: 1)).millisecondsSinceEpoch;
  }

  /// update expiry date
  void updateExpiry(int millisecondsSinceEpoch) {
    expiryDate = millisecondsSinceEpoch;
  }
}
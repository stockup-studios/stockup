import 'package:flutter/cupertino.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';
import 'package:flutter/foundation.dart';

class UserItem extends Product {
  final int productID;
  final ProductCategory category;
  final String productName;
  final String imageURL;
  int addedDate; // time added in milli seconds in relation to epoch time
  int expiryDate; // time of expiry in milli seconds in relation to epoch time

  UserItem(
      {@required this.productName,
      @required this.productID,
      @required this.category,
      @required this.imageURL})
      : super(
            productName: productName,
            productID: productID,
            category: category,
            imageURL: imageURL) {
    addedDate = _getCurrentTime();
    expiryDate = _getEstimatedExpiry();
  }

  int _getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
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

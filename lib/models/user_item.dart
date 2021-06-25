import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';

class UserItem extends Product {
  int addedDate; // time added in milli seconds in relation to epoch time
  int expiryDate; // time of expiry in milli seconds in relation to epoch time

  UserItem(int productID, ProductCategory category, String productName,
      String imageURL)
      : super(productID, category, productName, imageURL) {
    this.addedDate = _getCurrentTime();
    this.expiryDate = _getEstimatedExpiry();
  }

  int _getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// estimates expiry date to one day from current time
  /// TODO: Return expiry date based on ProductCategory
  int _getEstimatedExpiry() {
    DateTime now = DateTime.now();
    return now.add(const Duration(days: 1)).millisecondsSinceEpoch;
  }

  void updateExpiry(int millisecondsSinceEpoch) {
    expiryDate = millisecondsSinceEpoch;
  }
}

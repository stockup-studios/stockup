import 'package:stockup/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:stockup/models/product_category.dart';

class UserShop extends Product {
  int quantity;

  UserShop(
      {@required int productID,
      @required ProductCategory category,
      @required String productName,
      @required String imageURL})
      : super(
            productName: productName,
            productID: productID,
            category: category,
            imageURL: imageURL) {
    this.quantity = 1;
  }

  void addQuantity() {
    ++quantity;
  }

  void delQuantity() {
    --quantity;
  }

  @override
  bool operator ==(Object other) {
    return (other is UserShop) &&
        (this.productName == other.productName) &&
        (this.productID == other.productID) &&
        (this.category == other.category) &&
        (this.imageURL == other.imageURL);
  }
}

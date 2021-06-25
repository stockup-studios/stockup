import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';

class UserShop extends Product {
  int quantity;

  UserShop(int productID, ProductCategory category, String productName,
      String imageURL)
      : super(productID, category, productName, imageURL) {
    this.quantity = 1;
  }

  void addQuantity() {
    ++quantity;
  }

  void delQuantity() {
    --quantity;
  }
}

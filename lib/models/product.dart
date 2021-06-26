import 'product_category.dart';
import 'package:flutter/foundation.dart';

class Product {
  final int productID;
  final ProductCategory category;
  final String productName;
  final String imageURL;

  Product(
      {@required this.productID,
      @required this.category,
      @required this.productName,
      @required this.imageURL});
}

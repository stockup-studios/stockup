import 'product_category.dart';

class Product {
  final int productID;
  final ProductCategory category;
  final String productName;
  final String imageURL;

  Product(this.productID, this.category, this.productName, this.imageURL);
}

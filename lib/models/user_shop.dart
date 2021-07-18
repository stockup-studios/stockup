import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:stockup/models/product_category.dart';

class UserShop extends Product {
  final int productID;
  ProductCategory category;
  final String productName;
  final String imageURL;
  int quantity;
  String uid;
  String listUid; // for default data

  UserShop(
      {@required this.productID,
      @required this.category,
      @required this.productName,
      @required this.imageURL,
      this.uid})
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

  UserShop.demo(this.productName, this.category, this.imageURL, this.productID,
      this.quantity);

  factory UserShop.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return UserShop(
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
      'product_code': productID,
    };
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

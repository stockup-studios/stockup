import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_category.dart';
import 'package:flutter/foundation.dart';

class Product {
  final int productID;
  final String uid;
  final ProductCategory category;
  final String productName;
  final String imageURL;

  Product(
      {@required this.productID,
      @required this.category,
      @required this.productName,
      @required this.imageURL,
      this.uid});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return Product(
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
}

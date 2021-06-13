import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productName;
  String uid;
  String category;
  String imageURL;
  DateTime shelfLife;
  DateTime addedDate;

  Item(
      {this.productName,
      this.uid,
      this.category,
      this.imageURL,
      this.shelfLife,
      this.addedDate});

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return Item(
        productName: json['product_name'],
        uid: json['uid'],
        category: json['product_category'],
        imageURL: json['image_url'],
        shelfLife: DateTime.fromMillisecondsSinceEpoch(json['shelf_life']),
        addedDate: DateTime.fromMillisecondsSinceEpoch(json['addedDate']));
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'uid': uid,
      'product_category': category,
      'image_url': imageURL,
      'shelf_life': shelfLife.millisecondsSinceEpoch,
      'addedDate': addedDate.millisecondsSinceEpoch
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productName;
  String uid;
  String category;
  String imageURL;
  Duration shelfLife;
  DateTime addedDate;
  DateTime expiredDate;

  Item(
      {this.productName,
      this.uid,
      this.category,
      this.imageURL,
      this.shelfLife,
      this.addedDate,
      this.expiredDate});

  Item.demo(this.productName, this.category, this.imageURL, this.expiredDate);

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return Item(
        productName: json['product_name'],
        uid: json['uid'],
        category: json['product_category'],
        imageURL: json['image_url'],
        shelfLife: Duration(days: json['shelf_life']),
        addedDate: DateTime.fromMillisecondsSinceEpoch(json['addedDate']),
        expiredDate: DateTime.fromMillisecondsSinceEpoch(json['addedDate'])
            .add(Duration(hours: json['shelf_life'])));
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'uid': uid,
      'product_category': category,
      'image_url': imageURL,
      'shelf_life': shelfLife.inDays,
      'addedDate': addedDate.millisecondsSinceEpoch,
      'expiredDate': expiredDate.millisecondsSinceEpoch
    };
  }
}

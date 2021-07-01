import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String title;
  bool isShared;
  String uid;

  ShoppingList({this.title, this.isShared, this.uid});

  factory ShoppingList.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return ShoppingList(
        title: json['title'], isShared: json['is_Shared'], uid: json['uid']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'is_Shared': isShared, 'uid': uid};
  }
}


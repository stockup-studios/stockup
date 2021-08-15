import 'package:cloud_firestore/cloud_firestore.dart';

class UserShopList {
  String name = '';
  String uid;

  UserShopList({this.name, this.uid});

  factory UserShopList.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return UserShopList(name: json['name'], uid: json['uid']);
  }

  get userItemListing => null;

  Map<String, dynamic> toJson() {
    return {'name': name, 'uid': uid};
  }

  UserShopList.demo(this.name);

  @override
  bool operator ==(Object other) {
    return (other is UserShopList) &&
        (this.name == other.name) &&
        (this.uid == other.uid);
  }
}

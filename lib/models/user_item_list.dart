import 'package:cloud_firestore/cloud_firestore.dart';

class UserItemList {
  String name = '';
  String uid;
  

  UserItemList({this.name, this.uid});

  UserItemList.demo(this.name);

  factory UserItemList.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return UserItemList(name: json['name'], uid: json['uid']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'uid': uid};
  }

  @override
  bool operator ==(Object other) {
    return (other is UserItemList) &&
        (this.name == other.name) &&
        (this.uid == other.uid);
  }

}

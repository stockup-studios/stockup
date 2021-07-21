import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';

class AppUser {
  final String username;
  final String name;
  final String email;
  //List<UserItemList> userItemLists;
  //List<UserShopList> userShopLists;

  AppUser({this.username, this.name, this.email});

  @override
  String toString() {
    return username;
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return AppUser(
      username: json['uid'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': username,
      'name': name,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String username;
  //final String name;
  final String email;
  //List<UserItemList> userItemLists;
  //List<UserShopList> userShopLists;

  AppUser({this.username, this.email});

  @override
  String toString() {
    return username;
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();

    return AppUser(
      username: json['uid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': username,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final String uid;
  final CollectionReference groceryCollection =
      FirebaseFirestore.instance.collection('grocery');
  DocumentReference userDocument;
  CollectionReference itemCollection;

  DatabaseServiceImpl({this.uid}) {
    userDocument = FirebaseFirestore.instance.collection('users').doc(uid);
    itemCollection = userDocument.collection('items');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {}

  // Need ceate Item class & toJason() method: method to return
  // Map<String, dynamic> containing item info
  @override
  Future<String> addItem(Item item) async {
    final itemDocument = itemCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  Future<void> addCredentials(Map<String, dynamic> credentials) async {
    userDocument.set(credentials);
  }

  // Read
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot json = await userDocument.get();
    return json.data();
  }

  //To-Do
  Future<List<Item>> getItems() {

  };

  // Update
  Future<void> updateItem(Item item) {};

  // Delete
  Future<void> deleteItem(Item item) {};
}

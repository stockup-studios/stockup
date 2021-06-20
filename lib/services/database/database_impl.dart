import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/models/item.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final String uid;
  final CollectionReference giantCollection =
      FirebaseFirestore.instance.collection('Giant');
  DocumentReference userDocument;
  CollectionReference itemCollection;
  CollectionReference shoppingListCollection;

  DatabaseServiceImpl({this.uid}) {
    userDocument = FirebaseFirestore.instance.collection('users').doc(uid);
    itemCollection = userDocument.collection('items');
    shoppingListCollection = userDocument.collection('shopping_list');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {}

  @override
  Future<String> addUserItem(Item item) async {
    final itemDocument = itemCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addGiantItem(Item item) async {
    final itemDocument = giantCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<void> addCredentials(Map<String, dynamic> credentials) async {
    userDocument.set(credentials);
  }

  // Read
  @override
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot json = await userDocument.get();
    return json.data();
  }

  @override
  Future<List<Item>> getItems() async {
    List<QueryDocumentSnapshot> snapshots =
        await itemCollection.get().then((value) => value.docs);

    return snapshots.map((doc) => Item.fromFirestore(doc)).toList();
  }

  @override
  Future<List<Item>> getGiantItems() async {
    List<QueryDocumentSnapshot> snapshots =
        await giantCollection.get().then((value) => value.docs);

    return snapshots.map((doc) => Item.fromFirestore(doc)).toList();
  }

  // Update
  @override
  Future<void> updateItem(Item item) async {
    itemCollection.doc(item.uid).update(item.toJson());
  }

  @override
  Future<void> updateGiantItem(Item item) async {
    giantCollection.doc(item.uid).update(item.toJson());
  }

  // Delete
  @override
  Future<void> deleteItem(Item item) async {
    itemCollection.doc(item.uid).delete();
  }
}
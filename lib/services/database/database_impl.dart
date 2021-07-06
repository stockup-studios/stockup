import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/business_logic/defaultData/defaultData.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final String uid;
  final CollectionReference giantCollection =
      FirebaseFirestore.instance.collection('Giant');
  DocumentReference userDocument;
  CollectionReference userItemCollection;
  CollectionReference userShopCollection;
  CollectionReference userShopListCollection;

  DatabaseServiceImpl({this.uid}) {
    userDocument = FirebaseFirestore.instance.collection('users').doc(uid);
    userItemCollection = userDocument.collection('user_item');
    userShopCollection = userDocument.collection('user_shop');
    userShopListCollection = userDocument.collection('user_shop_list');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {
    Map<int, String> userShopMap = {}; //default shopping List data
    Map<int, String> userItemMap = {}; //default user inventory

    for (int i = 0; i < demoUserShopList.length; i++) {
      String categoryUid = await addUserShopList(demoUserShopList[i]);
      userShopMap[i] = categoryUid;
    }

    for (UserShop item in demoUserShop) {
      //linking shopping list item to correct shopping list
      item.listUid = userShopMap[item.listUid];
      await addUserShop(item);
    }
  }

  @override
  Future<String> addUserItem(UserItem item) async {
    final itemDocument = userItemCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addGiantItem(Product item) async {
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

  @override
  Future<String> addUserShop(UserShop item) async {
    final itemDocument = userShopCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addUserShopList(UserShopList list) async {
    final itemDocument = userShopListCollection.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = list.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  // Read
  @override
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot json = await userDocument.get();
    return json.data();
  }

  @override
  Future<List<UserItem>> getUserItems() async {
    List<QueryDocumentSnapshot> snapshots =
        await userItemCollection.get().then((value) => value.docs);

    return snapshots.map((doc) => UserItem.fromFirestore(doc)).toList();
  }

  @override
  Future<List<Product>> getGiantItems() async {
    List<QueryDocumentSnapshot> snapshots =
        await giantCollection.get().then((value) => value.docs);

    return snapshots.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // search item based on name returned from scanner
  Future<List<Product>> searchGiantItems(String name) async {
    List<QueryDocumentSnapshot> snapshot = await giantCollection
        .where('product_name' == name)
        .get()
        .then((value) => value.docs);
    return snapshot.map((doc) => Product.fromFirestore(doc));
  }

  // for parser
  Future<List<String>> productListing() async {
    List<QueryDocumentSnapshot> query =
        await giantCollection.get().then((value) => value.docs);
    List<Map<String, dynamic>> result = query.map((doc) => doc.data());
    return result.map((doc) => doc['product_name']).toList();
  }

  // Update
  @override
  Future<void> updateCredentials(Map<String, dynamic> credentials) async {
    userDocument.update(credentials);
  }

  @override
  Future<void> updateUserItem(UserItem item) async {
    userItemCollection.doc(item.uid).update(item.toJson());
  }

  // TODO: will we ever change details of existing giant items?
  @override
  Future<void> updateGiantItem(Product item) async {
    giantCollection.doc(item.uid).update(item.toJson());
  }

  // Delete
  @override
  Future<void> deleteUserItem(UserItem item) async {
    userItemCollection.doc(item.uid).delete();
  }
}

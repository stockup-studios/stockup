import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stockup/business_logic/defaultData/defaultData.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final String uid;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference giantCollection = _firestore.collection('Giant');
  final CollectionReference user_shop_lists =
      _firestore.collection('user_shop_lists');
  final CollectionReference user_item_lists =
      _firestore.collection('user_item_lists');
  DocumentReference userDocument;
  CollectionReference userShopListCollection; //user specific
  CollectionReference userItemListCollection; //user specific

  DatabaseServiceImpl({this.uid}) {
    userDocument = _firestore.collection('users').doc(uid);
    //userItemCollection = userDocument.collection('user_item');
    //userShopCollection = userDocument.collection('user_shop');
    userShopListCollection = userDocument.collection('user_shop_list');
    userItemListCollection = userDocument.collection('user_item_list');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {
    // put in default data for shop list and item list

    // //for shoplist
    // for (int i = 0; i < demoUserShopList.length; i++) {
    //   String shopUid = await addUserShopList(demoUserShopList[i]);
    //   demoUserShopList[i].uid = shopUid;
    //   updateUserShopList(demoUserShopList[i]);

    //   //put in shop item collection
    //   // demousershop is list of list of items
    //   for (UserShop item in demoUserShop[i]) {
    //     String itemUID = await addUserShop(item, demoUserShopList[i]);
    //     item.uid = itemUID;
    //     updateUserShop(item, demoUserShopList[i]);
    //   }
    // }

    // //for itemlist
    // for (int i = 0; i < demoUserItemList.length; i++) {
    //   String itemUid = await addUserItemList(demoUserItemList[i]);
    //   demoUserItemList[i].uid = itemUid;
    //   updateUserItemList(demoUserItemList[i]);

    //   //put in shop item collection
    //   // demousershop is list of list of items
    //   for (UserItem item in demoUserItems[i]) {
    //     String itemUID = await addUserItem(item, demoUserItemList[i]);
    //     item.uid = itemUID;
    //     updateUserItem(item, demoUserItemList[i]);
    //   }
    // }

    //for (int i = 0; i < demoUserShopList.length; i++) {
    //  await addUserShopListforUser(demoUserShopList[i]);
    //}

    for (int i = 0; i < demoUserItemList.length; i++) {
      addUserItemListforUser(demoUserItemList[i]);
    }
  }

  @override
  Future<String> addUserItem(UserItem item, UserItemList list) async {
    final itemDocument =
        user_item_lists.doc(list.uid).collection('user_item').doc();
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
  Future<String> addUserShop(UserShop item, UserShopList list) async {
    final itemDocument =
        user_shop_lists.doc(list.uid).collection('user_shop').doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addUserShopList(UserShopList list) async {
    final itemDocument = user_shop_lists.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = list.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addUserItemList(UserItemList list) async {
    final itemDocument = user_item_lists.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = list.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  Future<void> addUserItemListforUser(UserItemList list) async {
    List<QueryDocumentSnapshot> snapshots = await user_item_lists
        .where('name', isEqualTo: list.name)
        .get()
        .then((value) => value.docs);

    Map<String, dynamic> target = {
      'reference': snapshots[0].reference,
      'name': list.name
    };
    userItemListCollection.add(target);
  }

  // Read
  @override
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot json = await userDocument.get();
    return json.data();
  }

  @override
  //Future<List<UserItem>> getUserItems() async {
  //  List<QueryDocumentSnapshot> snapshots =
  //      await userItemCollection.get().then((value) => value.docs);

  //  return snapshots.map((doc) => UserItem.fromFirestore(doc)).toList();
  //}

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
  Future<void> updateUserItem(UserItem item, UserItemList list) async {
    user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .update(item.toJson());
  }

  Future<void> updateUserShop(UserShop item, UserShopList list) async {
    user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .update(item.toJson());
  }

  Future<void> updateUserShopList(UserShopList list) async {
    user_shop_lists.doc(list.uid).update(list.toJson());
  }

  Future<void> updateUserItemList(UserItemList list) async {
    user_item_lists.doc(list.uid).update(list.toJson());
  }

  // TODO: will we ever change details of existing giant items?
  @override
  Future<void> updateGiantItem(Product item) async {
    giantCollection.doc(item.uid).update(item.toJson());
  }

  // Delete
  @override
  Future<void> deleteUserItem(UserItem item, UserItemList list) async {
    user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .delete();
  }
}

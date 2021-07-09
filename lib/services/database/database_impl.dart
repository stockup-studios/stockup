import 'package:cloud_firestore/cloud_firestore.dart';
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
    userShopListCollection = userDocument.collection('user_shop_list');
    userItemListCollection = userDocument.collection('user_item_list');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {
    for (int i = 0; i < demoUserShopList.length; i++) {
      await addUserShopListforUser(demoUserShopList[i]);
    }

    for (int i = 0; i < demoUserItemList.length; i++) {
      await addUserItemListforUser(demoUserItemList[i]);
    }
  }

  @override
  //adding new item to pre-existing list
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

  @override
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

  @override
  Future<void> addUserShopListforUser(UserShopList list) async {
    List<QueryDocumentSnapshot> snapshots = await user_shop_lists
        .where('name', isEqualTo: list.name)
        .get()
        .then((value) => value.docs);

    Map<String, dynamic> target = {
      'reference': snapshots[0].reference,
      'name': list.name
    };
    userShopListCollection.add(target);
  }

  // Read
  @override
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot json = await userDocument.get();
    return json.data();
  }

  @override
  Future<List<UserItem>> getUserItems(UserItemList list) async {
    List<QueryDocumentSnapshot> snapshots = await user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .get()
        .then((value) => value.docs);

    return snapshots.map((doc) => UserItem.fromFirestore(doc)).toList();
  }

  @override
  Future<List<UserShop>> getUserShops(UserShopList list) async {
    List<QueryDocumentSnapshot> snapshots = await user_shop_lists
        .doc(list.uid)
        .collection('user_shop')
        .get()
        .then((value) => value.docs);

    return snapshots.map((doc) => UserShop.fromFirestore(doc)).toList();
  }

  @override
  Future<List<UserItemList>> getUserItemLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userItemListCollection.get().then((value) => value.docs);

    List<DocumentReference> reference =
        snapshots.map((snapshot) => snapshot.get(FieldPath(['reference'])));

    List<DocumentSnapshot> processed;

    for (int i = 0; i < reference.length; i++) {
      DocumentSnapshot temp = await reference[i].get();
      processed.add(temp);
    }
    return processed.map((doc) => UserItemList.fromFirestore(doc));
  }

  @override
  Future<List<UserShopList>> getUserShopLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userShopListCollection.get().then((value) => value.docs);

    List<DocumentReference> reference =
        snapshots.map((snapshot) => snapshot.get(FieldPath(['reference'])));

    List<DocumentSnapshot> processed;

    for (int i = 0; i < reference.length; i++) {
      DocumentSnapshot temp = await reference[i].get();
      processed.add(temp);
    }
    return processed.map((doc) => UserShopList.fromFirestore(doc));
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
  Future<void> updateUserItem(UserItem item, UserItemList list) async {
    user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .update(item.toJson());
  }

  @override
  Future<void> updateUserShop(UserShop item, UserShopList list) async {
    user_item_lists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .update(item.toJson());
  }

  @override
  Future<void> updateUserShopList(UserShopList list) async {
    user_shop_lists.doc(list.uid).update(list.toJson());
  }

  @override
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

  @override
  Future<void> deleteUserShop(UserShop item, UserShopList list) async {
    user_shop_lists
        .doc(list.uid)
        .collection('user_shop')
        .doc(item.uid)
        .delete();
  }

  @override
  Future<void> deleteUserItemList(UserItemList list) async {
    user_item_lists.doc(list.uid).delete();
  }

  @override
  Future<void> deleteUserShopList(UserShopList list) async {
    user_shop_lists.doc(list.uid).delete();
  }
}

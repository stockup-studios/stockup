import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/business_logic/defaultData/defaultData.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  //static final _authService = AuthImplementation();
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
  CollectionReference targetShopListCollection;
  CollectionReference targetItemListCollection;

  DatabaseServiceImpl({this.uid}) {
    userDocument = _firestore.collection('users').doc(uid);
    userShopListCollection = userDocument.collection('user_shop_list');
    userItemListCollection = userDocument.collection('user_item_list');
    targetShopListCollection = userDocument.collection("target_shop_list");
    targetItemListCollection = userDocument.collection('target_item_list');
  }

  // To-do: Initalize account with default data
  @override
  Future<void> initialize() async {
    for (int i = 0; i < demoUserShopList.length; i++) {
      String uid = await addUserShopList(demoUserShopList[i]);
      demoUserShopList[i].uid = uid;
      await addUserShopListforUser(demoUserShopList[i]);

      for (UserShop item in demoUserShop[i]) {
        String uid = await addUserShop(item, demoUserShopList[i]);
        item.uid = uid;
        await updateUserShop(item, demoUserShopList[i]);
      }
    }

    for (int i = 0; i < demoUserItemList.length; i++) {
      String uid = await addUserItemList(demoUserItemList[i]);
      demoUserItemList[i].uid = uid;
      await addUserItemListforUser(demoUserItemList[i]);

      for (UserItem item in demoUserItems[i]) {
        String uid = await addUserItem(item, demoUserItemList[i]);
        item.uid = uid;
        await updateUserItem(item, demoUserItemList[i]);
      }
    }

    await addTargetItemList(demoUserItemList[0]);
    await addTargetShopList(demoUserShopList[0]);
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
  //create new user_shop_list
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
  //create new user_item_list under user
  Future<String> addUserItemListforUser(UserItemList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await user_item_lists
          .where('name', isEqualTo: list.name)
          .get()
          .then((value) => value.docs);
      Map<String, dynamic> data =
          snapshot.map((e) => e.data()).toList().elementAt(0);
      uid = data['uid'];
    } else {
      uid = list.uid;
    }

    final listDocument = userItemListCollection.doc();
    Map<String, String> json = {'uid': uid};
    listDocument.set(json);
    return uid;
  }

  @override
  Future<String> addUserShopListforUser(UserShopList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await user_shop_lists
          .where('name', isEqualTo: list.name)
          .get()
          .then((value) => value.docs);
      Map<String, dynamic> data =
          snapshot.map((e) => e.data()).toList().elementAt(0);
      uid = data['uid'];
    } else {
      uid = list.uid;
    }

    final listDocument = userShopListCollection.doc();
    Map<String, String> json = {'uid': uid};
    listDocument.set(json);
    return uid;
  }

  @override
  Future<void> addTargetShopList(UserShopList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await user_shop_lists
          .where('name', isEqualTo: list.name)
          .get()
          .then((value) => value.docs);
      Map<String, dynamic> data =
          snapshot.map((e) => e.data()).toList().elementAt(0);
      uid = data['uid'];
    } else {
      uid = list.uid;
    }

    final listDocument = targetShopListCollection.doc();
    Map<String, String> json = {'uid': uid};
    listDocument.set(json);
  }

  @override
  Future<void> addTargetItemList(UserItemList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await user_item_lists
          .where('name', isEqualTo: list.name)
          .get()
          .then((value) => value.docs);
      Map<String, dynamic> data =
          snapshot.map((e) => e.data()).toList().elementAt(0);
      uid = data['uid'];
    } else {
      uid = list.uid;
    }

    final listDocument = targetItemListCollection.doc();
    Map<String, String> json = {'uid': uid};
    listDocument.set(json);
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
  Future<UserShopList> getTargetShopList() async {
    List<QueryDocumentSnapshot> snapshots =
        await targetShopListCollection.get().then((value) => value.docs);
    print(snapshots.length);
    Map data = snapshots.map((e) => e.data()).toList().elementAt(0);
    String uid = data['uid'];
    print(uid);
    DocumentSnapshot target = await user_shop_lists.doc(uid).get();
    return UserShopList.fromFirestore(target);
  }

  @override
  Future<UserItemList> getTargetItemList() async {
    List<QueryDocumentSnapshot> snapshots =
        await targetItemListCollection.get().then((value) => value.docs);
    Map data = snapshots.map((e) => e.data()).toList().elementAt(0);
    String uid = data['uid'];
    // print(uid); //YQQG0Jh3sEjpQvywUBMQ
    DocumentSnapshot target = await user_item_lists.doc(uid).get();
    return UserItemList.fromFirestore(target);
  }

  @override
  //get all user_item_list specific to user
  Future<List<UserItemList>> getUserItemLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userItemListCollection.get().then((value) => value.docs);
    List<DocumentSnapshot> processed;
    for (int i = 0; i < snapshots.length; i++) {
      Map data = snapshots.map((e) => e.data()).toList().elementAt(i);
      String uid = data['uid'];
      DocumentSnapshot target = await user_item_lists.doc(uid).get();
      processed.add(target);
    }
    return processed.map((doc) => UserItemList.fromFirestore(doc)).toList();
  }

  @override
  //get all user_shop_list specific to user
  Future<List<UserShopList>> getUserShopLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userShopListCollection.get().then((value) => value.docs);

    // List<DocumentReference> reference =
    //     snapshots.map((snapshot) => snapshot.get(FieldPath(["reference"])));

    // List<DocumentSnapshot> processed;

    // for (int i = 0; i < reference.length; i++) {
    //   DocumentSnapshot temp = await reference[i].get();
    //   processed.add(temp);
    // }
    // return processed.map((doc) => UserShopList.fromFirestore(doc));

    List<DocumentSnapshot> processed;
    for (int i = 0; i < snapshots.length; i++) {
      Map data = snapshots.map((e) => e.data()).toList().elementAt(i);
      String uid = data['uid'];
      DocumentSnapshot target = await user_shop_lists.doc(uid).get();
      processed.add(target);
    }
    return processed.map((doc) => UserShopList.fromFirestore(doc)).toList();
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

  @override
  Future<void> updateTargetItemList(UserItemList list) async {
    //delete original
    List<QueryDocumentSnapshot> snapshots =
        await targetItemListCollection.get().then((value) => value.docs);
    //get document reference and delete
    List<DocumentReference> doc = snapshots.map((e) => e.reference);
    for (int i = 0; i < doc.length; i++) {
      doc[i].delete();
    }
    //add new list
    addTargetItemList(list);
  }

  @override
  Future<void> updateTargetShopList(UserShopList list) async {
    //delete original
    List<QueryDocumentSnapshot> snapshots =
        await targetShopListCollection.get().then((value) => value.docs);
    //get document reference and delete
    List<DocumentReference> doc = snapshots.map((e) => e.reference);
    for (int i = 0; i < doc.length; i++) {
      doc[i].delete();
    }
    //add new list
    addTargetShopList(list);
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

  @override
  Future<void> deleteUserItemListforUser(UserItemList list) async {
    List<QueryDocumentSnapshot> snapshots = await userItemListCollection
        .where('uid'.toString(), isEqualTo: list.uid.toString())
        .get()
        .then((value) => value.docs);
    //get document reference and delete
    DocumentReference doc = snapshots[0].reference;
    doc.delete();
  }

  @override
  Future<void> deleteUserShopListforUser(UserShopList list) async {
    List<QueryDocumentSnapshot> snapshots = await userShopListCollection
        .where('name', isEqualTo: list.name)
        .get()
        .then((value) => value.docs);
    //get document reference and delete
    DocumentReference doc = snapshots[0].reference;
    doc.delete();
  }
}

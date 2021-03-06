import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:stockup/business_logic/default_data/default_data.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final String uid;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference giantCollection = _firestore.collection('Giant');

  final CollectionReference userShopLists =
      _firestore.collection('user_shop_lists');
  final CollectionReference userItemLists =
      _firestore.collection('user_item_lists');

  DocumentReference userDocument;
  CollectionReference userShopListCollection; //user specific
  CollectionReference userItemListCollection; //user specific
  CollectionReference targetShopListCollection;
  CollectionReference targetItemListCollection;
  DocumentReference userItemExpiredDoc;

  DatabaseServiceImpl({this.uid}) {
    userDocument = _firestore.collection('users').doc(uid);
    userShopListCollection = userDocument.collection('user_shop_list');
    userItemListCollection = userDocument.collection('user_item_list');
    targetShopListCollection = userDocument.collection("target_shop_list");
    targetItemListCollection = userDocument.collection('target_item_list');

    userItemExpiredDoc =
        userDocument.collection('expired_items').doc('records');
  }

  @override
  Future<void> initialize() async {
    for (int i = 0; i < demoUserShopList.length; i++) {
      String uid = await addUserShopList(demoUserShopList[i]);
      demoUserShopList[i].uid = uid;
      await addUserShopListForUser(demoUserShopList[i]);

      for (UserShop item in demoUserShop[i]) {
        String uid = await addUserShop(item, demoUserShopList[i]);
        item.uid = uid;
        await updateUserShop(item, demoUserShopList[i]);
      }
    }

    for (int i = 0; i < demoUserItemList.length; i++) {
      String uid = await addUserItemList(demoUserItemList[i]);
      demoUserItemList[i].uid = uid;
      await addUserItemListForUser(demoUserItemList[i]);

      for (UserItem item in demoUserItems[i]) {
        String uid = await addUserItem(item, demoUserItemList[i]);
        item.uid = uid;
        await updateUserItem(item, demoUserItemList[i]);
      }
    }

    await addTargetItemList(demoUserItemList[0]);
    await addTargetShopList(demoUserShopList[0]);

    final expiredDocument =
        userDocument.collection('expired_items').doc('records');
    expiredDocument.set(expiredItems);
  }

  /// Create Operations

  /// add new item to existing list
  @override
  Future<String> addUserItem(UserItem item, UserItemList list) async {
    final itemDocument =
        userItemLists.doc(list.uid).collection('user_item').doc();
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
    // will have email and uid
    userDocument.set(credentials);
  }

  @override
  Future<String> addUserShop(UserShop item, UserShopList list) async {
    final itemDocument =
        userShopLists.doc(list.uid).collection('user_shop').doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = item.toJson();
    json['uid'] = uid;
    itemDocument.set(json);
    return uid;
  }

  /// create new userShopLists
  @override
  Future<String> addUserShopList(UserShopList list) async {
    final itemDocument = userShopLists.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = list.toJson();
    json['uid'] = uid;
    Map data = await userDocument.get().then((value) => value.data());
    json['shared'] = FieldValue.arrayUnion([data['email']]);
    itemDocument.set(json);
    return uid;
  }

  @override
  Future<String> addUserItemList(UserItemList list) async {
    final itemDocument = userItemLists.doc();
    final uid = itemDocument.id;
    Map<String, dynamic> json = list.toJson();
    json['uid'] = uid;
    Map data = await userDocument.get().then((value) => value.data());
    json['shared'] = FieldValue.arrayUnion([data['email']]);
    itemDocument.set(json);
    return uid;
  }

  /// create new UserItemList under user
  @override
  Future<String> addUserItemListForUser(UserItemList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await userItemLists
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
  Future<String> addUserShopListForUser(UserShopList list) async {
    String uid;
    if (list.uid == null) {
      List<QueryDocumentSnapshot> snapshot = await userShopLists
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
      List<QueryDocumentSnapshot> snapshot = await userShopLists
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
      List<QueryDocumentSnapshot> snapshot = await userItemLists
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

  /// Read Operations
  @override
  Future<Map<String, dynamic>> getCredentials() async {
    DocumentSnapshot doc = await userDocument.get();
    return doc.data();
  }

  @override
  Future<dynamic> getUserByEmail(String email) async {
    List<QueryDocumentSnapshot> snapshots = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.docs);
    if (snapshots.length == 0) {
      return null;
    } else {
      DocumentSnapshot doc = snapshots.elementAt(0);
      return AppUser.fromFirestore(doc);
    }
  }

  @override
  Future<List<UserItem>> getUserItems(UserItemList list) async {
    List<QueryDocumentSnapshot> snapshots = await userItemLists
        .doc(list.uid)
        .collection('user_item')
        .get()
        .then((value) => value.docs);

    return snapshots.map((doc) => UserItem.fromFirestore(doc)).toList();
  }

  @override
  Future<List<UserShop>> getUserShops(UserShopList list) async {
    List<QueryDocumentSnapshot> snapshots = await userShopLists
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
    Map data = snapshots.map((e) => e.data()).toList().elementAt(0);
    String uid = data['uid'];
    DocumentSnapshot target = await userShopLists.doc(uid).get();
    return UserShopList.fromFirestore(target);
  }

  @override
  Future<UserItemList> getTargetItemList() async {
    List<QueryDocumentSnapshot> snapshots =
        await targetItemListCollection.get().then((value) => value.docs);
    Map data = snapshots.map((e) => e.data()).toList().elementAt(0);
    String uid = data['uid'];
    DocumentSnapshot target = await userItemLists.doc(uid).get();
    return UserItemList.fromFirestore(target);
  }

  /// get all userItemList specific to user
  @override
  Future<List<UserItemList>> getUserItemLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userItemListCollection.get().then((value) => value.docs);
    List<DocumentSnapshot> processed = [];
    for (int i = 0; i < snapshots.length; i++) {
      Map data = snapshots.map((e) => e.data()).toList().elementAt(i);
      String uid = data['uid'];
      DocumentSnapshot target = await userItemLists.doc(uid).get();
      processed.add(target);
    }
    return processed.map((doc) => UserItemList.fromFirestore(doc)).toList();
  }

  /// get all userShopList specific to user
  @override
  Future<List<UserShopList>> getUserShopLists() async {
    List<QueryDocumentSnapshot> snapshots =
        await userShopListCollection.get().then((value) => value.docs);
    List<DocumentSnapshot> processed = [];
    for (int i = 0; i < snapshots.length; i++) {
      Map data = snapshots.map((e) => e.data()).toList().elementAt(i);
      String uid = data['uid'];
      DocumentSnapshot target = await userShopLists.doc(uid).get();
      processed.add(target);
    }
    return processed.map((doc) => UserShopList.fromFirestore(doc)).toList();
  }

  @override
  Future<List<String>> getItemListUsers(UserItemList list) async {
    DocumentSnapshot snapshot = await userItemLists.doc(list.uid).get();
    List<String> shared = [];
    Map data = snapshot.data();
    List.from(data['shared']).forEach((element) {
      shared.add(element);
    });

    return shared;
  }

  @override
  Future<UserItemList> getRequestedList(
      String listName, String userEmail) async {
    List<QueryDocumentSnapshot> snapshots = await userItemLists
        .where('name', isEqualTo: listName)
        .where('shared', arrayContains: userEmail)
        .get()
        .then((value) => value.docs);

    for (QueryDocumentSnapshot snapshot in snapshots) {
      Map<String, dynamic> data = snapshot.data();
      String uid = data['uid'];
      if (userItemListCollection.where('uid', isEqualTo: uid).get() != null) {
        DocumentSnapshot target = await userItemLists.doc(uid).get();
        return UserItemList.fromFirestore(target);
      }
    }
    return null;
  }

  @override
  Future<List<String>> getShopListUsers(UserShopList list) async {
    DocumentSnapshot snapshot = await userShopLists.doc(list.uid).get();
    List<String> shared = [];
    Map data = snapshot.data();
    List.from(data['shared']).forEach((element) {
      shared.add(element);
    });
    return shared;
  }

  @override
  Future<Map<String, dynamic>> getExpiredItems() async {
    DocumentSnapshot snapshot = await userItemExpiredDoc.get();
    return snapshot.data();
  }

  @override
  Future<List<Product>> getGiantItems() async {
    List<QueryDocumentSnapshot> snapshots =
        await giantCollection.get().then((value) => value.docs);

    return snapshots.map((doc) => Product.fromFirestore(doc)).toList();
  }

  /// Update Operations
  @override
  Future<void> updateCredentials(Map<String, dynamic> credentials) async {
    userDocument.update(credentials);
  }

  @override
  Future<void> updateUserItem(UserItem item, UserItemList list) async {
    userItemLists
        .doc(list.uid)
        .collection('user_item')
        .doc(item.uid)
        .update(item.toJson());
  }

  @override
  Future<void> updateUserShop(UserShop item, UserShopList list) async {
    userShopLists
        .doc(list.uid)
        .collection('user_shop')
        .doc(item.uid)
        .update(item.toJson());
  }

  @override
  Future<void> updateUserShopList(UserShopList list) async {
    userShopLists.doc(list.uid).update(list.toJson());
  }

  @override
  Future<void> updateUserItemList(UserItemList list) async {
    userItemLists.doc(list.uid).update(list.toJson());
  }

  @override
  Future<void> updateTargetItemList(UserItemList list) async {
    // delete original
    List<QueryDocumentSnapshot> snapshots =
        await targetItemListCollection.get().then((value) => value.docs);
    // get document reference and delete
    List<DocumentReference> doc = snapshots.map((e) => e.reference).toList();
    for (int i = 0; i < doc.length; i++) {
      doc[i].delete();
    }
    // add new list
    addTargetItemList(list);
  }

  @override
  Future<void> updateTargetShopList(UserShopList list) async {
    // delete original
    List<QueryDocumentSnapshot> snapshots =
        await targetShopListCollection.get().then((value) => value.docs);
    // get document reference and delete
    List<DocumentReference> doc = snapshots.map((e) => e.reference).toList();
    for (int i = 0; i < doc.length; i++) {
      doc[i].delete();
    }
    // add new list
    addTargetShopList(list);
  }

  @override
  Future<void> updateGiantItem(Product item) async {
    giantCollection.doc(item.uid).update(item.toJson());
  }

  @override
  Future<void> updateSharedUserItemList(UserItemList list, AppUser user) async {
    userItemLists.doc(list.uid).update({
      "shared": FieldValue.arrayUnion([user.email])
    });

    CollectionReference addedUser = _firestore
        .collection('users')
        .doc(user.username)
        .collection('user_item_list');
    final listDocument = addedUser.doc();
    Map<String, String> json = {'uid': list.uid};
    listDocument.set(json);
  }

  @override
  Future<void> updateSharedUserShopList(UserShopList list, AppUser user) async {
    userShopLists.doc(list.uid).update({
      "shared": FieldValue.arrayUnion([user.email])
    });

    CollectionReference addedUser = _firestore
        .collection('users')
        .doc(user.username)
        .collection('user_shop_list');
    final listDocument = addedUser.doc();
    Map<String, String> json = {'uid': list.uid};
    listDocument.set(json);
  }

  @override
  Future<void> updateExpiredItems(int date, String category) async {
    DocumentReference doc = userItemExpiredDoc;
    List<int> temp = SortedList<int>((r1, r2) => r1.compareTo(r2));
    Map data = await doc.get().then((value) => value.data());
    //data is map of arrays
    //Map<String, dynamic> all = {category: ...};
    if (data != null) {
      if (data.containsKey(category)) {
        List.from(data.remove(category)).forEach((element) {
          temp.add(element);
        });
        temp.add(date);
        data.putIfAbsent(category, () => temp);

        doc.set(data);
      } else {
        temp.add(date);
        data.putIfAbsent(category, () => temp);
        doc.set(data);
      }
    } else {
      temp.add(date);
      final expiredDocument =
          userDocument.collection('expired_items').doc('records');
      Map<String, dynamic> json = {category: temp};
      expiredDocument.set(json);
    }
  }

  /// Delete Operations
  @override
  Future<void> deleteUserItem(UserItem item, UserItemList list) async {
    userItemLists.doc(list.uid).collection('user_item').doc(item.uid).delete();
  }

  @override
  Future<void> deleteExpiredUserItem(UserItem item, UserItemList list) async {
    DateTime current = DateTime.now();
    DateTime today = DateTime(current.year, current.month, current.day);
    int expiry;

    Duration temp =
        DateTime.fromMillisecondsSinceEpoch(item.expiryDate).difference(today);
    if (temp.isNegative) {
      expiry = item.expiryDate;
    } else {
      expiry = today.millisecondsSinceEpoch;
    }

    updateExpiredItems(expiry, item.category.name);
    userItemLists.doc(list.uid).collection('user_item').doc(item.uid).delete();
  }

  @override
  Future<void> deleteUserShop(UserShop item, UserShopList list) async {
    userShopLists.doc(list.uid).collection('user_shop').doc(item.uid).delete();
  }

  @override
  Future<void> deleteUserItemList(UserItemList list) async {
    userItemLists.doc(list.uid).delete();
  }

  @override
  Future<void> deleteUserShopList(UserShopList list) async {
    userShopLists.doc(list.uid).delete();
  }

  @override
  Future<void> deleteUserItemListForUser(UserItemList list) async {
    List<QueryDocumentSnapshot> snapshots = await userItemListCollection
        .where('uid'.toString(), isEqualTo: list.uid.toString())
        .get()
        .then((value) => value.docs);
    // get document reference and delete
    DocumentReference doc = snapshots[0].reference;
    doc.delete();
  }

  @override
  Future<void> deleteUserShopListForUser(UserShopList list) async {
    List<QueryDocumentSnapshot> snapshots = await userShopListCollection
        .where('name', isEqualTo: list.name)
        .get()
        .then((value) => value.docs);
    // get document reference and delete
    DocumentReference doc = snapshots[0].reference;
    doc.delete();
  }
}

import 'package:flutter/material.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';
import 'package:stockup/ui/user_item/user_item_search.dart';

class UserItemViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _db;

  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserItemList> userItemLists = [];
  // List<UserShopList> userShopLists = [];
  int no = 1;
  int noOfCat = 0;

  UserShopList _targetUserShopList;
  UserItemList _targetUserItemList;

  //am using a sorted list package is this okay?
  List<UserItem> _userItems =
      SortedList<UserItem>((r1, r2) => r2.forCompare.compareTo(r1.forCompare));

  /// Only called once. Will not be called again on rebuild
  void init() async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    await _targetUserItemListFromDatabase();
    await _targetUserShopListFromDatabase();
    await _getAllItemList();
    print(_targetUserItemList.uid);
    initialize();
    print('user item view model init called');
    notifyListeners();
  }

  void initialize() async {
    await _getDisplayListFromDatabase();
    for (ProductCategory category in ProductCategory.values) {
      String name = category.name;
      productCategories[name] = false;
    }
  }

  Future<void> _targetUserItemListFromDatabase() async {
    _targetUserItemList = await _db.getTargetItemList();
  }

  Future<void> _targetUserShopListFromDatabase() async {
    _targetUserShopList = await _db.getTargetShopList();
  }

  Future<void> _getDisplayListFromDatabase() async {
    List<UserItem> unorderedItems = await _db.getUserItems(_targetUserItemList);
    _userItems.addAll(unorderedItems);
  }

  Future<void> _getAllItemList() async {
    userItemLists = await _db.getUserItemLists();
  }

  void _updateTargetItemList(UserItemList list) async {
    await _db.updateTargetItemList(list);
    await _targetUserItemListFromDatabase();
  }

  int testCount = 1;
  UserItemList get targetUserItemList {
    testCount += 1;
    String test = _targetUserItemList.uid;
    print("$test called $testCount times");
    return _targetUserItemList;
  }

  List<UserItem> get displayList {
    //return all items in target item list
    if (productCategories['All Categories']) return _userItems;

    //filtering by category
    return _userItems
        .where((element) => productCategories[element.category.name])
        .toList();
  }

  set targetUserItemList(UserItemList newTarget) {
    _updateTargetItemList(newTarget);
    notifyListeners();
  }

  void filter(int index) {
    if (index == 0) {
      noOfCat = 0;
      for (String name in productCategories.keys.toList().sublist(1)) {
        productCategories[name] = false;
      }
      productCategories['All Categories'] = true;
    } else {
      String s = productCategories.keys.toList()[index];
      if (productCategories[s] == true && noOfCat == 1) {
        noOfCat = 0;
        productCategories['All Categories'] = true;
        productCategories[s] = !productCategories[s];
      } else if (productCategories[s] == true && noOfCat > 1) {
        noOfCat -= 1;
        productCategories[s] = !productCategories[s];
      } else if (noOfCat == 0) {
        noOfCat += 1;
        productCategories['All Categories'] = false;
        productCategories[s] = !productCategories[s];
      } else {
        noOfCat += 1;
        productCategories[s] = !productCategories[s];
      }
    }
    notifyListeners();
  }

  UserItemSearch search() {
    return UserItemSearch(displayList);
  }

  onSwipe(DismissDirection direction, int index) {
    UserItem item = displayList[index];
    if (direction == DismissDirection.startToEnd) {
      _snackbarService.showSnackbar(
        message: item.productName,
        title: 'Moved an item to shopping list ${_targetUserShopList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
      move(item);
    } else {
      _snackbarService.showSnackbar(
        message: item.productName,
        title: 'Removed an item from ${_targetUserItemList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
      delete(item);
    }
  }

  void move(UserItem item) {
    UserShop temp = UserShop(
        productID: item.productID,
        category: item.category,
        productName: item.productName,
        imageURL: item.imageURL);
    _database.deleteUserItem(item, _targetUserItemList);
    _database.addUserShop(temp, _targetUserShopList);
    //_userService.moveUserItemAtIndex(index);
    notifyListeners();
  }

  void delete(UserItem item) async {
    await _database.deleteUserItem(item, _targetUserItemList);
    await _getDisplayListFromDatabase();
    notifyListeners();
  }

  void add() {
    UserItem toAdd = UserItem(
      productName: 'Product $no',
      productID: no,
      imageURL: 'url$no',
      category: ProductCategory.values[no % ProductCategory.values.length],
    );
    ++no;
    _db.addUserItem(toAdd, _targetUserItemList);
    // _userService.addUserItem(UserItem(
    //   productName: 'Product $no',
    //   productID: no,
    //   imageURL: 'url$no',
    //   category: ProductCategory.values[no % ProductCategory.values.length],
    // ));

    // ++no;
    _navigationService.replaceWith(Routes.userScanView);
    notifyListeners();
  }

  /// code to be run on rebuild
  void update() {
    notifyListeners();
  }
}

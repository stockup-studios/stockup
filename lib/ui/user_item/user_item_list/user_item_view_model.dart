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
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  //DatabaseServiceImpl _db;

  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserItemList> userItemLists = [];
  // List<UserShopList> userShopLists = [];
  int no = 1;
  int noOfCat = 0;

  UserShopList _targetUserShopList;
  UserItemList _targetUserItemList;

  List<UserItem> _userItems =
      SortedList<UserItem>((r1, r2) => r2.forCompare.compareTo(r1.forCompare));

  /// Only called once. Will not be called again on rebuild
  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await _targetUserItemListFromDatabase();
    await _targetUserShopListFromDatabase();
    await _allItemList();
    initialize();
    print('user item view model init called');
    notifyListeners();
  }

  void initialize() async {
    await _displayListFromDatabase();
    for (ProductCategory category in ProductCategory.values) {
      String name = category.name;
      productCategories[name] = false;
    }
  }

  Future<void> _targetUserItemListFromDatabase() async {
    _targetUserItemList = await _database.getTargetItemList();
  }

  Future<void> _targetUserShopListFromDatabase() async {
    _targetUserShopList = await _database.getTargetShopList();
  }

  Future<void> _displayListFromDatabase() async {
    _userItems.clear();
    print('cleared user items');
    List<UserItem> unorderedItems =
        await _database.getUserItems(_targetUserItemList);
    _userItems.addAll(unorderedItems);
  }

  Future<void> _allItemList() async {
    userItemLists = await _database.getUserItemLists();
  }

  Future<void> _updateTargetItemList(UserItemList list) async {
    await _database.updateTargetItemList(list);
    await _targetUserItemListFromDatabase();
  }

  UserItemList get targetUserItemList {
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

  String getExpiryDays(UserItem item) {
    int daysLeft = item.daysLeft;
    String message = '';
    if (daysLeft < 0) {
      message = "Item expired";
    } else if (daysLeft == 1) {
      message = '$daysLeft day left';
    } else {
      message = '$daysLeft days left';
    }

    return message;
  }

  void updateTargetUserItemList(UserItemList newTarget) async {
    await _updateTargetItemList(newTarget);
    await _displayListFromDatabase();
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

  // onSwipe(DismissDirection direction, int index) {
  //   UserItem item = displayList[index];
  //   if (direction == DismissDirection.startToEnd) {
  //     _snackbarService.showSnackbar(
  //       message: item.productName,
  //       title: 'Moved an item to shopping list ${_targetUserShopList.name}',
  //       duration: Duration(seconds: 2),
  //       onTap: (_) {
  //         print('snackbar tapped');
  //       },
  //     );
  //     move(item);
  //   } else {
  //     _snackbarService.showSnackbar(
  //       message: item.productName,
  //       title: 'Removed an item from ${_targetUserItemList.name}',
  //       duration: Duration(seconds: 2),
  //       onTap: (_) {
  //         print('snackbar tapped');
  //       },
  //     );
  //     delete(item);
  //   }
  // }

  void move(UserItem item) async {
    _snackbarService.showSnackbar(
      message: item.productName,
      title: 'Moved an item to shopping list ${_targetUserShopList.name}',
      duration: Duration(seconds: 2),
      onTap: (_) {
        print('snackbar tapped');
      },
    );
    UserShop temp = UserShop(
        productID: item.productID,
        category: item.category,
        productName: item.productName,
        imageURL: item.imageURL,
        quantity: 1);
    await _database.deleteUserItem(item, _targetUserItemList);
    await _displayListFromDatabase();
    _database.addUserShop(temp, _targetUserShopList);
    //_userService.moveUserItemAtIndex(index);
    notifyListeners();
  }

  void delete(UserItem item) async {
    _snackbarService.showSnackbar(
      message: item.productName,
      title: 'Removed an item from ${_targetUserItemList.name}',
      duration: Duration(seconds: 2),
      onTap: (_) {
        print('snackbar tapped');
      },
    );
    await _database.deleteUserItem(item, _targetUserItemList);
    await _displayListFromDatabase();
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
    _database.addUserItem(toAdd, _targetUserItemList);
    _navigationService.replaceWith(Routes.userScanView);
    notifyListeners();
  }

  /// code to be run on rebuild
  void update() {
    notifyListeners();
  }
}

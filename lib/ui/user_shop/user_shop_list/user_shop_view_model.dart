import 'package:flutter/material.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';
//import 'package:stockup/services/user/user_service.dart';
import 'package:stockup/ui/user_shop/user_shop_search.dart';

class UserShopViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  //DatabaseServiceImpl _db;

  // final _userService = locator<UserService>();
  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserShopList> userShopLists = [];
  int no = 1;
  int noOfCat = 0;

  UserShopList _targetUserShopList;
  UserItemList _targetUserItemList;

  List<UserShop> _userShops =
      SortedList<UserShop>((r1, r2) => r2.quantity.compareTo(r1.quantity));

  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await _targetUserItemListFromDatabase();
    await _targetUserShopListFromDatabase();
    await _allShopList();
    initialize();
    print('user shop view model init called');
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
    _userShops.clear();
    print('cleared user shops');
    List<UserShop> unorderedItems =
        await _database.getUserShops(_targetUserShopList);
    _userShops.addAll(unorderedItems);
  }

  Future<void> _allShopList() async {
    userShopLists = await _database.getUserShopLists();
  }

  Future<void> _updateTargetShopList(UserShopList list) async {
    await _database.updateTargetShopList(list);
    await _targetUserShopListFromDatabase();
  }

  UserShopList get targetUserShopList {
    return _targetUserShopList;
  }

  List<UserShop> get displayList {
    //return all items in target item list
    if (productCategories['All Categories']) return _userShops;

    //filtering by category
    return _userShops
        .where((element) => productCategories[element.category.name])
        .toList();
  }

  void updateTargetUserShopList(UserShopList newTarget) async {
    await _updateTargetShopList(newTarget);
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

  UserShopSearch search() {
    return UserShopSearch(displayList);
  }

  void add() {
    // _userService.addUserShop(
    //   UserShop(
    //     productName: 'Product $no',
    //     productID: no,
    //     imageURL: 'url$no',
    //     category: ProductCategory.values[no % ProductCategory.values.length],
    //   ),
    // );
    // ++no;
    // TODO: Add user shop manually
     _navigationService.replaceWith(Routes.userScanView);
    notifyListeners();
  }

  // onSwipe(DismissDirection direction, int index) {
  //   UserShop item = displayList[index];
  //   if (direction == DismissDirection.startToEnd) {
  //     _snackbarService.showSnackbar(
  //       message: item.productName,
  //       title: 'Removed an item from ${_targetUserShopList.name}',
  //       duration: Duration(seconds: 2),
  //       onTap: (_) {
  //         print('snackbar tapped');
  //       },
  //     );
  //     delete(item);
  //   } else {
  //     _snackbarService.showSnackbar(
  //       message: item.productName,
  //       title: 'Moved an item to item list ${_targetUserItemList.name}',
  //       duration: Duration(seconds: 2),
  //       onTap: (_) {
  //         print('snackbar tapped');
  //       },
  //     );
  //     move(item);
  //   }
  // }

  void move(UserShop item) async {
     _snackbarService.showSnackbar(
        message: item.productName,
        title: 'Moved an item to item list ${_targetUserItemList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
    UserItem temp = UserItem(
      productID: item.productID,
      category: item.category,
      productName: item.productName,
      imageURL: item.imageURL,
    );
    await _database.deleteUserShop(item, _targetUserShopList);
    await _displayListFromDatabase();
    _database.addUserItem(temp, _targetUserItemList);
    //_userService.moveUserItemAtIndex(index);
    notifyListeners();
  }

  void delete(UserShop item) async {
    _snackbarService.showSnackbar(
        message: item.productName,
        title: 'Removed an item from ${_targetUserShopList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
    await _database.deleteUserShop(item, _targetUserShopList);
    await _displayListFromDatabase();
    notifyListeners();
  }

  /// code to be run on rebuild
  void update() {
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/auth/auth_impl.dart';
import 'package:stockup/services/database/database_impl.dart';
import 'package:stockup/services/user/user_service.dart';
import 'package:stockup/ui/user_item/user_item_search.dart';

class UserItemViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _db;

  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserItemList> userItemLists = [];
  // List<UserShopList> userShopLists = [];
  int no = 1;

  UserShopList _targetUserShopList;
  UserItemList _targetUserItemList;
  List<UserItem> _userItems = [];

  /// Only called once. Will not be called again on rebuild
  void init() async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    initialize();
    print('user item view model init called');
    // for (ProductCategory category in ProductCategory.values) {
    //   String name = category.toString().split('.').last.split('_').join(' ');
    //   productCategories[name] = false;
    // }
    // userItemLists = _userService.getUILs();
    notifyListeners();
  }

  void initialize() async {
    _targetUserItemListFromDatabase();
    _getDisplayListFromDatabase();
    _targetUserShopListFromDatabase();
    for (ProductCategory category in ProductCategory.values) {
      String name = category.name;
      productCategories[name] = false;
    }
    userItemLists = await _db.getUserItemLists();
  }

  void _targetUserItemListFromDatabase() async {
    _targetUserItemList = await _db.getTargetItemList();
  }

  void _targetUserShopListFromDatabase() async {
    _targetUserShopList = await _database.getTargetShopList();
  }

  void _getDisplayListFromDatabase() async {
    //UserItemList test = UserItemList(uid: "SWwxUh2capg2ytU2rint");
    _userItems =
        await _db.getUserItems(_targetUserItemList); //_targetUserItemList);
  }

  // NEED CHECK!!
  void _updateTargetItemList(UserItemList list) async {
    await _db.updateTargetItemList(list);
    _targetUserItemListFromDatabase();
  }

  UserItemList get targetUserItemList {
    return _targetUserItemList;
  }

  //FILTERING HERE
  List<UserItem> get displayList {
    //return all items in target item list
    if (productCategories['All Categories'])
      //return targetUserItemList.userItemListing;
      return _userItems;

    //filtering by category
    return _userItems
        .where((element) => productCategories[element.category.name])
        .toList();

    // what's happening here? R we getting only userItems of specific category?
    // return userItems.where((UserItem ui) {
    //   String name = ui.category.toString().split('.').last.split('_').join(' ');
    //   return productCategories[name];
    // }).toList();
  }

  //NEED TEST
  set targetUserItemList(UserItemList newTarget) {
    _updateTargetItemList(newTarget);
    //_userService.setTargetUIL(newTarget);
    notifyListeners();
  }

  // GONNA CHANGE TO DEFAULT ALL CATEGORIES??
  void filter(int index) {
    if (index == 0) {
      for (String name in productCategories.keys.toList().sublist(1)) {
        productCategories[name] = false;
      }
      productCategories['All Categories'] =
          !productCategories['All Categories'];
    } else {
      productCategories['All Categories'] = false;
      String s = productCategories.keys.toList()[index];
      productCategories[s] = !productCategories[s];
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
        message: item.productName, // displayList[index].productName,
        title:
            'Moved an item to shopping list ${_targetUserShopList.name}', //_userService.targetUserShopList.name
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

  void delete(UserItem item) {
    //_userService.delUserItemAtIndex(index);
    _database.deleteUserItem(item, _targetUserItemList);
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

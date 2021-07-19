import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
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
  // UserShopList targetUserShopList;
  int no = 1;

  UserItemList _targetUserItemList;
  List<UserItem> _userItems = [];

  void initialize() async {
    _targetUserItemListFromDatabase();
    _getDisplayListFromDatabase();
  }

  void _targetUserItemListFromDatabase() async {
    //return _userService.getTargetUIL();
    _targetUserItemList = await _db.getTargetItemList();
  }

  void _getDisplayListFromDatabase() async {
    UserItemList test = UserItemList(uid: "SWwxUh2capg2ytU2rint");
    _userItems = await _db.getUserItems(test); //_targetUserItemList);
  }

  void _updateTargetItemList(UserItemList list) async {
    await _db.updateTargetItemList(list);
    _targetUserItemListFromDatabase();
  }

  UserItemList get targetUserItemList {
    return _targetUserItemList;
  }

  List<UserItem> get displayList {
    //return item in this target item list

    if (productCategories['All Categories'])
      //return targetUserItemList.userItemListing;
      return _userItems;

    //checkout product category for name formatting.
    // List<UserItem> filtered = _userItems.where((element) =>
    //     element.category.name.compareTo("//some category name//") == 0);

    // return filtered;
    return _userItems;

    // what's happening here? R we getting only userItems of specific category?
    // return userItems.where((UserItem ui) {
    //   String name = ui.category.toString().split('.').last.split('_').join(' ');
    //   return productCategories[name];
    // }).toList();
  }

  set targetUserItemList(UserItemList newTarget) {
    _updateTargetItemList(newTarget);
    //_userService.setTargetUIL(newTarget);
    notifyListeners();
  }

  /// Only called once. Will not be called again on rebuild
  void init() async {
    _db = DatabaseServiceImpl(uid: _authService.appUser.username);
    initialize();
    print('user item view model init called');
    for (ProductCategory category in ProductCategory.values) {
      String name = category.name;
      productCategories[name] = false;
    }
    // for (ProductCategory category in ProductCategory.values) {
    //   String name = category.toString().split('.').last.split('_').join(' ');
    //   productCategories[name] = false;
    // }
    // userItemLists = _userService.getUILs();
    userItemLists = await _db.getUserItemLists();
    notifyListeners();
  }

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
    if (direction == DismissDirection.startToEnd) {
      _snackbarService.showSnackbar(
        message: displayList[index].productName,
        title:
            'Moved an item to shopping list ${_userService.targetUserShopList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
      move(index);
    } else {
      _snackbarService.showSnackbar(
        message: displayList[index].productName,
        title: 'Removed an item from ${_userService.targetUserItemList.name}',
        duration: Duration(seconds: 2),
        onTap: (_) {
          print('snackbar tapped');
        },
      );
      delete(index);
    }
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

  void move(int index) {
    // _database.deleteUserItem(item, list);
    // _database.addUserShop(item, list);
    _userService.moveUserItemAtIndex(index);
    notifyListeners();
  }

  void delete(int index) {
    _userService.delUserItemAtIndex(index);
    notifyListeners();
  }

  /// code to be run on rebuild
  void update() {
    notifyListeners();
  }
}

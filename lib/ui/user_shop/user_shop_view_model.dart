import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/user/user_service.dart';
import 'package:stockup/ui/user_shop/user_shop_search.dart';

class UserShopViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserShopList> userShopLists = [];
  int no = 1;

  UserShopList get targetUserShopList {
    return _userService.getTargetUSL();
  }

  List<UserShop> get displayList {
    if (productCategories['All Categories'])
      return targetUserShopList.userShopListing;

    return targetUserShopList.userShopListing.where((UserShop ui) {
      String name = ui.category.toString().split('.').last.split('_').join(' ');
      return productCategories[name];
    }).toList();
  }

  set targetUserShopList(UserShopList newTarget) {
    _userService.setTargetUSL(newTarget);
    notifyListeners();
  }

  /// Only called once. Will not be called again on rebuild
  void init() {
    print('user shop view model init called');
    for (ProductCategory category in ProductCategory.values) {
      String name = category.toString().split('.').last.split('_').join(' ');
      productCategories[name] = false;
    }
    userShopLists = _userService.getUSLs();
    targetUserShopList = _userService.getTargetUSL();
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
    notifyListeners();
  }

  onSwipe(DismissDirection direction, int index) {
    if (direction == DismissDirection.startToEnd)
      move(index);
    else
      delete(index);
  }

  void move(int index) {
    _userService.moveUserShopAtIndex(index);
    notifyListeners();
  }

  void delete(int index) {
    _userService.delUserShopAtIndex(index);
    notifyListeners();
  }

  void edit(int index) {
    // TODO: Edit user shop
  }
}

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/user/user_service.dart';
import 'package:stockup/ui/user_item/user_item_search.dart';

class UserItemViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  final Map<String, bool> productCategories = {'All Categories': true};
  List<UserItemList> userItemLists = [];
  List<UserShopList> userShopLists = [];
  UserShopList targetUserShopList;
  int no = 1;

  UserItemList get targetUserItemList {
    return _userService.getTargetUIL();
  }

  List<UserItem> get displayList {
    if (productCategories['All Categories'])
      return targetUserItemList.userItemListing;

    return targetUserItemList.userItemListing.where((UserItem ui) {
      String name = ui.category.toString().split('.').last.split('_').join(' ');
      return productCategories[name];
    }).toList();
  }

  set targetUserItemList(UserItemList newTarget) {
    _userService.setTargetUIL(newTarget);
    notifyListeners();
  }

  /// Only called once. Will not be called again on rebuild
  void init() {
    print('user item view model init called');
    for (ProductCategory category in ProductCategory.values) {
      String name = category.toString().split('.').last.split('_').join(' ');
      productCategories[name] = false;
    }
    userItemLists = _userService.getUILs();
    targetUserItemList = _userService.getTargetUIL();
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

  void onConsume(int index) {
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

  void onMove(int index) {
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
  }

  void add() {
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

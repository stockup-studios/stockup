import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/user/user_service.dart';
import 'package:stockup/ui/user_shop/user_shop_search.dart';

class UserShopViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final Map<String, bool> productCategories = {'All Categories': true};
  final _snackbarService = locator<SnackbarService>();

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

  void onDelete(int index) {
    _snackbarService.showSnackbar(
      message: displayList[index].productName,
      title: 'Removed an item from ${_userService.targetUserShopList.name}',
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
          'Moved an item to item list ${_userService.targetUserItemList.name}',
      duration: Duration(seconds: 2),
      onTap: (_) {
        print('snackbar tapped');
      },
    );
    move(index);
  }

  void move(int index) {
    _userService.moveUserShopAtIndex(index);
    notifyListeners();
  }

  void delete(int index) {
    _userService.delUserShopAtIndex(index);
    notifyListeners();
  }

  /// code to be run on rebuild
  void update() {
    notifyListeners();
  }
}
